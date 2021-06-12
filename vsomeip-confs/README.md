# Example application of vsomeip

## Prepare network

```
# on both containers
sudo ldconfig
sudo route add -nv 224.224.224.245 dev
# or ./setup.sh
```

* `ldconfig` to reflesh dynamic library mapping (to fix a lib discovery issue).
* `sudo route add -nv 224.224.224.245 dev` to setup a multicast route, which is necessary for the protocol.

## Prepare configuration files

`notify-conf.json` and `subscribe-conf.json`. Here we assume `alice` does notify and `bob` does subscribe.

Two fields are important and depend on the specific environemnt:

* `unicast` must be the IPv4 address of the main network interface (i.e., `172.50.1.2` for `alice` and `172.50.1.3` for `bob`).
* `multicast` must be the multicast address set by the previous `route` command (i.e., `224.224.224.245`).

## Launch the application

```
# Alice
env VSOMEIP_CONFIGURATION=/code/vsomeip-confs/notify-conf.json VSOMEIP_APPLICATION_NAME=service-sample /code/vsomeip-confs/notify-sample --udp # or ./notify.sh
# Bob
env VSOMEIP_CONFIGURATION=/code/vsomeip-confs/subscribe-conf.json VSOMEIP_APPLICATION_NAME=client-sample /code/vsomeip-confs/subscribe-sample --udp # or ./subscribe.sh
```