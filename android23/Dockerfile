FROM debian:stretch
MAINTAINER "timbaler"

RUN apt-get update && apt-get install --no-install-recommends -y \
        default-jre=2:1.8-58 \
        default-jdk=2:1.8-58 \
	libgradle-android-plugin-java \
        libgradle-android-plugin-java-doc \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN echo "deb http://ftp.debian.org/debian sid main" >> /etc/apt/sources.list \
 && apt-get update && apt-get install --no-install-recommends -y \
        android-sdk\
	android-sdk-helper \
        android-sdk-platform-23 \
	nodejs \
	npm \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && npm install -g cordova \
 && echo '#!/bin/sh\necho "android-23"' > /usr/local/bin/android \
 && chmod a+x /usr/local/bin/android \
 && cd /usr/lib/android-sdk/tools/templates/gradle/wrapper && gradle wrapper \
 && echo "export ANDROID_HOME=/usr/lib/android-sdk" >> /root/.bashrc

RUN export ANDROID_HOME=/usr/lib/android-sdk \
    && cordova create app \
    && cd app \
    && cordova platform add browser \
    && cordova platform add android@5.0.0

WORKDIR /app
ENV ANDROID_HOME /usr/lib/android-sdk
CMD ["cordova", "serve"]
