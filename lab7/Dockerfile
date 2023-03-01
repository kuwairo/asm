FROM arm64v8/ubuntu:jammy

RUN apt-get update && apt-get install -y \
    gcc \
    vim \
    make \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
