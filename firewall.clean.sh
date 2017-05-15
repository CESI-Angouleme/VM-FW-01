# Vide les règles déjà existantes
iptables -F
iptables -X
iptables -F -t nat
iptables -X -t nat

# On accepte toutes les connexions entrantes et sortantes
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Ne pas casser les connexions déjà existantes
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
