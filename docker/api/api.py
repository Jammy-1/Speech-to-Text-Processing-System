from fastapi import FastAPI, UploadFile, File, HTTPException
from pydantic import BaseModel, Field
from azure.identity import DefaultAzureCredential
from azure.servicebus import ServiceBusClient, ServiceBusMessage
import logging, uuid, json

# Logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("stt-api")

# FastAPI App
app = FastAPI(title="STT API", version="1.0.0")

# Env Variables
SERVICE_BUS_FQDN = os.getenv("SERVICE_BUS_FQDN")
STORAGE_QUEUE_NAME = os.getenv("STORAGE_QUEUE_NAME")  

if not SERVICE_BUS_FQDN or not STORAGE_QUEUE_NAME:
    raise RuntimeError("Missing Environment Variables: SERVICE_BUS_FQDN, STORAGE_QUEUE_NAME")

# Service Bus Client
credential = DefaultAzureCredential()
sb_client = ServiceBusClient(
    fully_qualified_namespace=SERVICE_BUS_FQDN,
    credential=credential
)
sb_sender = sb_client.get_queue_sender(STORAGE_QUEUE_NAME)

# Upload 
@app.post("/upload", status_code=202)
async def upload_file(file: UploadFile = File(...), language: str = "en-US"):
    
    job_id = str(uuid.uuid4())
    message_body = {
        "job_id": job_id,
        "original_file_name": file.filename,
        "language": language,
        "file_content": await file.read()  
    }

    try:
        message = ServiceBusMessage(
            body=json.dumps(message_body),
            content_type="application/json",
            message_id=job_id,
            correlation_id=job_id,
            subject="storage-job"
        )
        sb_sender.send_messages(message)
        logger.info("Queued Storage Job %s For File %s", job_id, file.filename)
        return {"status": "queued", "job_id": job_id, "file_name": file.filename}

    except Exception:
        logger.exception("Failed To Queue Storage Job")
        raise HTTPException(status_code=500, detail="Failed To Queue Storage Job")
