from fastapi import FastAPIapp

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "It ran main successfully"}