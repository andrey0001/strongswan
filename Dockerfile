FROM alpine:3.18

MAINTAINER Andrey Sorokin <andrey@sorokin.org>

RUN apk add --no-cache bash strongswan iptables

ADD start.sh /start.sh
ADD ipsec.conf /etc/ipsec.conf
ADD ipsec.secrets /etc/ipsec.secrets
ADD strongswan.conf /etc/strongswan.conf

ENV VPN_SUBNET 192.168.95.0/24
ENV VPN_USER user1
ENV VPN_PASS Sup3rS3cr3t
ENV VPN_PSK s3cr3tk3y


EXPOSE 500/udp 4500/udp

ENTRYPOINT ["/start.sh"]
CMD ["/usr/bin/tail", "-f","/var/log/ipsec.log"]

