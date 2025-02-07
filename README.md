# bullet-ru
🌎 Tool to bypass Russian's goverment blocking on ROUTER using Sing-box


## config.json
### Пример конфига Sing-Box в /etc/sing-box/config.json
```json
{
    "log": {
        "level": "info"
    },
    "inbounds": [
        {
            "type": "tun",
            "interface_name": "tun0",
            "domain_strategy": "ipv4_only",
            "address": [
                "172.16.250.1/30"
            ],
            "auto_route": false,
            "strict_route": false,
            "sniff": true
        }
    ],
    "outbounds": [
        {
            "domain_strategy": "",
            "flow": "",
            "packet_encoding": "",
            "server": "ip",
            "server_port": port,
            "tag": "proxy",
            "tls": {
                "alpn": [
                    "h3",
                    "h2"
                ],
                "enabled": true,
                "server_name": "sni",
                "utls": {
                    "enabled": true,
                    "fingerprint": "firefox"
                }
            },
            "type": "vless",
            "uuid": "uid"
        }
    ],
    "route": {
        "auto_detect_interface": true
    }
}

```

## add_iplst.sh
### Скрипт для добавления маршутизации запрещенных IP-адресов через VPN
```bash
sh add_iplst.sh
```
Занимается скачиванием списка из Re:filter и добавлением их в таблицу маршрутизации!!
# WARNING! Необходим мощный роутер с 256 MB ram и сильным процессором! Например AX3000T - ниже не потянет! CPU - 70%



## add_iplst_opt.sh
### Скрипт для добавления маршутизации запрещенных IP-адресов через VPN (оптимизирован)
```bash
sh add_iplst_opt.sh
```
Занимается скачиванием списка из Re:filter и добавлением их в таблицу маршрутизации, если они включают маску /24 или ниже.
Подходит для слабых роутеров (занимает около 10МБ озу и 5% cpu)
