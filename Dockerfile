FROM alpine:latest
RUN apk add openjdk21 jq curl

WORKDIR /minecraft-server

RUN API_URL="https://api.papermc.io/v2/projects/paper" && \
    VERSION=$(curl -s $API_URL | jq -r '.versions | last') && \
    BUILD=$(curl -s $API_URL/versions/$VERSION | jq -r '.builds | last') && \
    JAR_NAME="paper-$VERSION-$BUILD.jar" && \
    curl -o paper.jar -L "$API_URL/versions/$VERSION/builds/$BUILD/downloads/$JAR_NAME"

RUN echo "eula=true" > eula.txt

EXPOSE 25565

ENTRYPOINT [ "java", "-jar", "paper.jar" ]