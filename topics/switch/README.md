# Switch Documentation

## Switch Config for the Cisco Switch 3850–NM-4-10G

At any point, you may enter a question mark '?' for help. Use ctrl-c to abort configuration dialog at any prompt. Default settings are in square brackets '[ ]'. 
 
### Enter a hostname for the Switch:
- Switch>Enable
- Switch#Config terminal
- Switch(config)#hostname switch.xx

### Setting Domain Name:
- Switch.XX(config)#ip domain-name cmat.lan

### Set local user and password:
- Switch>Enable
- Switch#Config terminal
- Switch.XX(config)#username admin privilege 15 secret {insert password}

### Set up console:
- Switch>Enable
- Switch#Config terminal
- Switch.XX(config)#line con 0
- Switch.XX(config)#exec-timeout 60 0
- Switch.XX(config)#no length or length 0(optional)
- Switch.XX(config)#login local

### Setting time:
- Switch>Enable
- Switch#Config terminal
- Switch.XX(config)#ntp server 10.x.2.1 source vlan 2

### Set up authentication:
- Switch>Enable
- Switch#Config terminal
- Switch.XX(config)#aaa new-model
- Switch.XX(config)#aaa session-id common

### Create VLANs:
- Switch.xx>Enable
- Switch.xx#Config terminal
- Switch.xx(config)#vlan 2
- Switch.xx(config)#vlan 10
- Switch.xx(config)#vlan 20
- Switch.xx(config)#vlan 40
- Switch.xx(config)#vlan 50
- Switch.xx(config)#vlan 60

- Switch.xx(config)#int vlan 2
- Switch.xx(config-if)#ip address 10.x.2.2 255.255.255.0
- Switch.xx(config-if)#description ROUTING_XC
- Switch.xx(config)#int vlan 10
- Switch.xx(config-if)#description ACCESS_PORTS_INTERNAL
- Switch.xx(config-if)#ip address 10.x.10.1 255.255.255.0
- Switch.xx(config)#int vlan 20
- Switch.xx(config-if)#description ACCESS_PORT_ACTIVE
- Switch.xx(config-if)#ip address 10.x.20.2 255.255.255.0
- Switch.xx(config)#int vlan 40
- Switch.xx(config-if)#ip address 10.x.40.1 255.255.255.0
- Switch.xx(config)#int vlan 50
- Switch.xx(config-if)#description AP_MGMT
- Switch.xx(config-if)#ip address 10.x.50.1 255.255.255.0
- Switch.xx(config)#int vlan 60
- Switch.xx(config-if)#description WIRELESS_CLIENTS
- Switch.xx(config-if)#ip address 10.x.60.1 255.255.255.0
- Switch.xx(config-if)#exit

### Configure the Interfaces:
- Switch>Enable
- Switch#Config terminal
- Switch.XX(config)#int gi0/0
- Switch.XX(config-if)#shut

- Switch.XX(config-if)#interface gi1/0/1
- Switch.XX(config-if)#switch mode trunk

- Switch.XX(config-if)#int gi1/0/2
- Switch.XX(config-if)#switch mode access
- Switch.XX(config-if)#spanning-tree portfast
- Switch.XX(config-if)#switchport access vlan 50
- Switch.XX(config-if)#ip nbar protocol-discovery

- Switch.XX(config-if)#int range gi1/0/3-39
- Switch.XX(config-if)#switch mode access
- Switch.XX(config-if)#spanning-tree portfast
- Switch.XX(config-if)#switchport access vlan 10
- Switch.XX(config-if)#description ACCESS_PORTS_INTERNAL

- Switch.XX(config-if)#int range gi1/0/40-48
- Switch.XX(config-if)#switch mode access
- Switch.XX(config-if)#spanning-tree portfast
- Switch.XX(config-if)#switchport access vlan 20
- Switch.XX(config-if)#description ACCESS_PORT_ACTIVE

- Switch.XX(config-if)#int te1/1/1
- Switch.XX(config-if)#description *** CONNECTED TO ESXI ***
- Switch.XX(config-if)#switchport access vlan 10
- Switch.XX(config-if)#switchport mode trunk

- Switch.XX(config-if)#int te1/1/2
- Switch.XX(config-if)#description *** CONNECTED TO SENSOR ***
- Switch.XX(config-if)#switchport access vlan 10
- Switch.XX(config-if)#switchport mode access

- Switch.XX(config-if)#int range te1/1/3-4
- Switch.XX(config-if)#shut
- Switch.XX(config-if)#exit

