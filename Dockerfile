# Use Ubuntu with OpenJDK 21
FROM eclipse-temurin:21-jdk

# Set environment variables
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools

# Install required dependencies (screenshot tests need fonts)
RUN apt-get update && \
    apt-get install -y wget unzip git libfreetype6 fontconfig fonts-dejavu && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Android SDK Command Line Tools
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip -q /tmp/cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm /tmp/cmdline-tools.zip

# Accept Android SDK licenses
RUN yes | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --licenses || true

# Install required Android SDK packages (matching GitHub Actions workflow)
RUN ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager \
    "platform-tools" \
    "platforms;android-36" \
    "platforms;android-34" \
    "platforms;android-33" \
    "build-tools;35.0.0"

# Set working directory
WORKDIR /workspace

# Copy project files
COPY . .

# Configure git to trust the workspace directory (needed for mounted volumes)
RUN git config --global --add safe.directory /workspace

# Make gradlew executable
RUN chmod +x ./gradlew

# Run the build
CMD ["sh", "-c", "git config --global --add safe.directory /workspace && ./gradlew compileDebugKotlin assembleRelease"]

