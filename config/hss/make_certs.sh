#!/bin/sh

if [ 1 -ne $# ]
then
    echo You must specify output directory : ./make_certs.sh ./freeDiameter

    exit;
fi

rm -rf demoCA
mkdir demoCA
echo 01 > demoCA/serial
touch demoCA/index.txt.attr
touch demoCA/index.txt

# Generate .rnd if it does not exist
openssl rand -out /root/.rnd -hex 256

# CA self certificate
openssl req  -new -batch -x509 -days 3650 -nodes -newkey rsa:1024 -out $1/cacert.pem -keyout cakey.pem -subj /CN=ca.epc.mnc001.mcc01.3gppnetwork.org/C=KO/ST=Seoul/L=Nowon/O=Open5GS/OU=Tests

#hss
openssl genrsa -out $1/hss.key.pem 1024
openssl req -new -batch -out hss.csr.pem -key $1/hss.key.pem -subj /CN=hss.epc.mnc001.mcc01.3gppnetwork.org/C=KO/ST=Seoul/L=Nowon/O=Open5GS/OU=Tests
openssl ca -cert $1/cacert.pem -days 3650 -keyfile cakey.pem -in hss.csr.pem -out $1/hss.cert.pem -outdir . -batch

rm -f 01.pem 02.pem 03.pem 04.pem
rm -f cakey.pem
rm -f hss.csr.pem
