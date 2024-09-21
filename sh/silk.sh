cd opt/
git clone https://github.com/iosxlb/silk-v3-encoder.git
cd silk-v3-decoder
chmod 777 silk-v3-decoder
cd silk-v3-decode/silk
make encoder
make decoder
cp encoder /usr/local/bin/
chmod 777 /usr/local/bin/encoder