FROM ubuntu:18.04

MAINTAINER xiaoman

#
# Update Base Packages && Upgrade
#

RUN apt-get update -qq --no-install-recommends && apt-get upgrade -qq --no-install-recommends && apt-get autoclean

#
# Installing Base Packages
#

RUN apt-get install -qq --no-install-recommends \
    coreutils \
    unzip \
    git \
    unzip \
    wget \
    zip \
    tar && \
    apt-get autoclean


#
# Install openjdk
#

RUN apt-get install -qq --no-install-recommends \
    openjdk-8-jdk && \
    apt-get autoclean

#
# Install Android SDK
#

# Get the latest version from https://developer.android.com/studio/index.html
ENV ANDROID_SDK_ROOT="/opt/android-sdk"
ENV ANDROID_SDK_TOOLS_VERSION="4333796"
# Download Android SDK
RUN echo "Installing sdk tools ${ANDROID_SDK_TOOLS_VERSION}" && \
    wget --quiet --output-document=sdk-tools.zip \
        "https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS_VERSION}.zip" && \
    mkdir --parents "$ANDROID_SDK_ROOT" && \
    unzip -q sdk-tools.zip -d "$ANDROID_SDK_ROOT" && \
    rm --force sdk-tools.zip > /dev/null
# Set PATH
ENV PATH="$PATH:$ANDROID_SDK_ROOT/tools/bin:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools"
# Install Android SDK TOOLS
RUN mkdir ~/.android && echo '### User Sources for Android SDK Manager' > ~/.android/repositories.cfg && \
    echo "Accept sdk licenses " && \
    yes | sdkmanager --licenses && yes | sdkmanager --update \
    > /dev/null \
    && \
    echo "Install Base-Tools " && \
    sdkmanager \
    "tools" \
    "platform-tools" \
    > /dev/null \
    && \
    echo "Install Build-Tools " && \
    sdkmanager \
    "build-tools;28.0.3" \
    "build-tools;29.0.3" \
    "build-tools;30.0.0" \
    > /dev/null \
    && \
    echo "Install Platforms " && \
    sdkmanager \
    "platforms;android-28" \
    "platforms;android-29" \
    "platforms;android-30" \
    > /dev/null


#
# Install GRALDE
#

ENV GRALDE_VERSION="gradle-6.4"
ENV GRADLE_DIR="gradle"
#Download Gradle SDK
RUN echo "Installing GRADLE SDK" && \
    wget --quiet --output-document=gradle.zip \
        "https://services.gradle.org/distributions/${GRALDE_VERSION}-bin.zip" && \
    unzip gradle.zip && \
    mv "${GRALDE_VERSION}" "${GRADLE_DIR}" && \
    mv "${GRADLE_DIR}" /opt && \
    rm --force gradle.zip > /dev/null
ENV GRADLE_HOME=/opt/gradle
ENV PATH="$PATH:$GRADLE_HOME/bin"

#
# Install Flutter SDK
#

# Install Flutter Dependent Packages
# Look on https://flutter.dev/docs/get-started/install/linux
# curl,git,mkdir(coreutils),rm(coreutils),unzip,which(debianutils),xz(xz-utils),zip,libGlu.so.1(libglu1-mesa)
RUN apt-get install -qq --no-install-recommends \
    bash \
    curl \
    git \
    coreutils \
    unzip \
    debianutils \
    xz-utils \
    zip \
    libglu1-mesa && \
    apt-get autoclean
ENV FLUTTER_HOME="/opt/flutter"
# Download Flutter sdk
RUN echo "Install Flutter sdk" && \
    cd /opt && \
    wget --quiet https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_1.17.4-stable.tar.xz -O flutter.tar.xz && \
    tar xf flutter.tar.xz && \
    rm -f flutter.tar.xz
#Set PATH
ENV PATH="$PATH:$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin"
#Flutter config
RUN flutter config --no-analytics \
    > /dev/null

#
# Install FOR xiaoman Deploy
# curl,md5、ls、cp、rm(coreutils),openssl,find(findutils),sed,mysql(default-mysql-client-core)
RUN apt-get install -qq --no-install-recommends \
    curl \
    coreutils \
    openssl \
    findutils \
    sed \
    default-mysql-client-core && \
    apt-get autoclean \
    > /dev/null
