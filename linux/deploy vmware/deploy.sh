#!/bin/bash

clear
echo "INFORME O EMAIL DO ADMINISTRADOR (nome.sobrenome@unicesumar.edu.br)"
read mail
echo "INFORME A SENHA DO ADMINISTRADOR"
read -s password
echo "INFORME O NOME DO NOVO SERVIDOR !!! "
read server
echo "INFORME O IP DO SERVIDOR"
read ip
echo "INFORME UMA DESCRIÇÃO PARA O NOVO SERVIDOR"
read descricao
clear
###########CRIANDO ARQUIVOS DE CONFIGURAÃ‡Ã•ES QUE SERÃƒO ALTERADOS#########################
cp group_vars/all-template group_vars/all
cp roles/deploy-VM/tasks/main-template.yml roles/deploy-VM/tasks/main.yml
#########################################################################################

sed -i 's/USUARIO/'$mail'/' group_vars/all
sed -i 's/SENHA/'$password'/' group_vars/all
sed -i 's/NOMEVM/'$server'/' group_vars/all
sed -i 's/1.1.1.1/'$ip'/' group_vars/all
sed -i 's/DESCRICAO/'$descricao'/' group_vars/all

Principal(){
  echo "Escolha a rede do servidor"

  echo "------------------------------------------"

  echo "OpÃ§Ãµes:"

  echo

  echo "1. REDE"

  echo "2. REDE_AS"

  echo "3. SERVER_DMZ"

  echo "4. SERVER_INFRA"

  echo "5. SERVER_WEB"
  
  echo "6. SERVER_WEB_BACKEND"

  echo

  echo -n "Qual a opÃ§Ã£o desejada? "

  read opcao

 
  case $opcao in

    1) frede ;;

    2) frede_as ;;

    3) fserver_dmz ;;

    4) fserver_infra ;;

    5) fserver_web ;;

    6) fserver_web_backend ;;
    

  esac

}
frede () {

gateway=172.16.0.67
nome_rede=REDE

sed -i 's/2.2.2.2/'$gateway'/' group_vars/all
sed -i 's/TROCAR_REDE/'$nome_rede'/' group_vars/all
}

frede_as () {

gateway=177.129.72.9
nome_rede=REDE_AS

sed -i 's/2.2.2.2/'$gateway'/' group_vars/all
sed -i 's/TROCAR_REDE/'$nome_rede'/' group_vars/all
}

fserver_dmz () {

gateway=172.16.2.1
nome_rede=SERVER_DMZ

sed -i 's/2.2.2.2/'$gateway'/' group_vars/all
sed -i 's/TROCAR_REDE/'$nome_rede'/' group_vars/all

}

fserver_infra () {

gateway=172.16.10.1
nome_rede=SERVER_INFRA

sed -i 's/2.2.2.2/'$gateway'/' group_vars/all
sed -i 's/TROCAR_REDE/'$nome_rede'/' group_vars/all

}

fserver_web () {

gateway=172.16.8.1
nome_rede=SERVER_WEB

sed -i 's/2.2.2.2/'$gateway'/' group_vars/all
sed -i 's/TROCAR_REDE/'$nome_rede'/' group_vars/all

}

fserver_web_backend () {

gateway=172.16.4.1
nome_rede=SERVER_WEB_BACKEND

sed -i 's/2.2.2.2/'$gateway'/' group_vars/all
sed -i 's/TROCAR_REDE/'$nome_rede'/' group_vars/all

}

Principal
echo "aguarde"
ansible-playbook main-playbook.yml
rm -vf group_vars/all
rm -vf roles/deploy-VM/tasks/main.yml