### Configure Access Control List:
- Switch.XX(config)#ip access-list extended ACTIVE_OUTBOUND
- Switch.XX(config-ext-nacl)#deny ip any 10.x.10.0 0.0.0.255
- Switch.XX(config-ext-nacl)#deny ip any 10.x.40.0 0.0.0.255
- Switch.XX(config-ext-nacl)#deny ip any 10.x.50.0 0.0.0.255
- Switch.XX(config-ext-nacl)#deny ip any 10.x.60.0 0.0.0.255
- Switch.XX(config-ext-nacl)#permit ip any any

- Switch.XX(config)#aaa new-model
- Switch.XX(config)#aaa session-id common
- Switch.XX(config)#ip routing
- Switch.XX(config)#ip nbar http-services
- Switch.XX(config)#no ip domain lookup
- Switch.XX(config)#device classifier
- Switch.XX(config)#service-routing mdns-sd
- Switch.XX(config-mdns)#designated-gateway enable
- Switch.XX(config)#ip route 0.0.0.0 0.0.0.0 10.2.20.1

- Switch.XX(config)#ip dhcp excluded-address 10.x.50.1 10.x.50.10
- Switch.XX(config)#ip dhcp excluded-address 10.x.60.1 10.x.60.20
- Switch.XX(config)#ip dhcp pool AP_CONFIG
- Switch.XX(dhcp-config)#network 10.x.50.0 255.255.255.0
- Switch.XX(dhcp-config)#default-router 10.x.50.1
- Switch.XX(dhcp-config)#option 150 ip 10.x.50.1
- Switch.XX(dhcp-config)#exit

- Switch.XX(config)#ip dhcp pool AP_CLIENTS
- Switch.XX(dhcp-config)#network 10.x.60.0 255.255.255.0
- Switch.XX(dhcp-config)#default-router 10.x.60.1
- Switch.XX(dhcp-config)#dns-server 10.x.10.1 208.67.222.222
- Switch.XX(dhcp-config)#domain-name cmat.lan

### Configure Wireless Access:
- Switch.XX(config)#flow monitor wireless-avc-basic
- Switch.XX(config-flow-monitor)#record wireless avc basic
- Switch.XX(config-flow-monitor)#exit

- Switch.XX(config)#event manager environment UNSUPPORTED_AP_VLAN 50
- Switch.XX(config)#wireless mobility controller
- Switch.XX(config)#wireless management interface vlan 50
- Switch.XX(config)#wireless multicast
- Switch.XX(config)#wireless mgmt-via-wireless
- Switch.XX(config)#wlan CMAT.XX 1 CMAT.XX
- Switch.XX(config-wlan)#auto qos enterprise
- Switch.XX(config-wlan)#client vlan 0060
- Switch.XX(config-wlan)#ip flow monitor wireless-avc-basic input
- Switch.XX(config-wlan)#ip flow monitor wireless-avc-basic output
- Switch.XX(config-wlan)#radio dot11bg
- Switch.XX(config-wlan)#no security wpa akm dot1x
- Switch.XX(config-wlan)#security wpa akm psk set-key ascii 0 cyberteam
- Switch.XX(config-wlan)#no shut
- Switch.XX(config-wlan)#exit

- Switch.XX(config)#ap fra
- Switch.XX(config)#ap ntp ip 10.x.2.1
- Switch.XX(config)#ap dot11 24 ghz rf-profile a
- Switch.XX(config-rf-profile)#dot11n-only
- Switch.XX(config-rf-profile)#no shut
- Switch.XX(config-rf-profile)#exit

- Switch.XX(config)#ap group cmat
- Switch.XX(config-apgroup)#remote-lan CMAT.XX
- Switch.XX(config-apgroup)#airtime-fairness dot11 24Ghz mode enforce-policy
- Switch.XX(config-apgroup)#airtime-fairness dot11 24Ghz optimization
- Switch.XX(config-apgroup)#airtime-fairness dot11 5Ghz mode enforce-policy
- Switch.XX(config-apgroup)#airtime-fairness dot11 5Ghz optimization
- Switch.XX(config-apgroup)#hyperlocation
- Switch.XX(config-apgroup)#wlan CMAT.XX
- Switch.XX(config-wlan-apgroup)#vlan VLAN0060
- Switch.XX(config-wlan-apgroup)#port 1
- Switch.XX(config-port-apgroup)#no shut
- Switch.XX(config-port-apgroup)#port 2
- Switch.XX(config-port-apgroup)#no shut
- Switch.XX(config-port-apgroup)#port 3
- Switch.XX(config-port-apgroup)#no shut
- Switch.XX(config-port-apgroup)#rf-profile dot11 24ghz a
- Switch.XX(config-apgroup)#
