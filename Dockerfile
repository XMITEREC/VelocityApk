# Dockerfile for building Android + Java17 environment in Gitpod

FROM openjdk:17-jdk-slim

# 1) Set environment variables
ENV ANDROID_HOME="/sdk"
ENV ANDROID_SDK_ROOT="/sdk"

# 2) Install basic packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# 3) Make folder for cmdline-tools
RUN mkdir -p /sdk/cmdline-tools/latest
WORKDIR /sdk/cmdline-tools/latest

# 4) Download & unzip command-line tools into "latest"
ARG CMDLINE_TOOLS_VERSION=9477386
RUN wget "https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_TOOLS_VERSION}_latest.zip" -O cmdline-tools.zip \
    && unzip cmdline-tools.zip \
    && rm cmdline-tools.zip

# 5) Update PATH so "sdkmanager" is visible
ENV PATH="$PATH:/sdk/cmdline-tools/latest/bin:/sdk/platform-tools"

# 6) Debug step (verify sdkmanager is present)
RUN ls -la /sdk/cmdline-tools/latest/bin

# 7) Accept licenses
RUN yes | sdkmanager --licenses

# 8) Install build-tools & platform
RUN sdkmanager --update \
    && sdkmanager \
       "platform-tools" \
       "platforms;android-34" \
       "build-tools;34.0.0"

# 9) (Optional) Install Gradle (if you prefer direct gradle calls)
RUN wget https://services.gradle.org/distributions/gradle-8.2.1-bin.zip -O gradle.zip \
    && unzip gradle.zip -d /opt \
    && rm gradle.zip \
    && ln -s /opt/gradle-8.2.1/bin/gradle /usr/bin/gradle

# 10) Set workspace
WORKDIR /workspace
