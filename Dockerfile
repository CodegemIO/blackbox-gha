FROM ubuntu:20.04

RUN apt-get update && apt-get install -y gnupg && rm -rf /var/lib/apt/lists/*
USER 1001

COPY bin /usr/local/bin/
COPY src /src/

ENTRYPOINT ["/src/run.sh"]
