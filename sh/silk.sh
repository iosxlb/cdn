#!/bin/bash
git clone https://github.com/iosxlb/silk-v3-decoder.git
cd silk-v3-decoder
chmod 777 silk-v3-decoder
sh converter.sh
cd silk
make encoder
make decoder
sudo cp encoder /usr/local/bin/
sudo chmod 777 /usr/local/bin/encoder
