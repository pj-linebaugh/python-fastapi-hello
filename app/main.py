import sys

from fastapi import FastAPI
from starlette.requests import Request
from starlette.responses import Response

app = FastAPI()

@app.get("/")
async def read_root(request: Request):
    client_host = request.client.host
    response = "hello %s" % client_host
    return Response(content=response)

