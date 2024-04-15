#!/bin/sh

# Lista de IPs e portas
ip_ports="
5.16.8.159 1538
5.16.8.159 1538
10.29.174.74 1538
10.29.174.74 1538
5.17.8.14 1521
10.28.28.21 5045
10.18.82.74 1521
10.18.16.193 1521
10.18.82.74 1521
10.18.16.193 1521
10.21.4.110 1521
10.21.4.113 1521 
10.21.4.108 1521
10.18.80.199 1521
10.18.81.232 1522
10.18.16.191 20050
10.18.16.191 20060
10.18.16.191 20120
10.54.16.101 22
172.30.40.68 22
10.21.4.110 8000
10.21.4.113 8080
10.21.4.108 8080
10.18.83.15 8923
10.18.83.15 8920
10.18.83.15 8922
10.18.81.209 8940
10.18.82.74 1521
10.18.16.193 1521
10.18.82.74 1521
10.18.16.193 1521
10.21.4.110 1521
10.21.4.113 1521
10.21.4.108 1521
10.18.80.199 1521
10.18.81.232 1522
10.18.16.191 20050
10.18.16.191 20060
10.18.16.191 20120
10.54.16.101 22
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
    if echo "exit" | timeout 5 telnet "$ip" "$port" >/dev/null 2>&1; then
        echo "Conexão aberta para $ip:$port"
    else
        echo "Falha na conexão para $ip:$port"
    fi
done <<< "$ip_ports"
