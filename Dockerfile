FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7

LABEL maintainer="PJ Linebaugh <pjl@renci.org>"

# RUN pip install fastapi

COPY ./app /app
