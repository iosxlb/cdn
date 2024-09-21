#!/bin/bash
yum install gcc -y
yum install epel-release -y
rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
yum install ffmpeg -y
yum install wget -y 
yum install make -y
yum install gcc-c++ -y
cd opt/
mkdir silk-decode
cd silk-decode/
git clone https://github.com/iosxlb/silk-v3-decoder.git
cd silk-v3-decoder
chmod +x converter.sh
./converter.sh
cp encoder /usr/local/bin/
chmod 777 /usr/local/bin/encoder