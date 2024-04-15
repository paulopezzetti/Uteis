#!/bin/bash

# Lista de IPs e portas
ip_ports="
1.1.1.1 22
2.2.2.2 22
"

# Loop através de cada linha da lista de IPs e portas
while IFS= read -r ip_port; do
    # Ignorar linhas em branco
    if [ -z "$ip_port" ]; then
        continue
    fi

    # Extrair IP e porta
    ip=$(echo "$ip_port" | awk '{print $1}')
    port=$(echo "$ip_port" | awk '{print $2}')

    # Verificar se o IP e a porta estão vazios
    if [ -z "$ip" ] || [ -z "$port" ]; then
        echo "Entrada inválida: $ip_port. Ignorando..."
        continue
    fi

    # Tentar conectar com telnet com timeout de 5 segundos
    echo "Tentando conectar em $ip:$port..."
    if timeout 5 bash -c "</dev/tcp/$ip/$port" >/dev/null 2>&1; then
        echo "Conexão aberta para $ip:$port"
    else
        echo "Falha na conexão para $ip:$port"
        # Capturar mensagem de erro, se houver
        err_message=$(timeout 5 bash -c "</dev/tcp/$ip/$port" 2>&1 >/dev/null)
        echo "Mensagem de erro: $err_message"
    fi
done <<< "$ip_ports"
