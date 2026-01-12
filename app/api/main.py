from fastapi import FastAPI
from dotenv import load_dotenv
from api.controllers import journal_router
from api.loging import logger
from prometheus_client import make_asgi_app

load_dotenv()

app = FastAPI(title="Logging API")
metrics_app = make_asgi_app()
app.mount("/metrics", metrics_app)

app.include_router(journal_router)

