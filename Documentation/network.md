# Network

## Configure Network
HassOS uses NetworkManager to control the host network. In future releases, you will be able to set up the configuration using the API/UI. Currently only a manual configuration using NetworkManager connection files is supported. Without a configuration file, the device will use DHCP by default. These network connection files can be placed on a USB drive and imported to the host as described in [Configuration][configuration-usb].

## Configuration Examples

You can read the [Official Manual][keyfile] or find many configuration examples across the internet. The system is read-only, if you don't want the IP address to change on every boot, you should set the UUID property with a generic [UUID4][uuid]. Inside `\CONFIG\network\` on the USB or SD, create a file called `my-network` and add the appropriate contents below:

### Default

We have a preinstalled connection profile:

```ini
[connection]
id=my-network
uuid=f62bf7c2-e565-49ff-bbfc-a4cf791e6add
type=802-3-ethernet

[ipv4]
method=auto

[ipv6]
addr-gen-mode=stable-privacy
method=auto
```

### LAN

```ini
[connection]
id=my-network
uuid=d55162b4-6152-4310-9312-8f4c54d86afa
type=802-3-ethernet

[ipv4]
method=auto

[ipv6]
addr-gen-mode=stable-privacy
method=auto
```

### Wireless WPA/PSK

```ini
[connection]
id=my-network
uuid=72111c67-4a5d-4d5c-925e-f8ee26efb3c3
type=802-11-wireless

[802-11-wireless]
mode=infrastructure
ssid=MY_SSID
# Uncomment below if your SSID is not broadcasted
#hidden=true

[802-11-wireless-security]
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

Replace the following configuration:

```ini
[ipv4]
method=manual
address=192.168.1.111/24;192.168.1.1
dns=8.8.8.8;8.8.4.4;
```
For address, the value before the semicolon is the IP address and subnet prefix bitlength; the second value is the IP address of the gateway.

## Tips

### Reset network

If you want to reset the network configuration back to the default DHCP settings, use the following commands on the host:

```bash
$ rm /etc/NetworkManager/system-connections/*
$ cp /usr/share/system-connections/* /etc/NetworkManager/system-connections/
$ nmcli con reload
```

### Powersave

If you have trouble with powersave you can do following:

```ini
[wifi]
# Values are 0 (use default), 1 (ignore/don't touch), 2 (disable) or 3 (enable).
powersave=0
```
## Using nmcli to set a static IPV4 address

Log into the HASSOS base system via a console:

```
Welcome to Home Assistant
homeassistant login:
```
Login as `root` (no password needed)

At the `ha >` prompt, type `login` (as instructed).

From here you will use the `nmcli` configuration tool.

`# nmcli connection show` will list the “HassOS default” connection in use.

`# nmcli con show "HassOS default"` will list all the properties of the connection.

`# nmcli con edit "HassOS default"` will put you in a position to edit the connection.

`nmcli> print ipv4` will show you the ipv4 properties of this connection.

To add your static IP address (select 'yes' for manual method);
```
nmcli> set ipv4.addresses 192.168.100.10/24
Do you also want to set 'ipv4.method' to 'manual'? [yes]:
```
In addition I have found it is wise to set the dns server and the local gateway.  For most home routers these will be the same address.  If you are using Pi-Hole you can set the dns to that.
```
nmcli> set ipv4.dns 192.168.100.1
nmcli> set ipv4.gateway 192.168.100.1
nmcli> save
nmcli> quit
```

If you now view the default connection `cat /etc/NetworkManager/system-connections/default` you should see the method is manual and the address is set.

Doing a `nmcli con reload` does not always work so restart the VM.

[keyfile]: https://developer.gnome.org/NetworkManager/stable/nm-settings.html
[configuration-usb]: configuration.md
[uuid]: https://www.uuidgenerator.net/
