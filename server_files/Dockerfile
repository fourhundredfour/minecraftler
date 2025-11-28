FROM eclipse-temurin:21-jre-alpine

EXPOSE 25565

WORKDIR /minecraft
VOLUME ["/minecraft"]

RUN addgroup -g 1000 minecraft && \
    adduser -D -u 1000 -G minecraft minecraft && \
    mkdir -p /minecraft && \
    chown -R minecraft:minecraft /minecraft

RUN apk add --no-cache curl jq

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && \
    chown minecraft:minecraft /entrypoint.sh

USER minecraft

ENTRYPOINT ["/entrypoint.sh"]
