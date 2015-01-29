#Flush iptables
iptables -F
#Remove user defined chains
iptables -X
#Change Default Policies
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
