from api.routers import router as api_router
from fastapi import FastAPI
from security.routers import router as security_router

app = FastAPI()
app.include_router(api_router)
app.include_router(security_router)
