nmcli device show ens33 | grep DNS


yum install bind -y

systemctl enable named ; systemctl start named ; systemctl status named


firewall-cmd --permanent --add-service=dns

firewall-cmd --reload

firewall-cmd --list-services


#vim /etc/named.conf

cat <<EOF>> /etc/named.conf
zone "abc.com" IN {
		type master;
		file "/var/named/abc.com.fz";
		allow-transfer { 192.168.8.20; };
};

zone "8.168.192.in-addr.arpa" IN {
		type master;
		file "/var/named/abc.com.rz";
		allow-transfer { 192.168.8.20; };
};
EOF


touch /var/named/abc.com.fz

touch /var/named/abc.com.rz




cat <<EOF>> /var/named/abc.com.fz
$TTL 1D
$ORIGIN abc.com.
@ IN SOA server1.abc.com. admin.abc.com. (
2024091301      ; serial
12H ; refresh
30M ; retry
3D ; expire
3H ) ; minimum

NS 							server1.abc.com.
NS 							server2.abc.com.
				MX  10 		server1.abc.com.
				MX  20 		server2.abc.com.
 server1	 	A 			192.168.8.10
 server1         AAAA   2000:10::1
 server2 A 192.168.8.20
 server3 A 192.168.8.30
 windows10 A 192.168.8.1
 gateway A 192.168.8.2
  redhat1 CNAME server1.abc.com.
 redhat2 CNAME server2.abc.com.
 redhat3 CNAME server3.abc.com.
 linux1 CNAME server1.abc.com.
 linux2 CNAME server2.abc.com.
 linux3 CNAME server3.abc.com.
EOF




cat <<EOF>> /var/named/abc.com.rz

$TTL 1D
$ORIGIN 8.168.192.in-addr.arpa.
@ IN SOA server1.abc.com. admin.abc.com. (
2021091301      ; serial
12H ; refresh
30M ; retry
3D ; expire
NS server1.abc.com.
NS server2.abc.com.
MX 10 server1.abc.com.
MX 20 server2.abc.com.
10 PTR server1.abc.com.
20 PTR server2.abc.com.
30 PTR server3.abc.com.
1 PTR windows10.abc.com.
2 PTR gateway.abc.com.

EOF


systemctl restart named


# now you should disble hosts entry of server names
# 192.168.8.10 server1.abc.com server1 srv1
# 192.168.8.20 server2.abc.com server2 srv2

nslookup server1.abc.com


nslookup server2.abc.com

nslookup server3.abc.com

nslookup windows10.abc.com


nslookup gateway.abc.com



nslookup redhat1.abc.com

nslookup linux1.abc.com

dig server1.abc.com















