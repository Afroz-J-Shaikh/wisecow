FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y bash fortune-mod cowsay netcat-openbsd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/games:$PATH"

WORKDIR /app

COPY wisecow.sh .

RUN chmod +x /app/wisecow.sh && \
    useradd -m wisecow && \
    chown wisecow:wisecow /app

USER wisecow

EXPOSE 4499

CMD ["/app/wisecow.sh"]