
from fastapi import FastAPI
from routers.journal import router as journal_router

app = FastAPI()


@app.get("/")
def home():
    return {"message": "EmoStar backend is running"}


app.include_router(journal_router)