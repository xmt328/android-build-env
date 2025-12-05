FROM debian:bookworm-slim
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY --from=eclipse-temurin:21 $JAVA_HOME $JAVA_HOME

ENV DEBIAN_FRONTEND=noninteractive
RUN sed -i "s@http://deb.debian.org/debian@http://mirrors.cloud.tencent.com/debian@g" /etc/apt/sources.list.d/debian.sources
RUN apt-get update && apt-get install -y git wget unzip

ENV ANDROID_HOME /opt/android-sdk
ARG cmdlineTools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools/latest && cd ${ANDROID_HOME} && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip -O commandlinetools-linux.zip && \
    unzip commandlinetools-linux.zip -d commandlinetools-linux && \
    mv commandlinetools-linux/cmdline-tools/* cmdline-tools/latest && \
    rm -rf commandlinetools-linux commandlinetools-linux.zip && \
    yes | ./cmdline-tools/latest/bin/sdkmanager --licenses

RUN $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "platform-tools"
RUN $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "platforms;android-36"
RUN $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "build-tools;36.0.0"
