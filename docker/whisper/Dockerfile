FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    ffmpeg \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

RUN git clone https://github.com/openai/whisper.git /app/whisper

RUN pip install /app/whisper

RUN pip install torch

ENTRYPOINT ["whisper"]
