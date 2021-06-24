# DNS Server for Kit
Up to this point, we have used static assignments for all the components of the kit. To make it easier to find stuff and allow some forms of automation, we will be setting up a DNS server first.

## Create the RHEL DNS
- Log into ESXi
- Right-Click on `Virtual Machines` and select `Create/Register VM`  
![](../../images/esxi-create-vm.png)  
  - Name: `RHEL DNS`  
  - Compatibility: Leave default  
  - Guest OS Family: `Linux`  
  - Guest OS Version: `Red Hat Enterprise Linux 7 (64-bit)`  
- Select your storage  
- Customize the VM  
  - CPU: `1`  
  - Memory: `2 GB` , Reserved
  - Hard disk 1: `16 GB`  
  - SCSI Controller 0: Leave default  
  - SATA Controller 0: Leave default  
  - USB controller 1:  Leave default  
  - Network Adapter: `Passive`, ensure that `Connect` is enabled  
  - CD/DVD Drive 1: `Datastore ISO file`, select the RHEL ISO you uploaded above, ensure that `Connect` is enabled  
  - Video Card:  Leave default  
- Review your settings  
- Click Finish  

## Prereqs
 - RHEL installed with static IP set during installation according to [RHEL Documentation](../rhel/README.md)
  - If you forgot to set a static of need to change use `sudo nmtui`
- Logged in via `ssh` or the ESXi Console

### Dnsmasq

- Install dnsmasq
  ```
  sudo yum install dnsmasq
  ```
- Configure the dnsmasq config files so dnsmasq will answer DNS queries.
  ```
  sudo vi /etc/dnsmasq.conf
  ```
- Add the following lines to the end of the config file. This binds it to the localhost and also its static IP. It also disables DHCP as the switch is already handling any DHCP we need.
  ```
  listen-address=127.0.0.1
  listen-address=10.[state].10.20
  no-dhcp-interface=
  ```
- Add the following addresses to the end of the /etc/hosts files using `sudo vi /etc/hosts`

   > NOTE: Any other DNS entries you wish to have, go here  

```
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.[state octet].10.19  nuc.[state].cmat.lan
10.[state octet].10.20  dns.[state].cmat.lan
10.[state octet].10.7   idrac1.[state].cmat.lan
10.[state octet].10.9   idrac2.[state].cmat.lan
10.[state octet].10.15  esxi1.[state].cmat.lan
10.[state octet].10.21  sensor.[state].cmat.lan
10.[state octet].10.5   gigamon.[state].cmat.lan
10.[state octet].10.25  kibana.[state].cmat.lan
10.[state octet].10.25  es1.[state].cmat.lan
10.[state octet].10.26  es2.[state].cmat.lan
10.[state octet].10.27  es3.[state].cmat.lan
10.[state octet].10.28  capes.[state].cmat.lan
10.[state octet].10.20  grassmarlin.[state].cmat.lan
```

- Allow DNS traffic through the firewall using:
```
sudo firewall-cmd --add-port=53/udp --permanent
```

- Reload the firewall config using:

```
sudo firewall-cmd --reload
```

- You should receive a `success` message if the firewall commands have been run correctly.

- Restart dnsmasq

```
sudo systemctl restart dnsmasq
```

- Add dnsmasq to startup
```
sudo systemctl enable dnsmasq
```

- Ensure dnsmasq is running
```
sudo systemctl status dnsmasq
```

Move on to [RockNSM Data Node](../rocknsm/README.md)
