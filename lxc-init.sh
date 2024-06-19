#!/bin/bash


# This file sets the LXC up enough to pull git and move on to the actual
# configuration.

# Manually install Ubuntu 22.04 LTS container.

# Paste this code in a root shell

# install 'git' utility
apt-get -y install git
apt-get -y install vim

## prep PKI so that the server can be trusted

# lay certificate in a file
echo '
-----BEGIN CERTIFICATE-----
MIIC2jCCAmCgAwIBAgIIJBetswST1ZcwCgYIKoZIzj0EAwMwZzEWMBQGA1UEAxMN
Qm9pbiBFQ0MgMjAyMzELMAkGA1UEBhMCVVMxETAPBgNVBAgTCE1hcnlsYW5kMRcw
FQYDVQQHEw5IYXZyZSBkZSBHcmFjZTEUMBIGA1UEChMLQm9pbiBGYW1pbHkwHhcN
MjMwNDA0MTgzMjE4WhcNMzMwNDAxMTgzMjE4WjBnMRYwFAYDVQQDEw1Cb2luIEVD
QyAyMDIzMQswCQYDVQQGEwJVUzERMA8GA1UECBMITWFyeWxhbmQxFzAVBgNVBAcT
DkhhdnJlIGRlIEdyYWNlMRQwEgYDVQQKEwtCb2luIEZhbWlseTB2MBAGByqGSM49
AgEGBSuBBAAiA2IABBOGgAzxg+I7U0d79MSgq6yllfeUPFcJ6ir7X3PuBlMV68GB
nVGU6P8fs8Sh9droTlp6NMg63ssWummnOC10imEBJf51LB50ge6PCKAo7Yr1eVd9
JOx1yoXsvwnGZn0hdaOB2DCB1TAdBgNVHQ4EFgQUM5q8++uqmqBpRPXxdElLSnDk
mHAwgZgGA1UdIwSBkDCBjYAUM5q8++uqmqBpRPXxdElLSnDkmHCha6RpMGcxFjAU
BgNVBAMTDUJvaW4gRUNDIDIwMjMxCzAJBgNVBAYTAlVTMREwDwYDVQQIEwhNYXJ5
bGFuZDEXMBUGA1UEBxMOSGF2cmUgZGUgR3JhY2UxFDASBgNVBAoTC0JvaW4gRmFt
aWx5gggkF62zBJPVlzAMBgNVHRMEBTADAQH/MAsGA1UdDwQEAwIBBjAKBggqhkjO
PQQDAwNoADBlAjEA4upOFddeVUNk0RxOR9vUpgM2yQ4q8Pc5FKikOJ/3a+kSHFmQ
4Sjwg+SR6sHrjGMwAjAPOKHVM1SeFxwgjSHoTCgqemrt3dPKV5cGEyRcz6rXfbt6
2hFX1FFmGTHQDA2JUCI=
-----END CERTIFICATE-----
' > /usr/share/ca-certificates/Boin+ECC+2023.crt

# add that certificate to the local PKI config
echo 'Boin+ECC+2023.crt' >> /etc/ca-certificates.conf

# re-gen the CA certificate cache
update-ca-certificates


## pull the repo into the LXC

cd /root
# point Git to the Windows certificate store
# git config --global http.sslBackend schannel
openssl s_client -showcerts -connect gitea.home.boin.org:3000 </dev/null 2>/dev/null|openssl x509 -outform PEM > gitea_home_boin_org.crt
cp gitea_home_boin_org.crt /usr/local/share/ca-certificates/gitea_home_boin_org.crt
update-ca-certificates
git clone https://gitea.home.boin.org:3000/pboin/boin-ai-lab.git


