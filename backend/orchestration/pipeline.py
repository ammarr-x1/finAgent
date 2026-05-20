from datetime import datetime
import uuid
from typing import Dict, Any

from models.schemas import PipelineContext
from agents.base_agent import BaseAgent

class Pipeline:
    def __init__(self, agents: list[BaseAgent]):
        self.agents = agents

    async def run(self, trigger_event: Dict[str, Any]) -> PipelineContext:
        context = PipelineContext(
            run_id=str(uuid.uuid4()),
            trigger_event=trigger_event,
            started_at=datetime.now()
        )
        
        # Sequentially run agents
        for agent in self.agents:
            # We would pass the context dict, but here just simulating
            contract = await agent.execute(context.model_dump())
            context.trace_log.append(contract)
            
        context.completed_at = datetime.now()
        return context
