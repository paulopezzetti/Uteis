#!/bin/bash
clear

#Variaveis de ambiente
arquivosdl="http://git.unicesumar.edu.br/Scripts/Zabbix/repository/archive.tar.gz"
arquivotar="archive.tar.gz"
zabbixconf="zabbix_agentd.conf"
zabbixexec="/usr/sbin/zabbix_agentd"
zabbixdir="/etc/zabbix"
zabbixdirextra="/etc/zabbix/zabbix_agentd.d"
validaversaoSO=$(uname -r | cut -f 6 -d ".")

#System#

main () {

if [ "$(id -u)" != "0" ]; then
	echo -e "\e[1;31mO script deve ser executado como root.\e[0m"
	exit 0;

else

	echo -e "\e[1;31m----------------------------------------------------\e[0m"
	echo -e "\e[1;31mBem vindo ao instalacao do Zabbix-client Unicesumar\e[0m"
	echo "O que deseja fazer?"
	echo "1 - Instalar Zabbix"
	echo "2 - Reconfigurar Zabbix"
	echo "3 - Remover Zabbix"
	echo "4 - Monitoramento de servicos"
	echo "0 - Sair"
	echo -ne "\e[1;31mDigite sua opcao: \e[0m"

	read resultado

	case $resultado in 

	1) zabbix_install;;
	2) zabbix_update;;
	3) zabbix_remove;;
	4) zabbix_servicos;;
	0) exit 0;;
	*) echo -e "\e[1;31mOpcao invalida\e[0m" ; main  ;;

	esac
fi
}

zabbix_install () {

	echo 
	echo -ne  "\e[1;31mVerificando versao do SO... "

	case $MACHTYPE in

	x86_64-redhat-linux-gnu)

		if [ "$validaversaoSO" = "el7" ]; then

			echo "encontrado SO Linux CentOS/RedHat versao 7 64 bits."
			echo -e "Iniciando instalacao\e[0m"
			sleep 2;
			echo

			ps -s | grep zabbix_agentd | grep -v grep 2>&1 
			result=$?

			if [ "$result" -eq "0" ]  || [ -e "$zabbixexec" ]; then
				echo -ne "\e[1;31mZabbix ja existente, deseja atualizar? [Y/N] \e[0m"
				read resultinstall
				case $resultinstall in
				[yY]) zabbix_update;;
				[nN]) echo -en "\e[1;31mFinalizando script\e[0m"; exit 0;;
				*) echo -en "\e[1;31mOpcao invalida, utilize Y para Sim ou N para Nao\e[0m" ; sleep 2 ; zabbix_install ;;
				esac
			fi
			
			rpm -Uvh http://repo.zabbix.com/zabbix/2.4/rhel/7/x86_64/zabbix-release-2.4-1.el7.noarch.rpm 2>&1 
			
			if [ $? -eq 0 ]; then

				yum install -y zabbix zabbix-agent 
				systemctl enable zabbix-agent 
				sleep 2;
				echo -e "\e[0m"
				echo
				zabbix_update
			else 
					echo
					echo -e "\e[1;31mFalha ao instalar zabbix\e[0m"
					exit 0;
			fi
		
		
		elif [ "$validaversaoSO" = "el6" ] || [ "$validaversaoSO" = "" ]; then
		
			echo "encontrado SO Linux CentOS/RedHat versao 6 64 bits."
			echo -e "Iniciando instalacao\e[0m"
			sleep 2;
			echo

			ps -s | grep zabbix_agentd | grep -v grep 2>&1
			result=$?

                        if [ "$result" -eq "0" ]  || [ -e "$zabbixexec" ]; then
                                echo -ne "\e[1;31mZabbix ja existente, deseja atualizar? [Y/N] \e[0m"
                                read resultinstall
                                case $resultinstall in
                                [yY]) zabbix_update;;
                                [nN]) echo -en "\e[1;31mFinalizando script\e[0m"; exit 0;;
                                *) echo -en "\e[1;31mOpcao invalida, utilize Y para Sim ou N para Nao\e[0m" ; sleep 2 ; zabbix_install ;;
                                esac
                        fi

			rpm -Uvh http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm 2>&1 

			if [ $? -eq 0 ]; then

				yum install -y zabbix zabbix-agent 
				chkconfig zabbix-agent on 
				sleep 2;
				echo -e "\e[0m"
				echo
				zabbix_update
			else 
					echo
					echo -e "\e[1;31mFalha ao instalar zabbix\e[0m"
					exit 0;
			fi

		fi
		exit 0;;
	*)
		echo -e "\e[1;31mversao de SO nao suportada, finalizando script\e[0m"
		exit 0;;
esac
}

