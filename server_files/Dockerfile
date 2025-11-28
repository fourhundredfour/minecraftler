FROM alpine/java:21-jre

EXPOSE 25565

WORKDIR /minecraft
VOLUME ["/minecraft"]

RUN adduser -D -u 1000 minecraft && \
    mkdir -p /minecraft && \
    chown -R minecraft:minecraft /minecraft

RUN apk add --no-cache curl jq

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && \
    chown minecraft:minecraft /entrypoint.sh

USER minecraft

ENTRYPOINT ["/entrypoint.sh"]
