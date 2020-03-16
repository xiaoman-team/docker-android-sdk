FROM alpine

MAINTAINER xiaoman

#
# Installing Base Packages
#
RUN apk --no-cache add coreutils unzip git wget zip tar

#
# Install openjdk
#
RUN apk --no-cache add openjdk8

#
# Install Android SDK
#

# Variables must be references after they are created
# Get the latest version from https://developer.android.com/studio/index.html
ENV ANDROID_SDK_ROOT="/opt/android-sdk"
ENV ANDROID_SDK_TOOLS_VERSION="4333796"

# Download Android SDK
RUN echo "Installing sdk tools ${ANDROID_SDK_TOOLS_VERSION}" && \
    wget --quiet --output-document=sdk-tools.zip \
        "https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS_VERSION}.zip" && \
    mkdir --parents "$ANDROID_SDK_ROOT" && \
    unzip -q sdk-tools.zip -d "$ANDROID_SDK_ROOT" && \
    rm --force sdk-tools.zip \
    > /dev/null

# Set PATH
ENV PATH="$PATH:$ANDROID_SDK_ROOT/tools/bin:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools"

# Install Android SDKs
RUN mkdir ~/.android && echo '### User Sources for Android SDK Manager' > ~/.android/repositories.cfg && \
    echo "Accept sdk licenses " && \
    yes | sdkmanager --licenses && yes | sdkmanager --update &&\
    echo "Install Base-Tools " && \
    sdkmanager \
    "tools" \
    "platform-tools" \
    > /dev/null && \
    echo "Install Build-Tools " && \
    sdkmanager \
    "build-tools;28.0.3" \
    "build-tools;29.0.2" \
    > /dev/null && \
    echo "Install Platforms " && \
    sdkmanager \
    "platforms;android-28" \
    > /dev/null

#
# Install Flutter SDK
#

# Variables must be references after they are created

# Install Flutter Dependent Packages
# Look on https://flutter.dev/docs/get-started/install/linux
# curl,git,mkdir(coreutils),rm(coreutils),unzip,which,xz,zip,libGlu.so.1(glu)
RUN apk --no-cache add curl git coreutils unzip which xz zip glu >> /dev/null

ENV FLUTTER_HOME="/opt/flutter"

# Download Flutter sdk
RUN echo "Install Flutter sdk" && \
    cd /opt && \
    wget --quiet https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.12.13+hotfix.8-stable.tar.xz -O flutter.tar.xz && \
    tar xf flutter.tar.xz && \
    rm -f flutter.tar.xz \
    > /dev/null

#Set PATH
ENV PATH="$PATH:$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin"

#Flutter config
RUN flutter config --no-analytics \

#
# Install FOR xiaoman Deploy
# curl,md5(outils-md5),openssl,find(findutils),sed,mysql(mariadb-client)
RUN apk --no-cache add curl outils-md5 openssl findutils sed mariadb-client
