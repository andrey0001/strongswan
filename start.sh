#!/bin/bash

/usr/bin/echo >/var/log/ipsec.log
/usr/bin/rm -f /var/run/charon.pid

	if [ ! -f "/firsttime" ]; then
		/bin/sed -i -e "s:rightsourceip=192.168.95.0/24:rightsourceip=$VPN_SUBNET:g" /etc/strongswan/ipsec.conf
		/usr/bin/echo ": PSK \"$VPN_PSK\"" >/etc/strongswan/ipsec.secrets
		/usr/bin/echo "$VPN_USER : XAUTH \"$VPN_PASS\"" >>/etc/strongswan/ipsec.secrets
		/usr/bin/touch /firsttime	
	fi

/sbin/sysctl -w net.ipv4.ip_forward=1
/sbin/sysctl -w net.ipv4.conf.all.rp_filter=2

	for each in /proc/sys/net/ipv4/conf/*
	do
		/usr/bin/echo 0 > $each/accept_redirects
		/usr/bin/echo 0 > $each/send_redirects
	done

/usr/sbin/strongswan start --nofork &
/bin/sleep 30
/sbin/iptables -t nat -A POSTROUTING -s $VPN_SUBNET -j MASQUERADE

[ "$1" ] && exec "$@"

