mkdir /root/agent
cd /root/agent
wget http://git.unicesumar.edu.br/Scripts/Linux/raw/master/iDRAgent/agent_installer.sh
wget http://git.unicesumar.edu.br/Scripts/Linux/raw/master/iDRAgent/cafile.pem
wget http://git.unicesumar.edu.br/Scripts/Linux/raw/master/iDRAgent/client.crt
wget http://git.unicesumar.edu.br/Scripts/Linux/raw/master/iDRAgent/client.key
wget http://git.unicesumar.edu.br/Scripts/Linux/raw/master/iDRAgent/config.json
chmod u+x /root/agent/agent_installer.sh && /root/agent/agent_installer.sh install_start
rm -rf /root/agent