#!/bin/bash

# Define necessary directories and file paths
JDTLS_DIR="$HOME/jdtls"
PLUGINS_DIR="$JDTLS_DIR/plugins"
LOMBOK_JAR_URL="https://projectlombok.org/downloads/lombok.jar"
JDTLS_JAR_URL="https://download.eclipse.org/jdtls/snapshots/jdt-language-server-latest.tar.gz"  # Update this URL with the actual download link

# lombok

# Create plugins directory
mkdir -p "$PLUGINS_DIR"
echo "Directory created at $PLUGINS_DIR"

# Download Lombok JAR
echo "Downloading Lombok..."
curl -L "$LOMBOK_JAR_URL" -o "$PLUGINS_DIR/lombok.jar"
if [ $? -eq 0 ]; then
    echo "Lombok download complete."
else
    echo "Failed to download Lombok."
    exit 1
fi

echo "Install successfully."
