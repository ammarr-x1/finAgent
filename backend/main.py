from fastapi import FastAPI, WebSocket
from fastapi.middleware.cors import CORSMiddleware
from typing import Dict, Any

app = FastAPI(title="FinAgent Backend", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/api/v1/pipeline/run")
async def trigger_pipeline():
    return {"status": "started", "run_id": "test_run_id"}

@app.get("/api/v1/pipeline/{run_id}")
async def get_pipeline_status(run_id: str):
    return {"run_id": run_id, "status": "completed"}

@app.get("/api/v1/trace/{run_id}")
async def get_pipeline_trace(run_id: str):
    return {"run_id": run_id, "trace_log": []}

@app.get("/api/v1/portfolio")
async def get_portfolio():
    return {"status": "ok", "portfolio": {}}

@app.get("/api/v1/portfolio/history")
async def get_portfolio_history():
    return {"history": []}

@app.post("/api/v1/portfolio/reset")
async def reset_portfolio():
    return {"status": "reset"}

@app.post("/api/v1/scenario/{name}")
async def load_scenario(name: str):
    return {"status": "loaded", "scenario": name}

@app.websocket("/api/v1/stream")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    await websocket.send_json({"type": "info", "message": "Connected to FinAgent trace stream"})
    try:
        while True:
            data = await websocket.receive_text()
            await websocket.send_text(f"Message text was: {data}")
    except Exception as e:
        print(f"WebSocket Error: {e}")
