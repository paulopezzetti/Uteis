#!/bin/bash

mkdir /opt/cylance

cat >> /opt/cylance/config_defaults.txt <<EOF

InstallToken=muoGD9vMGb9qlu0uewT1TIZia
SelfProtectionLevel=2
LogLevel=2
#VenueZone=Unicesumar
#UiMode=1

EOF

cd /tmp
wget http://172.16.0.109/install/ngav/CylancePROTECT.el7.rpm
#wget http://172.16.0.109/install/ngav/CylanceOPTICS-2.5.2000.7479-release.x86_64.rpm

yum install -y glibc.i686 dbus-libs.i686 openssl-libs.i686 libgcc.i686 sqlite.i686 openssl openssl-libs libgcc sqlite dbus-libs gtk3 kernel-devel bzip2
rpm -ivh /tmp/CylancePROTECT.el7.rpm
#rpm -ivh /tmp/CylanceOPTICS-2.5.2000.7479-release.x86_64.rpm

systemctl start cylancesvc
#systemctl start cyoptics.service

rm -rf /tmp/CylancePROTECT.el7.rpm
#rm -rf /tmp/CylanceOPTICS-2.5.2000.7479-release.x86_64.rpm

systemctl status cylancesvc
#systemctl status cyoptics.service

echo Verificando Status do Servico...
sleep 5
/opt/cylance/desktop/cylance -s
lsmod | grep CyProtectDrv