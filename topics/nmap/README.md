# Nmap Install
Nmap ("Network Mapper") is a free and open-source utility for network discovery and security auditing. Many systems and network administrators also find it useful for tasks such as network inventory, managing service upgrade schedules, and monitoring host or service uptime. Nmap uses raw IP packets in novel ways to determine what hosts are available on the network, what services (application name and version) those hosts are offering, what operating systems (and OS versions) they are running, what type of packet filters/firewalls are in use, and dozens of other characteristics. It was designed to rapidly scan large networks, but works fine against single hosts.

## Documentation
Nmap [User Guide]()

## Install Instructions
### Update Repository
We want to set the Nuc as the upstream repository, you can copy / paste this following code block into the Terminal.
```
sudo bash -c 'cat > /etc/yum.repos.d/local-repos.repo <<EOF
[[atomic]
name: Atomic for OpenVAS
baseurl=http://10.[state].10.19/atomic/
gpgcheck=0
enabled=1


[capes]
name: Capes Local
baseurl=http://10.[state].10.19/capes/
gpgcheck=0
enabled=1


[copr-rocknsm-2.4]
name: copr rocknms repo
baseurl=http://10.[state].10.19/copr-rocknsm-2.4/
gpgcheck=0
enabled=1

[local-epel]
name: Extra packages For Enterprise Linux Local Repo
baseurl=http://10.[state].10.19/epel/
gpgcheck=0
enabled=1

[local-rhel-7-server-extras-rpmsx86_64]
name: local rhel 7 server extras
baseurl=http://10.[state].10.19/rhel-7-server-extras-rpms/
gpgcheck=0
enabled=1

[local-rhel-7-server-optional-rpmsx86_64]
name: local rhel 7 server optional
baseurl=http://10.[state].10.19/rhel-7-server-optional-rpms/
gpgcheck=0
enabled=1

[local-rhel-7-server-rpmsx86_64]
name: local rhel 7 server rpms
baseurl=http://10.[state].10.19/rhel-7-server-rpms/
gpgcheck=0
enabled=1

[local-wandiscox86_64]
name: wandisco
baseurl=http://10.[state].10.19/WANdisco-git/
gpgcheck=0
enabled=1

[local-elastic-6.x]
name: elastic
baseurl=http://10.[state].10.19/elastic-6.x/
gpgcheck=0
enabled=1
EOF'

```
Install NMAP

```
yum repolist all
sudo yum install nmap -y
```
