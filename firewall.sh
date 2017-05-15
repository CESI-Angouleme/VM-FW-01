# Vide les règles déjà existantes
iptables -F
iptables -X
iptables -F -t nat
iptables -X -t nat

# On interdit toutes les connexions entrantes et sortantes
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# Ne pas casser les connexions déjà existantes
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Autoriser le partage de connexion
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o eth0 -j MASQUERADE

# Autoriser la loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Autoriser le SSH
iptables -A INPUT -i eth0 -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -o eth1 -p tcp --dport 22 -j ACCEPT

# Autoriser le NTP
iptables -A OUTPUT -o eth0 -p tcp --dport 123 -j ACCEPT

# Autoriser l'ICMP
iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT

# Autoriser les DNS
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

# Autoriser le DHCP (client)
iptables -A OUTPUT -p udp --dport 67 -j ACCEPT

# Autoriser les serveurs de mise à jour
iptables -A OUTPUT -o eth0 -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --dport 21 -j ACCEPT

# Autoriser le reseau local
iptables -A FORWARD -i eth1 -o eth0 -s 192.168.1.0/24 -j ACCEPT
iptables -A FORWARD -o eth1 -i eth0 -d 192.168.1.0/24 -j ACCEPT
