# *************************************************************************************
# GEOFF DABU - A00817395
# COMP 8006 ASSIGNMENT 1 - BASIC FIREWALL USING IPTABLES
#
# THIS SCRIPT ENABLES A FIREWALL WHICH ABIDES TO THE FOLLOWING CONSTRAINTS:
#       - Default policy to drop
#       - Permit inbound and outbound ssh packets
#       - Permit inbound and outbound www packets
#       - Drop packets destined to port 80 from ports less than 1024
#       - Drop all packets to and from port 0
#       - Keep track of all ssh and www traffic using custom chains
#       - Allow DNS and DHCP traffic through
#
# *************************************************************************************



# ******************************************************
# RESET CHAINS
# ******************************************************
iptables -F
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -X

# ******************************************************
# USER DEFINED ACCOUNTING CHAINS
# ******************************************************
iptables -N trafficALL
iptables -N trafficSSH
iptables -N trafficWWW

iptables -A trafficSSH
iptables -A INPUT -p tcp --dport ssh -j trafficSSH
iptables -A INPUT -p tcp --sport ssh -j trafficSSH
iptables -A OUTPUT -p tcp --dport ssh -j trafficSSH
iptables -A OUTPUT -p tcp --sport ssh -j trafficSSH

iptables -A trafficWWW
iptables -A INPUT -p tcp --dport www -j trafficWWW
iptables -A INPUT -p tcp --sport www -j trafficWWW
iptables -A OUTPUT -p tcp --dport www -j trafficWWW
iptables -A OUTPUT -p tcp --sport www -j trafficWWW

iptables -A trafficALL
iptables -A INPUT -j trafficALL
iptables -A OUTPUT -j trafficALL


# ******************************************************
# INPUT AND OUTPUT CHAINS 
# ******************************************************

#Drop inbound traffic to port 80 (http) from source ports less than 1024.
iptables -A INPUT -p tcp --dport 80 --sport 0:1023 -j DROP
iptables -A OUTPUT -p tcp --sport 80 --dport 0:1023 -j DROP

#Accepts inbound traffic to port 80 (http) from source ports greater than 1023.
iptables -A INPUT -p tcp --dport 80 ! --sport 0:1023 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 ! --dport 0:1023 -j ACCEPT

#Drop all incoming packets from reserved port 0 as well as outbound traffic to port 0
iptables -A INPUT -p tcp --sport 0 -j DROP
iptables -A INPUT -p udp --sport 0 -j DROP
iptables -A OUTPUT -p tcp --dport 0 -j DROP
iptables -A OUTPUT -p udp --dport 0 -j DROP

#Allow DHCP traffic
iptables -A OUTPUT -p udp --dport 67:68 -j ACCEPT
iptables -A INPUT -p udp --sport 67:68 -j ACCEPT

#Allow DNS tcp traffic
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --sport 53 -j ACCEPT

#Allow DNS udp traffic
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -j ACCEPT

#Allow ssl traffic
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --sport 443 -j ACCEPT

#Allow ssh traffic (incoming requests)
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

#Allow ssh traffic (outgoing requests)
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --sport 22 -j ACCEPT

#Allow outbound http requests
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --sport 80 -j ACCEPT

















