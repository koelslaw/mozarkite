# OpenVAS

OpenVAS is a framework of several services and tools offering a comprehensive and powerful vulnerability scanning and vulnerability management solution. The framework is part of Greenbone Networks' commercial vulnerability management solution from which developments are contributed to the Open Source community since 2009.

## Create the Active Virtual Machine for OpenVAS
- Log into ESXi
- Select `Create/Register VM`  
  - Name: `OpenVAS`  
  - Compatibility: Leave default  
  - Guest OS Family: `Linux`  
  - Guest OS Version: `Red Hat Enterprise Linux 7 (64-bit)`  
- Select your storage  
- Customize the VM  
  - CPU: `4`  
  - Memory: `8 GB` , Reserved
  - Hard disk 1: `50 GB`  
  - SCSI Controller 0: Leave default  
  - SATA Controller 0: Leave default  
  - USB controller 1:  Leave default  
  - Network Adapter: `Active`, ensure that `Connect` is enabled  
  - CD/DVD Drive 1: `Datastore ISO file`, select the RHEL ISO you uploaded above, ensure that `Connect` is enabled  
  - Video Card:  Leave default  
- Review your settings  
- Click Finish  

## Installation
- Build a [virtual machine on the Active virtual network](../vmware/README.md#Create-the-Active-Virtual-Machine)  
- Install OS in accordance with [Rhel Documentation](../rhel/README.md)
- Enable only the `rhel-7-server-rpms` and `atomic` repositories. `epel` will throw things off if it is enabled.
## Prep on the Nuc
- Ensure AYR has been run.
- Ensure openvas-offline tool has been run.

- Install OpenVAS `sudo yum install openvas`

- Remove, or comment out, the check for SELinux being turned off on line 49 - 56, **because only animals turn off SELinux**  
```
vi /bin/openvas-setup
:set nu
...
49 # Test for SELinux
50 SELINUX=$(getenforce)
51 if [ "$SELINUX" != "Disabled" ]; then
52        echo "Error: Selinux is set to ($SELINUX)"
53        echo "  selinux must be disabled in order to use openvas"
54        echo "  exiting...."
55        exit 1
56 fi
...
```

- Run the OpenVAS setup script `sudo openvas-setup`  
- Edit OpenVAS config to point to the correct Redis `unixsocket` add line 97 to the file  
```
vi /etc/openvas/openvassd.conf  
shift+g
:set nu
...
82 #--- Knowledge base saving (can be configured by the client) :
83 # Save the knowledge base on disk :
84 save_knowledge_base = no
85 # Restore the KB for each test :
86 kb_restore = no
87 # Only test hosts whose KB we do not have :
88 only_test_hosts_whose_kb_we_dont_have = no
89 # Only test hosts whose KB we already have :
90 only_test_hosts_whose_kb_we_have = no
91 # KB test replay :
92 kb_dont_replay_scanners = no
93 kb_dont_replay_info_gathering = no
94 kb_dont_replay_attacks = no
95 kb_dont_replay_denials = no
96 kb_max_age = 864000
97 kb_location = /run/redis/redis.sock
98 #--- end of the KB section
...
```
- Open the firewall for `port 9392` allowing access to the UI
```
firewall-cmd --add-port=9392/tcp --permanent  
firewall-cmd --reload
```

- Add the `unixsocket` for Redis, and make sure we add it where SELinux will be happy with it  
```
vi /etc/redis.conf
...
unixsocket /run/redis/redis.sock
unixsocketperm 700
```

## Rebuild the NVT database
By far, the easiest way to update the NVT database is to do with an internet connection. That may not always be possible, so if you haven't taken the time to configure the Nuc to grab the updates for you, then may now is a good time; otherwise, if an internet connection is available, then, by all means, update the definitions.  
```
sudo systemclt start redis.service
openvasmd --rebuild
systemctl restart redis openvas-manager.service openvas-scanner.service
```
Move to [Nmap](./nmap/README.md)
