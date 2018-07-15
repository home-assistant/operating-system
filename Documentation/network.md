# Network

HassOS uses NetworkManager to control the host network. In future releases, you will be able to set up the configuration using the API/UI. Currently only manual configuration using NetworkManager connection files is supported. Without a configuration file, the device will use DHCP by default. These network connection files can be placed on a USB drive as described in [Configuration][configuration-usb] and the filename can be anything you like (e.g. my-wifi, or static-connection, etc).

The configuration can be imported from the USB drive using the "Import from USB" feature in the UI found on the Hass.io/System page, or through a reboot of the host while the USB drive is inserted. After import the USB drive may be removed.

## Configuration Examples

You can also read the [Official Manual][keyfile] or find a lot of examples across the internet. The system is read only, if you don't want the IP address to change every boot, you should set the uuid property with a generic [UUID4][uuid].

### Default (LAN / DHCP)

We have a preinstalled connection profile:
```ini
[connection]
id=HassOS default
uuid=f62bf7c2-e565-49ff-bbfc-a4cf791e6add
type=802-3-ethernet

[ipv4]
method=auto

[ipv6]
addr-gen-mode=stable-privacy
method=auto
```

### Wireless WPA/PSK

Edit the SSID and PSK to match your own:
```ini
[connection]
id=hassos-network
uuid=72111c67-4a5d-4d5c-925e-f8ee26efb3c3
type=802-11-wireless

[wifi]
mode=infrastructure
ssid=MY_SSID

[wifi-security]
auth-alg=open
key-mgmt=wpa-psk
psk=MY_WLAN_SECRET_KEY

[ipv4]
method=auto

[ipv6]
addr-gen-mode=stable-privacy
method=auto
```

### Static IP

Change the ipv4 settings in your connection file from auto to manual as in this example, using your own ip address and gateway:
```ini
[ipv4]
method=manual
address1=192.168.1.111/24,192.168.1.1
dns=8.8.8.8;8.8.4.4;
```

## Tips

### Reset network

If you want to reset the network configuration to default, use the following commands on the host:
```bash
$ rm /etc/NetworkManager/system-connections/*
$ cp /usr/share/system-connections/* /etc/NetworkManager/system-connections/
$ nmcli con reload
```

### Powersave

If you have trouble with the powersave feature you can add the following config to your connection file:
```ini
[wifi]
# Values are 0 (use default), 1 (ignore/don't touch), 2 (disable) or 3 (enable).
powersave=0
```

[keyfile]: https://developer.gnome.org/NetworkManager/stable/nm-settings.html
[configuration-usb]: configuration.md
[uuid]: https://www.uuidgenerator.net/
