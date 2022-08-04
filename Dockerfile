FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7

LABEL maintainer="PJ Linebaugh <pjl@renci.org>"

# add some time to exec into container and look around
RUN sleep 300

COPY ./app /app
