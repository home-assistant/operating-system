# Network

Home Assistant Operating System uses NetworkManager to control the host network.

## Configure network

By default the device will be in DHCP state.

Basic network settings can be set through the Supervisor frontend in the System
tab. Advanced configurations such as VLAN are also available through the
`ha network` CLI command.

To restore the default configuration the `ha network` CLI command can be used as
well:

```
ha network update default --ipv4-method auto
```

If more advanced network settings are required network connection files can be
placed on a USB drive and imported to the host as described in
[Configuration][configuration-usb].

## Manual Network Configuration

If the frontend or `ha network` CLI cannot meet your use case, it is still
possible to configure the underlying NetworkManager manually.

You can read the [NetworkManager manual][nm-manual] or find many configuration
examples across the internet. Note that changes to `NetworkManager.conf` are
not supported currently, only connection keyfiles are supported. Keep in mind
that the system is read-only. If you don't want the IP address to change on
every boot, you should modify the UUID property to a generic [UUID4][uuid].
Inside the `\CONFIG\network\` directory on the USB drive or SD card, create a
file called `my-network` and add the appropriate contents below:

**NOTE: Please make sure to save this file with UNIX line endings (LF, and not Windows' default CRLF endings). You can do this using Notepad these days!**

### Default

A preinstalled connection profile for wired network is active by default:

```ini
[connection]
id=Home Assistant OS default
uuid=f62bf7c2-e565-49ff-bbfc-a4cf791e6add
type=802-3-ethernet
llmnr=2
mdns=2

[ipv4]
method=auto

[ipv6]
addr-gen-mode=stable-privacy
method=auto
```

### Wired connection to the LAN

```ini
[connection]
id=my-network
uuid=d55162b4-6152-4310-9312-8f4c54d86afa
type=802-3-ethernet
llmnr=2
mdns=2

[ipv4]
method=auto

[ipv6]
addr-gen-mode=stable-privacy
method=auto
```

### Wireless LAN WPA/PSK

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

For `address`, the value before the semicolon is the IP address and subnet prefix bitlength. The second value (after the semicolon) is the IP address of the local gateway.

## Tips

### Reset network

If you want to reset the network configuration back to the default connection
profile using DHCP, use the following commands on the host console:

```bash
# rm -r /mnt/overlay/etc/NetworkManager/system-connections
# reboot
```

Home Assistant OS will recreate the default connection profile during boot.

### Enabling Wi-Fi

Wi-Fi is discouraged for reliability reasons. However, if you still prefer to use Wi-Fi, you can us the `ha network` command to set up Wi-Fi (example for a Raspberry Pi 4, check `ha network info` to check if your board supports Wi-Fi and the name of the Wi-Fi device):

```bash
ha network update wlan0 --ipv4-method auto --wifi-auth wpa-psk --wifi-mode infrastructure --wifi-ssid "MY-SSID" --wifi-psk MY_PASS
````

### Powersave

If you have trouble with powersave then apply the following changes:

```ini
[wifi]
# Values are 0 (use default), 1 (ignore/don't touch), 2 (disable) or 3 (enable).
powersave=0
```

## Using `nmcli` to set a static IPv4 address

Log into the the Home Assistant OS base system via a console:

```bash
Welcome to Home Assistant
homeassistant login:
```

- Login as `root` (no password needed). At the `ha >` prompt, type `login` (as instructed).

From there you use the `nmcli` configuration tool.

- `# nmcli con show` will list the "Home Assistant OS default" connection in use.
- `# nmcli con show "Home Assistant OS default"` will list all the properties of the connection.

To start editing the configuration setting for "Home Assistant OS default":

```bash
# nmcli con edit "Home Assistant OS default"
```

To add your static IP address (select 'yes' for manual method);

```bash
nmcli> set ipv4.addresses 192.168.100.10/24
Do you also want to set 'ipv4.method' to 'manual'? [yes]:
```

In addition, it's recommended to set the DNS server and the local gateway. For most home routers the DNS server will have the same IP address as the router itself. If you are using Pi-Hole or a third-party DNS system then you can set the DNS server to that.

```bash
nmcli> set ipv4.dns 192.168.100.1
nmcli> set ipv4.gateway 192.168.100.1
```

`nmcli> print ipv4` will show you the IPv4 properties of this connection. With `nmcli> save` you will save the changes afterwards.

If you now view the default connection `cat /etc/NetworkManager/system-connections/default` you should see the method is manual and the address is set.

Doing a `nmcli con reload` does not always work, so restart the virtual machine or the physical system.

[nm-manual]: https://networkmanager.dev/docs/api/1.40/manpages.html
[configuration-usb]: configuration.md
[uuid]: https://www.uuidgenerator.net/version4
