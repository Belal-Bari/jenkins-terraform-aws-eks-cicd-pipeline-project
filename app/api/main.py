from fastapi import FastAPI
from dotenv import load_dotenv
from api.controllers import journal_router
from api.loging import logger

load_dotenv()

# TODO: Setup basic console logging
# Hint: Use logging.basicConfig() with level=logging.INFO



app = FastAPI(title="Logging API")
app.include_router(journal_router)