import os
import litellm
from time import time
from guardrails import Guard
from guardrails.hub import ToxicLanguage
from guardrails.errors import ValidationError
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, ConfigDict, Field
from typing import List, TypedDict




# Create logger
import logging
logger = logging.getLogger(__name__)
level = os.getenv("LOG_LEVEL", "INFO")
logging.basicConfig(level=level)
logger.setLevel(level)
handler = logging.StreamHandler()
handler.setLevel(level)
handler.setFormatter(logging.Formatter("%(asctime)s - %(levelname)s - %(message)s"))
logger.addHandler(handler)


app = FastAPI()

origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.exception_handler(Exception)
async def error_handler(request: Request, exc: Exception):
    import traceback
    traceback.print_exception(exc)
    return JSONResponse(
        status_code=500,
        content={"message": str(exc)},
    )

class Message(TypedDict):
    role: str
    content: str

class ChatCompletionRequestBody(BaseModel):
    model_config = ConfigDict(extra='allow')
    
    messages: List[Message] = Field(
        ...,
        description="List of messages to send to the model. Each message should have a 'role' and 'content'.",
    )

@app.get("/health")
async def health_check():
    return {"status": "ok"}

@app.post("/chat/completions")
async def chat_completions(body: ChatCompletionRequestBody):
    messages = body.messages

    OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

    guard = Guard().use(
        ToxicLanguage()
    )

    completion_start = time()
    completion = litellm.ModelResponse(choices=[
        litellm.Choices(message=litellm.Message(content="Hello, world!", role="assistant"))
    ])
    completion_end = time()
    completion_duration = completion_end - completion_start
    logger.info(f"==> Chat Completion took {completion_duration} seconds")

    validation_start = time()
    chat_response = None
    try:
        response = completion.choices[0].message
        guarded_response = guard.validate(llm_output=response.content)
        response_messages = [*messages]
        response_messages.append({
            "role": response.role,
            "content": guarded_response.validated_output
        })
        chat_response = response_messages
    except ValidationError as ve:
        chat_response = JSONResponse(
            status_code=500,
            content={"message": str(ve)},
        )
    finally:
        validation_end = time()
        validation_duration = validation_end - validation_start
        logger.info(f"==> Validation with Guardrails AI took {validation_duration} seconds")

        return chat_response