zabbix_update () {
	
	echo
	echo -e "\e[1;31mConfigurando zabbix.\e[0m"
	sleep 2
	if [ -d $zabbixdir ]; then

		wget -c "$arquivosdl" 
		tar zxf $arquivotar -C /tmp
		cp -v /tmp/Zabbix-master*/$zabbixconf  $zabbixdir 2>&1
		rm -fr /tmp/Zabbix-master* 
		rm -fr $arquivotar

		service zabbix-agent restart

		echo
		echo -e "\e[1;31mZabbix configurado com sucesso.\e[0m"
		echo -e "\e[1;31mUtilize o nome \e[1;36m" `$zabbixexec -t system.hostname | cut -f 2 -d "|" | cut -d "]" -f 1` "\e[1;31m para configurar o host\e[0m"
		sleep 3;
		echo
		main
	else
		echo -e "\e[1;31mNao encontrado diretorio de instalacao.\e[0m"
		exit 0;
	fi
}

zabbix_remove () {

	echo
	echo -e "\e[1;31mRemovendo zabbix\e[0m"
	echo 
	rpm -qa | grep "zabbix" 2>&1 

	if [ $? -eq 0 ];then

		yum remove zabbix* -y 
		
		if [ -d $zabbixdir ];then
			
			rm -fr $zabbixdir
			echo
			echo -e "\e[1;31mRemocao concluida.\e[0m"
			sleep 2;
			main
		else
			
			echo -e "\e[1;31mDiretorio de instalacao nao localizado para removao\e[0m"
			exit 0;
		fi
	else 
		echo -e "\e[1;31mInstalacao nao localizada via RPM, finalizando script\e[0m"
		exit 0;
	fi
}

zabbix_servicos () {
	
	echo
	echo -e "\e[1;31mSelecione qual servico deseja configurar para o zabbix cliente\e[0m"
	echo "1 - Apache"
	echo "2 - DNS"
	echo "0 - Voltar ao menu principal"
	echo -ne "\e[1;31mDigite a opcao desejada: \e[0m"
	
	read resultservicos
	
	case $resultservicos in
	
	1) zabbix_apacheConfig ;;
	2) zabbix_dnsConfig ;;
	0) main ;;
	*) echo -ne "\e[1;31mOpcao invalida.\e[0m" ; zabbix_servicos ;;
	
	esac
}

zabbix_apacheConfig () {
	
	echo
	ps -s | grep zabbix_agentd | grep -v grep 2>&1 
	result=$?

	if [ "$result" -eq "0" ]  || [ -e "$zabbixexec" ] && [ -d $zabbixdir ]; then
		echo -ne "\e[1;31mCopiando os arquivos de configuracao.\e[0m"
		echo
		echo
		wget -c "$arquivosdl" 
		tar zxf $arquivotar -C /tmp
		cp -v /tmp/Zabbix-master*/zabbix_agentd.d/apache.conf $zabbixdirextra 2>&1
		cp -v /tmp/Zabbix-master*/zabbix_agentd.d/zapache.sh $zabbixdir 2>&1
		chmod +x $zabbixdir/zapache.sh
		rm -fr /tmp/Zabbix-master* 
		rm -fr $arquivotar
		rm -fr zapache-http*
		echo 
		echo -ne "\e[1;31mConfiguracao concluida.\e[0m"
		echo
	else	
		echo -ne "\e[1;31mInstalacao nao encontrada do zabbix agent, deseja instalar? [Y/N]\e[0m"
		read resultinstall
        case $resultinstall in
			[yY]) zabbix_install;;
			[nN]) echo -en "\e[1;31mFinalizando script\e[0m"; exit 0;;
			*) echo -en "\e[1;31mOpcao invalida, utilize Y para Sim ou N para Nao\e[0m" ; sleep 2 ; echo ; zabbix_apacheConfig ;;
        esac
	fi
}

zabbix_dnsConfig () {
	
	echo
	ps -s | grep zabbix_agentd | grep -v grep 2>&1 
	result=$?

	if [ "$result" -eq "0" ]  || [ -e "$zabbixexec" ] && [ -d $zabbixdir ]; then
		echo -ne "\e[1;31mCopiando os arquivos de configuracao.\e[0m"
		echo
		echo
		wget -c "$arquivosdl" 
		tar zxf $arquivotar -C /tmp
		cp -v /tmp/Zabbix-master*/zabbix_agentd.d/dns.conf $zabbixdirextra 2>&1
		rm -fr /tmp/Zabbix-master* 
		rm -fr $arquivotar
		rm -fr zapache-http*
		echo 
		echo -ne "\e[1;31mConfiguracao concluida.\e[0m"
		echo
	else	
		echo -ne "\e[1;31mInstalacao nao encontrada do zabbix agent, deseja instalar? [Y/N]\e[0m"
		read resultinstall
        case $resultinstall in
			[yY]) zabbix_install;;
			[nN]) echo -en "\e[1;31mFinalizando script\e[0m"; exit 0;;
			*) echo -en "\e[1;31mOpcao invalida, utilize Y para Sim ou N para Nao\e[0m" ; sleep 2 ; echo ; zabbix_apacheConfig ;;
        esac
	fi
}

main
