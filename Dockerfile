FROM alpine:latest
RUN apk add --no-cache openjdk21-jre-headless

WORKDIR /minecraft-server

RUN apk add --no-cache jq curl && \
    API_URL="https://api.papermc.io/v2/projects/paper" && \
    VERSION=$(curl -s $API_URL | jq -r '.versions | last') && \
    BUILD=$(curl -s $API_URL/versions/$VERSION | jq -r '.builds | last') && \
    JAR_NAME="paper-$VERSION-$BUILD.jar" && \
    curl -o paper.jar -L "$API_URL/versions/$VERSION/builds/$BUILD/downloads/$JAR_NAME" && \
    apk del --no-cache jq curl

RUN echo "eula=true" > eula.txt

EXPOSE 25565

ENTRYPOINT [ "java", "-jar", "paper.jar" ]
