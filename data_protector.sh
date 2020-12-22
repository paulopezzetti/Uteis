#!/bin/bash

Principal() {

  echo "Bem vindo a instalacao do Data Protector-client Unicesumar"

  echo "------------------------------------------"

  echo "Opções:"

  echo

  echo "1. Instalar Data Protector"

  echo "2. Remover Data Protector"

  echo "3. Sair"

  echo

  echo -n "Qual a opção desejada? "

  read opcao

  case $opcao in

    1) install ;;

    2) remove ;;

    3) exit ;;

    *) "Opção desconhecida." ; echo ; Principal ;;

  esac

}

 

install() {
echo "adicionando entradas ao arquivo /etc/services"

sed -i "s/freeciv/omni  /g" /etc/services
sed -i "s/# Freeciv gameplay/# Data Protector/g" /etc/services

echo "instalando pacote xinetd"

yum install xinetd -y
systemctl enable xinetd



echo "baixando pacotes do data protector"

wget -P /home http://172.16.0.109/DP/OB2-CORE-A.10.70-1.x86_64.rpm
wget -P /home http://172.16.0.109/DP/OB2-DA-A.10.70-1.x86_64.rpm

echo "instalando pacotes do data protector"

rpm -ivh /home/OB2-CORE-A.10.70-1.x86_64.rpm
rpm -ivh /home/OB2-DA-A.10.70-1.x86_64.rpm

echo "criando variaveis de ambiente"

cat >> /etc/opt/omni/client/cell_server <<EOF
w2k16r1-bkp01.adm-cesumar.local
EOF

cat >> /etc/opt/omni/client/customize/socket <<EOF
w2k16r1-bkp01.adm-cesumar.local
EOF

echo "variaveis de ambientes criadas"

echo "startando serviço xinetd"
service xinetd start

echo "removendo arquivos de instalação"
rm -rf /home/OB2-CORE-A.10.70-1.x86_64.rpm
rm -rf /home/OB2-DA-A.10.70-1.x86_64.rpm

echo "arquivos removidos e instalação finalizada"

}

 

remove() {
rpm -e OB2-DA
rpm -e OB2-CORE

rm -rf /etc/opt/omni/

echo "DATA PROTECTOR CLIENT REMOVIDO COM SUCESSO"

}
 
Principal

