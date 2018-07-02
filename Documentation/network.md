# Network

HassOS uses NetworkManager to control the host network. In future releases, you can set up the configuration using the API/UI.
Currently only manual configuration using NetworkManager connection files is supported. Without a configuration file, the device will use DHCP by default. These network connection files can be placed on a USB drive as described in [Configuration][configuration-usb].

## Configuration Examples

You can look also into [Official Manual][keyfile] or there are a lot of examples accross internet.

### LAN
```ini
[connection]
id=hassos-network
type=ethernet

[ipv4]
method=auto

[ipv6]
addr-gen-mode=stable-privacy
method=auto
```

### Wireless WPA/PSK
```ini
[connection]
id=hassos-network
type=wifi

[wifi]
mode=infrastructure
ssid=MY_SSID

[wifi-security]
auth-alg=open
key-mgmt=wpa-psk
psk=MY_WLAN_SECRED_KEY

[ipv4]
method=auto

[ipv6]
addr-gen-mode=stable-privacy
method=auto
```

### Static IP

Replace follow configs:
```ini
[ipv4]
method=manual
address1=192.168.1.111/24,192.168.1.1
dns=8.8.8.8;8.8.4.4;
```

[keyfile]: https://developer.gnome.org/NetworkManager/stable/nm-settings.html
[configuration-usb]: configuration.md
