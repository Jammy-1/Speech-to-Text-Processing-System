import json
import os
import signal
import sys
import tempfile
import logging
import subprocess
from pathlib import Path

from azure.identity import DefaultAzureCredential
from azure.servicebus import ServiceBusClient
from azure.storage.blob import ContainerClient
import azure.cognitiveservices.speech as speechsdk

# Logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s - %(message)s"
)
log = logging.getLogger("speech-worker")

# Env 
def env(name: str) -> str:
    value = os.getenv(name)
    if not value:
        raise RuntimeError(f"[ENV ERROR] Missing environment variable: {name}")
    return value

# ENV (Injected via K8s)
SERVICE_BUS_NAMESPACE      = env("SERVICE_BUS_NAMESPACE")
SPEECH_QUEUE_NAME          = env("SERVICE_BUS_QUEUE_SPEECH")

STORAGE_ACCOUNT_NAME       = env("STORAGE_ACCOUNT_NAME")
AUDIO_CONTAINER_NAME       = env("AUDIO_CONTAINER_NAME")
TRANSCRIPTS_CONTAINER_NAME = env("TRANSCRIPTS_CONTAINER_NAME")

SPEECH_ENDPOINT            = env("SPEECH_ENDPOINT")    
SPEECH_REGION              = env("SPEECH_REGION")

SERVICE_BUS_FQDN = f"{SERVICE_BUS_NAMESPACE}.servicebus.windows.net"

# Azure Credentials
credential = DefaultAzureCredential()

# Service Bus
sb_client = ServiceBusClient(
    fully_qualified_namespace=SERVICE_BUS_FQDN,
    credential=credential
)

# Blob Storage
audio_container_client = ContainerClient(
    account_url=f"https://{STORAGE_ACCOUNT_NAME}.blob.core.windows.net",
    container_name=AUDIO_CONTAINER_NAME,
    credential=credential
)

transcripts_container_client = ContainerClient(
    account_url=f"https://{STORAGE_ACCOUNT_NAME}.blob.core.windows.net",
    container_name=TRANSCRIPTS_CONTAINER_NAME,
    credential=credential
)

# Speech
speech_config = speechsdk.SpeechConfig(
    endpoint=SPEECH_ENDPOINT
)
speech_config.speech_recognition_language = "en-US"

# Storage 
def download_audio(blob_name: str) -> str:
    suffix = Path(blob_name).suffix or ".bin"
    temp_file = tempfile.NamedTemporaryFile(delete=False, suffix=suffix)

    log.info("Downloading audio blob: %s", blob_name)
    blob_client = audio_container_client.get_blob_client(blob_name)

    with open(temp_file.name, "wb") as f:
        blob_client.download_blob().readinto(f)

    return temp_file.name

def extract_audio(input_path: str) -> str:
    audio_file = tempfile.NamedTemporaryFile(delete=False, suffix=".wav").name
    log.info("Extracting audio → WAV: %s", audio_file)

    subprocess.run(
        [
            "ffmpeg", "-y",
            "-i", input_path,
            "-vn",
            "-acodec", "pcm_s16le",
            "-ar", "16000",
            "-ac", "1",
            audio_file
        ],
        check=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )

    return audio_file

def upload_transcript(file_id: str, text: str):
    blob_name = f"{file_id}.txt"
    log.info("Uploading transcript: %s", blob_name)

    blob_client = transcripts_container_client.get_blob_client(blob_name)
    blob_client.upload_blob(text, overwrite=True)

# Speech
def transcribe(audio_path: str, language: str) -> str:
    speech_config.speech_recognition_language = language
    audio_config = speechsdk.AudioConfig(filename=audio_path)
    recognizer = speechsdk.SpeechRecognizer(
        speech_config=speech_config,
        audio_config=audio_config
    )

    result = recognizer.recognize_once()

    if result.reason != speechsdk.ResultReason.RecognizedSpeech:
        raise RuntimeError(f"Speech recognition failed: {result.reason}")

    return result.text

# Worker Loop
def run():
    log.info("Speech worker started")

    with sb_client.get_queue_receiver(
        queue_name=SPEECH_QUEUE_NAME,
        max_wait_time=30,
        prefetch_count=5
    ) as receiver:

        for msg in receiver:
            try:
                payload = json.loads(msg.body.decode("utf-8"))

                file_id   = payload["file_id"]
                blob_name = payload["audio_blob_name"]
                language  = payload.get("language", "en-US")

                input_file = download_audio(blob_name)

                ext = Path(input_file).suffix.lower()
                if ext in {".mp4", ".mov", ".mkv"}:
                    audio_file = extract_audio(input_file)
                else:
                    audio_file = input_file

                text = transcribe(audio_file, language)
                upload_transcript(file_id, text)

                log.info("Transcription completed: %s", file_id)

                receiver.complete_message(msg)

            except Exception:
                log.exception("Speech worker failed")
                receiver.abandon_message(msg)

            finally:
                for f in [locals().get("input_file"), locals().get("audio_file")]:
                    if f and os.path.exists(f):
                        os.remove(f)

# Shutdown
def shutdown(sig, frame):
    log.info("Shutdown signal received")
    sys.exit(0)

signal.signal(signal.SIGTERM, shutdown)
signal.signal(signal.SIGINT, shutdown)

if __name__ == "__main__":
    run()
