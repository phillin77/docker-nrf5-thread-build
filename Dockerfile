FROM ubuntu:16.04

# Download tools and prerequisites
RUN apt-get update && \
apt-get install -y curl git unzip bzip2 software-properties-common \
            build-essential gcc-multilib srecord \
            pkg-config python3-pip python3-dev \
            libusb-1.0.0 && \
apt-get clean all && \
ln -s /usr/bin/python3 /usr/local/bin/python && \
pip3 install --upgrade pip

# Download and install ARM toolchain matching the SDK
RUN curl -SL https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2018q2/gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2?revision=bc2c96c0-14b5-4bb4-9f18-bceb4050fee7?product=GNU%20Arm%20Embedded%20Toolchain,64-bit,,Linux,7-2018-q2-update > /tmp/gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2 && \
tar xvjf /tmp/gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2 -C /usr/local/ && \
rm /tmp/gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2

# Download nRF5_SDK_for_Thread_and_Zigbee v3.2.0 and extract nRF5 SDK to /nrf5/nRF5_SDK_for_Thread_and_Zigbee_v3.2.0
RUN curl -SL https://www.nordicsemi.com/-/media/Software-and-other-downloads/SDKs/nRF5-SDK-for-Thread/nRF5-SDK-for-Thread-and-Zigbee/nRF5SDKforThreadandZigbeev3209fade31.zip > /tmp/nRF5_SDK_for_Thread_and_Zigbee_v3.2.0.zip && \
mkdir -p /nrf5 && \
unzip -q /tmp/nRF5_SDK_for_Thread_and_Zigbee_v3.2.0.zip -d /nrf5/nRF5_SDK_for_Thread_and_Zigbee_v3.2.0 && \
rm /tmp/nRF5_SDK_for_Thread_and_Zigbee_v3.2.0.zip

# Download NRF5 SDK v16.0.0 and extract nRF5 SDK to /nrf5/nRF5_SDK_16.0.0
RUN curl -SL https://developer.nordicsemi.com/nRF5_SDK/nRF5_SDK_v16.x.x/nRF5_SDK_16.0.0_98a08e2.zip > /tmp/SDK_16.0.0.zip && \
mkdir -p /nrf5 && \
unzip -q /tmp/SDK_16.0.0.zip -d /nrf5/nRF5_SDK_16.0.0 && \
rm /tmp/SDK_16.0.0.zip

# Add micro-ecc to SDK
RUN curl -SL https://github.com/kmackay/micro-ecc/archive/v1.0.zip > /tmp/micro-ecc_v1.0.zip && \
unzip -q /tmp/micro-ecc_v1.0.zip -d /nrf5/nRF5_SDK_for_Thread_and_Zigbee_v3.2.0/external/micro-ecc && \
mv /nrf5/nRF5_SDK_for_Thread_and_Zigbee_v3.2.0/external/micro-ecc/micro-ecc-1.0 /nrf5/nRF5_SDK_for_Thread_and_Zigbee_v3.2.0/external/micro-ecc/micro-ecc && \
make -C /nrf5/nRF5_SDK_for_Thread_and_Zigbee_v3.2.0/external/micro-ecc/nrf52hf_armgcc/armgcc && \
rm /tmp/micro-ecc_v1.0.zip

# Install nRF Tools (makes it easy to build a DFU package)
RUN pip install nrfutil

# Clone source of openthread, ot-br-posix, wpantund and openweave
# Note: should use external volume to keep the repo update-to-date (only keep the commands for memo)
#
# RUN mkdir -p /nrf5/openthread && \
# git clone https://github.com/openthread/openthread.git /nrf5/openthread/openthread && \
# cd /nrf5/openthread/openthread/script && \
# sed -e 's/sudo //g' ./bootstrap > ./bootstrap.tmp && rm -f ./bootstrap && mv ./bootstrap.tmp ./bootstrap && \
# chmod u+x ./bootstrap && \ 
# cd .. && \ 
# ./script/bootstrap && \
# ./bootstrap && \
# git clone https://github.com/openthread/ot-br-posix.git /nrf5/openthread/ot-br-posix && \
# git clone https://github.com/openthread/wpantund.git /nrf5/openthread/wpantund && \
# mkdir -p /nrf5/openweave && \
# git clone https://github.com/openweave/openweave-core.git /nrf5/openweave/openweave-core && \
# git clone https://github.com/openweave/openweave-nrf52840-lock-example.git /nrf5/openweave/openweave-nrf52840-lock-example

WORKDIR /nrf5