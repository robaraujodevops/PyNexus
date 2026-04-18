from fastapi import FastAPI
from app.core.config import settings

app = FastAPI(
    title=settings.PROJECT_NAME,
    debug=settings.DEBUG
)

@app.get("/config")
async def get_config():
    return {
        "project_name": settings.PROJECT_NAME,
        "is_debug": settings.DEBUG
    }

@app.get("/health", tags=["Health"])
async def health_check():
    return {"status": "online", "version": "0.1.0"}
