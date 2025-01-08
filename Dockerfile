# 1) Base image with Java 17
FROM openjdk:17-jdk-slim

# 2) Environment variables for Android SDK
ENV ANDROID_HOME="/sdk"
ENV ANDROID_SDK_ROOT="/sdk"

# We add the tools *after* we define them, so 'sdkmanager' is found in PATH.
ENV PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

# 3) Install essential packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# 4) Download the Android command-line tools (CMDLINE_TOOLS_VERSION can be updated as needed)
ARG CMDLINE_TOOLS_VERSION=9477386
RUN mkdir -p $ANDROID_HOME/cmdline-tools/latest && \
    cd $ANDROID_HOME/cmdline-tools/latest && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_TOOLS_VERSION}_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip && \
    rm cmdline-tools.zip

# 5) Accept SDK licenses
RUN yes | sdkmanager --licenses

# 6) Install needed components (build-tools, platform)
RUN sdkmanager --update && \
    sdkmanager \
    "platform-tools" \
    "platforms;android-34" \
    "build-tools;34.0.0"

# 7) (Optional) Install a specific Gradle version or rely on gradlew
RUN wget https://services.gradle.org/distributions/gradle-8.2.1-bin.zip -O gradle.zip && \
    unzip gradle.zip -d /opt && \
    rm gradle.zip && \
    ln -s /opt/gradle-8.2.1/bin/gradle /usr/bin/gradle

# 8) Workdir
WORKDIR /workspace
