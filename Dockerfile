FROM ubuntu:focal

ENV HOME_DIR=/home/ci
ENV ANDROID_SDK_ROOT=$HOME_DIR/sdk
ENV ANDROID_AVD_HOME "$HOME_DIR/.android"
ENV ACTIONS_RUNNER_DIR=$HOME_DIR/actions-runner

ENV PATH "$PATH:$ANDROID_SDK_ROOT/emulator"
ENV PATH "$PATH:$ANDROID_SDK_ROOT/cmdline-tools/tools/bin"
ENV PATH "$PATH:$ANDROID_SDK_ROOT/platform-tools"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
	apt-get install -y \
	curl \
	wget \
	unzip \
	nano \
	openjdk-11-jdk \
	sudo \
	less \
	libglu1 \
	libpulse-dev \
	libasound2 \
	libc6  \
	libstdc++6 \
	libx11-6 \
	libx11-xcb1 \
	libxcb1 \
	libxcomposite1 \
	libxcursor1 \
	libxi6  \
	libxtst6 \
	libnss3 \
	qemu-kvm \
	libvirt-daemon \
	libguestfs-tools \
	bridge-utils \
	jq \
	kmod

RUN adduser --disabled-password --gecos "" ci 
RUN echo "ci ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers 
USER ci

#
# Prepare android sdk
#
RUN mkdir $ANDROID_SDK_ROOT
WORKDIR $ANDROID_SDK_ROOT

RUN wget -q -O temp.zip https://dl.google.com/android/repository/platform-tools_r30.0.1-linux.zip && \
	unzip -q temp.zip && rm -f temp.zip
RUN wget -q -O temp.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
	unzip -q temp.zip && rm -f temp.zip
RUN mkdir $ANDROID_SDK_ROOT/cmdline-tools && cd ${ANDROID_SDK_ROOT}/cmdline-tools && \
	wget -q -O temp.zip https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip && \
	unzip -q temp.zip && rm -f temp.zip

RUN echo y | sdkmanager "build-tools;30.0.3"
RUN echo y | sdkmanager "build-tools;29.0.2"
RUN echo y | sdkmanager "platforms;android-30"
RUN echo y | sdkmanager "system-images;android-29;google_apis;x86"
RUN echo y | sdkmanager "tools" "emulator" "platform-tools"

#
# Prepare emulator image
#
RUN avdmanager -s create avd -n emu0 -k 'system-images;android-29;google_apis;x86' --force --device 'Nexus 4' -c 100M

WORKDIR $HOME_DIR
ADD start.sh $HOME_DIR
RUN sudo chown ci.ci start.sh && chmod +x start.sh

#
# Setup github self-hosted runner
#
RUN mkdir ${ACTIONS_RUNNER_DIR}
WORKDIR ${ACTIONS_RUNNER_DIR}
RUN curl -o actions-runner-linux-x64-2.278.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.278.0/actions-runner-linux-x64-2.278.0.tar.gz && \
	tar xzf ./actions-runner-linux-x64-2.278.0.tar.gz && \
	echo -y | sudo ./bin/installdependencies.sh

WORKDIR $HOME_DIR





