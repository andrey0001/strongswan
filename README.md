### StrongSwan as a Docker container

## IPSec XAUTH ikev1 VPN server

Just build it or pull it from andrey0001/strongswan and run it something like this:

```
docker run -t -d --privileged \
-e VPN_USER=user \
-e VPN_PASS=password \
-e VPN_PSK=secretkey \
-e VPN_SUBNET=192.168.14.0/24 \
--publish 4500:4500/udp \
--publish 500:500/udp \
--hostname strongswan \
--name strongswan andrey0001/strongswan
```

* VPN_USER = username (default:user1)
* VPN_PASS = password (default:Sup3rS3cr3t)
* VPN_PSK = preshared key (default:s3cr3tk3y)
* VPN_SUBNET = network (default:192.168.95.0/24)
#

You could add additional users to the file /etc/strongswan/ipsec.secrets , then reload secrets by: 
```
strongswan rereadsecrets
```
inside the container.

Also, you could use volume (bind mount a volume) for configuration files of strongswan (to store it on host):
```
-v /etc/strongswan:/etc/strongswan 
```
and reread secrets from host:
```
docker exec -it strongswan /usr/sbin/strongswan rereadsecrets
```
and reread configuration
```
docker exec -it strongswan /usr/sbin/strongswan update
```
