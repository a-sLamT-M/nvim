#!/bin/bash

# 设置Java版本和目标安装路径
JAVA17_VERSION="jdk-17"
JAVA8_VERSION="jdk-8u202"
JAVA17_HOME="/usr/lib/jdtls_java/$JAVA17_VERSION"
JAVA8_HOME="/usr/lib/nvim-jdk/java-8-openjdk-amd64"

mkdir -p "$JAVA17_HOME"
mkdir -p "$JAVA8_HOME"

wget -O "/tmp/$JAVA17_VERSION.tar.gz" "https://cdn.azul.com/zulu/bin/zulu17.50.19-ca-jdk17.0.11-linux_x64.tar.gz"
wget -O "/tmp/$JAVA8_VERSION.tar.gz" "https://cdn.azul.com/zulu/bin/zulu8.78.0.19-ca-jdk8.0.412-linux_x64.tar.gz"

tar -xzf "/tmp/$JAVA17_VERSION.tar.gz" --directory "$JAVA17_HOME" --strip-components=1
tar -xzf "/tmp/$JAVA8_VERSION.tar.gz" --directory "$JAVA8_HOME" --strip-components=1

rm "/tmp/$JAVA17_VERSION.tar.gz"
rm "/tmp/$JAVA8_VERSION.tar.gz"

echo "Java 17 and Java 8 have been installed."
