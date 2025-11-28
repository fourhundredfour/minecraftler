#!/usr/bin/env sh
set -e

PROJECT="paper"
USER_AGENT="Minecraftler/1.0.0"

echo "Fetching latest PaperMC version..."
VERSIONS_RESPONSE=$(curl -s -H "User-Agent: $USER_AGENT" "https://api.papermc.io/v2/projects/${PROJECT}")
LATEST_VERSION=$(echo "$VERSIONS_RESPONSE" | jq -r '.versions[-1]')

if [ -z "$LATEST_VERSION" ] || [ "$LATEST_VERSION" = "null" ]; then
    echo "Error: Could not fetch latest version"
    echo "API Response: $VERSIONS_RESPONSE"
    exit 1
fi

echo "Latest version: $LATEST_VERSION"

echo "Fetching latest build..."
BUILDS_RESPONSE=$(curl -s -H "User-Agent: $USER_AGENT" "https://api.papermc.io/v2/projects/${PROJECT}/versions/${LATEST_VERSION}/builds")
LATEST_BUILD=$(echo "$BUILDS_RESPONSE" | jq -r '.builds[-1].build')

if [ -z "$LATEST_BUILD" ] || [ "$LATEST_BUILD" = "null" ]; then
    echo "Error: Could not fetch latest build"
    echo "API Response: $BUILDS_RESPONSE"
    exit 1
fi

echo "Latest build: $LATEST_BUILD"

# Get the actual JAR filename from the API response
JAR_FILENAME=$(echo "$BUILDS_RESPONSE" | jq -r '.builds[-1].downloads.application.name')

if [ -z "$JAR_FILENAME" ] || [ "$JAR_FILENAME" = "null" ]; then
    # Fallback to constructed filename if API doesn't provide it
    JAR_FILENAME="paper-$LATEST_VERSION-$LATEST_BUILD.jar"
fi

JAR_FILE="$JAR_FILENAME"

if [ ! -f "$JAR_FILE" ]; then
    echo "Downloading PaperMC $LATEST_VERSION build $LATEST_BUILD..."
    curl -L -H "User-Agent: $USER_AGENT" -o "$JAR_FILE" \
        "https://api.papermc.io/v2/projects/${PROJECT}/versions/${LATEST_VERSION}/builds/${LATEST_BUILD}/downloads/${JAR_FILENAME}"
    echo "Download complete!"
else
    echo "PaperMC JAR already exists: $JAR_FILE"
fi

if [ "$EULA" = "true" ]; then
    echo "EULA=true detected, creating eula.txt..."
    echo "eula=true" > eula.txt
    echo "eula.txt created successfully"
fi

echo "Starting PaperMC server..."
exec java -Xms1G -Xmx1G -jar "$JAR_FILE" nogui

