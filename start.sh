#!/bin/bash

/bin/echo >/var/log/ipsec.log
/bin/rm -f /var/run/charon.pid
/bin/rm -f /var/run/starter.charon.pid

	if [ ! -f "/firsttime" ]; then
		/bin/sed -i -e "s:rightsourceip=192.168.95.0/24:rightsourceip=$VPN_SUBNET:g" /etc/ipsec.conf
		/bin/echo ": PSK \"$VPN_PSK\"" >/etc/ipsec.secrets
		/bin/echo "$VPN_USER : XAUTH \"$VPN_PASS\"" >>/etc/ipsec.secrets
		/bin/touch /firsttime	
	fi

/sbin/sysctl -w net.ipv4.ip_forward=1
/sbin/sysctl -w net.ipv4.conf.all.rp_filter=2

	for each in /proc/sys/net/ipv4/conf/*
	do
		/bin/echo 0 > $each/accept_redirects
		/bin/echo 0 > $each/send_redirects
	done

/usr/sbin/ipsec start --nofork &
/bin/sleep 25
/sbin/iptables -t nat -A POSTROUTING -s $VPN_SUBNET -j MASQUERADE

[ "$1" ] && exec "$@"

