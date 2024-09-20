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
wget https://github.com/kn007/silk-v3-decoder/archive/master.zip
yum install unzip -y
unzip master.zip 
cd silk-v3-decoder-master
chmod +x converter.sh
./converter.sh