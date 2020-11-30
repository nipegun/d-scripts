#!/bin/bash

#!/bin/bash

# Drivers
apt-get -y update
apt-get -y install firmware-amd-graphics
apt-get -y install firmware-linux
apt-get -y install firmware-linux-free
apt-get -y install firmware-linux-nonfree
apt-get -y install libdrm-amdgpu1

# Vilkan
apt-get -y install mesa-vulkan-drivers
apt-get -y install libvulkan1
apt-get -y install vulkan-tools
apt-get -y install vulkan-utils
apt-get -y install vulkan-validationlayers

# OpenCL
apt-get -y install mesa-opencl-icd


# Drivers
#apt-get -y update
#apt-get -y remove firmware-amd-graphics
#apt-get -y remove firmware-linux
#apt-get -y remove firmware-linux-free
#apt-get -y remove firmware-linux-nonfree
#apt-get -y remove libdrm-amdgpu1

# Vilkan
#apt-get -y remove mesa-vulkan-drivers
#apt-get -y remove libvulkan1
#apt-get -y remove vulkan-tools
#apt-get -y remove vulkan-utils
#apt-get -y remove vulkan-validationlayers

# OpenCL
#apt-get -y remove mesa-opencl-icd
