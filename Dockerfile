# Dockerfile to set up Java, Android SDK, Gradle, etc.

FROM openjdk:17-jdk-slim

# Set env vars for Android SDK
ENV ANDROID_HOME="/sdk"
ENV ANDROID_SDK_ROOT="/sdk"
ENV PATH="$PATH:$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/34.0.0/"

# Install basic packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Download Android command-line tools
RUN mkdir -p /sdk/cmdline-tools && cd /sdk/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdline-tools.zip && \
    mkdir tools && \
    unzip cmdline-tools.zip -d tools && \
    rm cmdline-tools.zip

# Accept licenses
RUN yes | sdkmanager --licenses

# Install required SDK packages
RUN sdkmanager --update && sdkmanager "platform-tools" "build-tools;34.0.0" "platforms;android-34"

# Optional: Install Gradle globally (if you prefer to use it instead of gradlew)
RUN wget https://services.gradle.org/distributions/gradle-8.2.1-bin.zip -O gradle.zip && \
    unzip gradle.zip -d /opt && \
    rm gradle.zip && \
    ln -s /opt/gradle-8.2.1/bin/gradle /usr/bin/gradle

WORKDIR /workspace
