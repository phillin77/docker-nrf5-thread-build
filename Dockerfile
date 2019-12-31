FROM ubuntu:16.04

# Download tools and prerequisites
RUN apt-key update && \
apt-get update && \
apt-get install -y curl git unzip bzip2 build-essential gcc-multilib srecord pkg-config python3-pip python3-dev libusb-1.0.0 && \
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

# Add micro-ecc to SDK
RUN curl -SL https://github.com/kmackay/micro-ecc/archive/v1.0.zip > /tmp/micro-ecc_v1.0.zip && \
unzip -q /tmp/micro-ecc_v1.0.zip -d /nrf5/nRF5_SDK_for_Thread_and_Zigbee_v3.2.0/external/micro-ecc && \
mv /nrf5/nRF5_SDK_for_Thread_and_Zigbee_v3.2.0/external/micro-ecc/micro-ecc-1.0 /nrf5/nRF5_SDK_for_Thread_and_Zigbee_v3.2.0/external/micro-ecc/micro-ecc && \
make -C /nrf5/nRF5_SDK_for_Thread_and_Zigbee_v3.2.0/external/micro-ecc/nrf52hf_armgcc/armgcc && \
rm /tmp/micro-ecc_v1.0.zip

# Install nRF Tools (makes it easy to build a DFU package)
RUN pip install nrfutil
