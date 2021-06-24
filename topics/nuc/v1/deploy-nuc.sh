#!/bin/bash
# Cant take credit for much of this. Andy Pease created much of the base for this script (NTP, Gitea)

################################
######### Epel Release #########
################################
# The DISA STIG for CentOS 7.4.1708 enforces a GPG signature check for all repodata. While this is generally a good idea, it causes repos tha do not use GPG Armor to fail.
# One example of a repo that does not use GPG Armor is Epel; which is a dependency of CAPES (and tons of other projects, for that matter).
# To fix this, we are going to disable the GPG signature and local RPM GPG signature checking.
# I'm open to other options here.
# RHEL's official statement on this: https://access.redhat.com/solutions/2850911
sudo sed -i 's/localpkg_gpgcheck=1/localpkg_gpgcheck=0/' /etc/yum.conf

################################
##### Collect Credentials ######
################################

# Create your Gitea passphrase
echo "Create your Gitea passphrase for the MySQL database and press [Enter]. You will create your Gitea administration credentials after the installation."
read -s giteapassphrase

# ensures we have the latest for our nuc
sudo yum update
################################
### Create Local Repository ####
################################
#create rock repos

sudo yum-config-manager --add-repo https://copr.fedorainfracloud.org/coprs/g/rocknsm/rocknsm-2.4/repo/epel-7/group_rocknsm-rocknsm-2.[X]-epel-7.repo

#Create Elastic Repo
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

sudo bash -c 'cat > /etc/yum.repos.d/elastic.repo <<EOF
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF'

# Create the Atomic (OpenVAS) Repos
sudo bash -c 'cat > /etc/yum.repos.d/atomic.repo <<EOF
# Name: Atomic Rocket Turtle RPM Repository for CentOS / Red Hat Enterprise Linux 7 -
# URL: http://www.atomicrocketturtle.com/
[atomic]
name = CentOS / Red Hat Enterprise Linux $releasever - atomic
mirrorlist = http://updates.atomicorp.com/channels/mirrorlist/atomic/centos-7-x86_64
enabled = 1
protect = 0
gpgkey = file:///etc/pki/rpm-gpg/RPM-GPG-KEY.art.txt
    file:///etc/pki/rpm-gpg/RPM-GPG-KEY.atomicorp.txt
gpgcheck = 1
EOF'

# Create the Atomic (OpenVAS) keys
sudo bash -c 'cat > /etc/pki/rpm-gpg/RPM-GPG-KEY.art.txt <<EOF
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.2.1 (GNU/Linux)

mQGiBEGP+skRBACyZz7muj2OgWc9FxK+Hj7tWPnrfxEN+0PE+n8MtqH+dxwQpMTd
gDpOXxJa45GM5pEwB6CFSFK7Fb/faniF9fDbm1Ga7MpBupIBYLactkoOTZMuTlGB
T0O5ha4h26YLqFfQOtlEi7d0+BDDdfHRQw3o67ycgRnLgYSA79DISc3MywCgk2TR
yd5sRfZAG23b4EDl+D0+oaMEAK73J7zuxf6F6V5EaxLd/w4JVB2xW0Glcn0fACOe
8FV9lzcZuo2xPpdGuyj02f/xlqvEav3XqTfFU2no61mA2pamaRNhlo+CEfGc7qde
/1twfSgOYqzeCx7+aybyPo8Th41b80FT19mfkjBf6+5NbUHffRabFFh1FmcPVNBn
F3FoA/95nRIzqDMItdTRitaZn02dIGNjdwllBD75bSVEvaR9O5hjBo0VMc25DB7f
DM2qEO52wCQbAKw9zFC284ekZVDaK4aHYt7iobHaqJEpKHgsDut5WWuMiSLR+SsF
aBHIZ9HvrKWLSUQKHU6A1Hva0P0r3GnoCMc/VCVfrLl721SjPbQzQXRvbWljIFJv
Y2tldCBUdXJ0bGUgPGFkbWluQGF0b21pY3JvY2tldHR1cnRsZS5jb20+iFkEExEC
ABkFAkGP+skECwcDAgMVAgMDFgIBAh4BAheAAAoJEDKpURRevSdEzcQAn1hSHqTO
jwv/z/picpOnR+mgycwHAKCBex2ciyXo5xeaQ9w7OMf7Jsmon7kBDQRBj/rMEAQA
6JvRndqE4koK0e49fUkICm1X0ZEzsVg9VmUW+Zft5guCRxmGlYTmtlC7oJCToRP/
m/xH5uIevGiJycRKB0Ix+Csl6f9QuTkQ7tSTHcaIKbI3tL1x6CCBoWeTGYaOJlvk
ubrmajiMFaBfopLH2firoSToDGoUvv4e7bImIHEgNr8AAwUEAND0YR9DOEZvc+Lq
Ta/PQyxkdZ75o+Ty/O64E3OmO1Tuw2ciSQXCcwrbrMSE6EHHetxtGCnOdkjjjtmH
AnxsxdONv/EJuQmLcoNcsigZZ4tfRdmtXgcbnOmXBgmy1ea1KvWcsmecNSAMJHwR
7vDDKzbj4mSmudzjapHeeOewFF10iEYEGBECAAYFAkGP+swACgkQMqlRFF69J0Sq
nQCfa/q9Y/oY4dOTGj6MsdmRIQkKZhYAoIscjinFwTru4FVi2MIEzUUMToDK
=NOIx
-----END PGP PUBLIC KEY BLOCK-----
EOF'
sudo bash -c 'cat > /etc/pki/rpm-gpg/RPM-GPG-KEY.atomicorp.txt <<EOF
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.5 (GNU/Linux)

mQINBFCrkUwBEADpjFL/PJmBGz36ZZVCGE9nxxrwYdIDYjvrjS9Xoq0qExcJE2qD
VitCDI9KLX7/qu61985vF13C5oqpuhl7nqTjwC59VJM+bitblj7o4DtKflyVtUK8
ee0PwDnOk0NDHZZVB2KcaLs+cblbZL6LOjtQgWqjE7VH5AreeaqaJldP8kRBl/2R
Ug8o8NyUlvhGVKK/s7scIU9GhV4diFnNipnpdSZtRO1wgkGJ/uMhkSVRVrS1Ci0p
iADA+gmbmHpyk+H8JrtuiHm5K0OE31MoIM5jLwEpTzX5yQXOCEkQ8Dmfxy5T1qSV
1d6WdmoBmcXltfXifbNLkOYdZCTiW1z9uxi+PZ0GAyv04qICElDgCSGJ/5UxOjYG
GhDNRs7BmEHSfQHD9kE7VJ98JnQPqcwOO6IBgRuEt4z9Qw/ksPBBeZ11ktitWPDl
xP4PBy/JNb1/B2BmvjYvmYk88w9OUbwMXL8pkiQ/xMf3IltXKig6dOnjNOfQhmMf
uYztVbPtHct4eCxx12ThfvixygG/TIeq4VHbg0GW+wt39LtSgV+3BUz9QiQKY/wo
SIJbK5oaK0ZNdah8DCqco6xyNH67qbahZoXS2K+y0Um2+0ZBFH7wLrswW4eRTVsk
RFr79V/a8vh09GqoKN4tzNwpId4n5ivuwoYbca5j1AoW0GR4ne8MdSbAtwARAQAB
tEJBdG9taWNvcnAgKEF0b21pY29ycCBPZmZpY2lhbCBTaWduaW5nIEtleSkgPHN1
cHBvcnRAYXRvbWljb3JwLmNvbT6JAjYEEwECACAFAlCrkUwCGwMGCwkIBwMCBBUC
CAMEFgIDAQIeAQIXgAAKCRD/vV0KRSCvqax4D/9G93N+b8CHcGQRzdpRnjLQ3lRp
vSFZlc2dBW7d9PuoO8yw0nJ5QkEfROZvg6fgNesYzDUdYcqSiTb91sDv2XENS3h7
D9gx4kutGbb/KZNH8LJfinq429zvA00xdct5zL9c7PKM/qRxE1zdZlyJ03/ewLI5
qyvcaHgZ8PQze1+vye0txuC40FVdCkZCXWlgX3Tw+JaCPtKHsC91+fcvKGRUEb5/
+3owf3bnuKem3dcqlZlpniJtUIqfgwSTIZUwNfbE4jYsF/0mtM0wruJN0CWf5zCg
ICLG3TrcwrDEgSDkci+igcxz9heQ9DXuFuaUDE+DndyoeY7UmHjpGwmHwsJ0HttB
V574FB5oFndS4+AAz8ut6UT5ydEaPsMnQYAeSJxU0C5EFyA3UjIOsSe1esVm3sDq
VezPn4Q74Ex6YMX5w9OGCVlpl/TLM7b0UD0158RT6rxkW8owXaJwb1JO8wUNSIzN
2E2tm6FRVpOdxhR2CdkKMNilOG6glpi+3ZRgrXEr83bAYN6rwyUWHW3ihdfzVX6t
ZzIJVvnnEzxQaUISI/ZMzVlmzgyxOYseXHeapFJG92gNwxu2IqFlQ4xWUBkJiQll
ZkDBI7nqmV87cSJZsQPQPEzZej6rKA/pvOaUR9+p9jCildt2m9ulozk2pXgJgNVb
kt1o05etg6iRaeSaNQ==
=DrwN
-----END PGP PUBLIC KEY BLOCK-----
EOF'

# Collect files
sudo mkdir -p /var/www/html/repo/capes
sudo mkdir -p /var/www/html/repo/grassmarlin
sudo mkdir -p /var/www/html/repo/nmap
sudo mkdir -p /var/www/html/rock2
sudo yum install wget ansible -y
cd ~/
# Change this url for different isos
sudo wget https://download.rocknsm.io/rocknsm-2.3.0-1902.iso
sudo cp rocrocknsm-2.3.0.iso /var/www/html/.
# Capes dependencies
sudo yum install https://dl.bintray.com/thehive-project/rpm-stable/thehive-project-release-1.1.0-2.noarch.rpm
sudo yum install --downloadonly --downloaddir=/var/www/html/repo/capes cortex
sudo yum install https://dl.bintray.com/thehive-project/rpm-stable/thehive-project-release-1.1.0-2.noarch.rpm
sudo yum install --downloadonly --downloaddir=/var/www/html/repo/capes thehive
sudo curl -o /var/www/html/repo/capes/gitea-master-linux-amd64 https://dl.gitea.io/gitea/master/gitea-master-linux-amd64
sudo curl -L https://github.com/nsacyber/GRASSMARLIN/releases/download/v3.2.1/grassmarlin-3.2.1-1.el6.x86_64.rpm -o /var/www/html/repo/grassmarlin/grassmarlin-3.2.1-1.el6.x86_64.rpm
sudo curl -L https://github.com/mumble-voip/mumble/releases/download/1.2.19/murmur-static_x86-1.2.19.tar.bz2 -o /var/www/html/repo/capes/mattermost.tar.gz
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
sudo curl -L https://dl.bintray.com/thehive-project/rpm-stable/thehive-project-release-1.1.0-1.noarch.rpm -o /var/www/html/repo/capes/thehive-project-release-1.1.0-1.noarch.rpm
sudo curl -L https://dl.gitea.io/gitea/master/gitea-master-linux-amd64 -o /var/www/html/repo/capes/gitea-master-linux-amd64
sudo curl -L https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.5-x86_64.rpm -o /var/www/html/repo/capes/elasticsearch-5.6.5-x86_64.rpm
sudo curl -L https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-5.6.5-x86_64.rpm -o /var/www/html/repo/capes/heartbeat-5.6.5-x86_64.rpm
sudo curl -L https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.6.5-x86_64.rpm -o /var/www/html/repo/capes/filebeat-5.6.5-x86_64.rpm
sudo curl -L https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-5.6.5-x86_64.rpm -o /var/www/html/repo/capes/metricbeat-5.6.5-x86_64.rpm
sudo curl -L https://artifacts.elastic.co/downloads/kibana/kibana-5.6.5-x86_64.rpm -o /var/www/html/repo/capes/kibana-5.6.5-x86_64.rpm
sudo curl -L https://releases.mattermost.com/4.9.2/mattermost-4.9.2-linux-amd64.tar.gz -o /var/www/html/repo/capes/mattermost.tar.gz
sudo curl -L https://gchq.github.io/CyberChef/cyberchef.htm -o /var/www/html/repo/capes/cyberchef.htm
sudo yum install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
sudo curl -l http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm -o /var/www/html/repo/capes/wandisco-git-release-7-2.noarch.rpm
# Creation of repo structure
sudo yum install yum-utils createrepo httpd -y
sudo rpm --import /etc/pki/rpm-gpg/*
sudo reposync -n -l --repoid=epel --repoid=atomic --repoid=rhel-7-server-rpms --repoid=rhel-7-server-optional-rpms --repoid=rhel-7-server-extras-rpms --repoid=elastic-6.x --repoid=group_rocknsm-rocknsm-2.X --download_path=/var/www/html --downloadcomps --download-metadata
cd /var/www/html/epel
sudo createrepo -v  /var/www/html/epel -g comps.xml
cd /var/www/html/rhel-7-server-rpms
sudo createrepo -v  /var/www/html/rhel-7-server-rpms -g comps.xml
cd /var/www/html/rhel-7-server-optional-rpms
sudo createrepo -v  /var/www/html/rhel-7-server-optional-rpms -g comps.xml
cd /var/www/html/rhel-7-server-extras-rpms
sudo createrepo -v  /var/www/html/rhel-7-server-extras-rpms -g comps.xml
cd /var/www/html/atomic
sudo createrepo -v  /var/www/html/atomic
cd /var/www/html/atomic-testing
sudo createrepo -v  /var/www/html/atomic-testing
cd /var/www/html/epel
sudo createrepo -v  /var/www/html/epel -g comps.xml
#Ensure yuo enter the version yuo wish to use.
cd /var/www/html/group_rocknsm-rocknsm-2.[X}
sudo createrepo -v  /var/www/html/elastic-6.x -g comps.xml
cd /var/www/html/elastic-6.x
#Ensure you put in the cersion you want
sudo createrepo -v  /var/www/html/copr-rocknsm-2.[x]
sudo createrepo -v /var/www/html/rock2
sudo createrepo -v /var/www/html/capes
# Adjust the SELinux context for Apache
sudo chcon -R -t httpd_sys_content_t /var/www/html/*

################################
########## Gitea ###############
################################

# Big thanks to @seven62 for fixing the Git 2.x and MariaDB issues and getting the service back in the green!

# Install dependencies
sudo yum install epel-release -y
sudo yum install mariadb-server http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm -y
sudo yum update git -y
sudo systemctl start mariadb.service

# Configure MariaDB
mysql -u root -e "CREATE DATABASE gitea;"
mysql -u root -e "GRANT ALL PRIVILEGES ON gitea.* TO 'gitea'@'localhost' IDENTIFIED BY '$giteapassphrase';"
mysql -u root -e "FLUSH PRIVILEGES;"
mysql -u root -e "set global innodb_file_format = Barracuda;
set global innodb_file_per_table = on;
set global innodb_large_prefix = 1;
use gitea;
CREATE TABLE oauth2_session (
  id varchar(400) NOT NULL,
  data text,
  created_unix bigint(20) DEFAULT NULL,
  updated_unix bigint(20) DEFAULT NULL,
  expires_unix bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE oauth2_session
  ADD PRIMARY KEY (id(191));
COMMIT;"

# Create the Gitea user
sudo useradd -s /usr/sbin/nologin gitea

# Grab Gitea and make it a home
sudo mkdir -p /opt/gitea
sudo cp /var/www/html/repo/capes/gitea-master-linux-amd64 /opt/gitea/gitea
sudo chmod 700 /opt/gitea/gitea
sudo chmod 600 /opt/gitea/custom/conf/app.ini
### Old settings
# sudo chmod 744 /opt/gitea/gitea
# sudo chmod 644 /opt/gitea/custom/conf/app.ini

# Create Gitea bind ip script
sudo tee /opt/gitea/gitea-config.sh <<'EOF'
#!/bin/bash

# Interface that obtains routable IP addresses
INTERFACE=eno1

# Updates the /opt/gitea/custom/conf/app.ini with your current IP
BIND_IP=$(/sbin/ip -o -4 addr list $INTERFACE | awk '{print $4}' | cut -d/ -f1)
GITEA_ROOT_URL="ROOT_URL = http://$BIND_IP:4000/"
GITEA_SSH_DOMAIN="SSH_DOMAIN = $BIND_IP"
GITEA_DOMAIN="DOMAIN = $BIND_IP"
/bin/sed -i "s|ROOT_URL.*|$GITEA_ROOT_URL|" /opt/gitea/custom/conf/app.ini
/bin/sed -i "s|^SSH_DOMAIN.*|$GITEA_SSH_DOMAIN|" /opt/gitea/custom/conf/app.ini
/bin/sed -i "s|^DOMAIN.*|$GITEA_DOMAIN|" /opt/gitea/custom/conf/app.ini

# Removes the ability to register new accounts
/bin/sed -i "s|DISABLE_REGISTRATION.*|DISABLE_REGISTRATION = true|" /opt/gitea/custom/conf/app.ini

# Executes the Gitea biary
/opt/gitea/gitea web -p 4000
EOF
sudo chmod +x /opt/gitea/bind_ip.sh
sudo chown -R gitea:gitea /opt/gitea

# Create the Gitea service
sudo bash -c 'cat > /etc/systemd/system/gitea.service <<EOF
[Unit]
Description=Gitea (Git with a cup of tea)
After=syslog.target
After=network.target
After=mariadb.service

[Service]
# Modify these two values and uncomment them if you have
# repos with lots of files and get an HTTP error 500 because
# of that
###
#LimitMEMLOCK=infinity
#LimitNOFILE=65535
RestartSec=2s
Type=simple
User=gitea
Group=gitea
WorkingDirectory=/opt/gitea

# We are going to load a custom script that makes sure our dhcp obtained IP address is bound to gitea
ExecStart=/opt/gitea/gitea-config.sh

Restart=always
Environment=USER=gitea HOME=/home/gitea

[Install]
WantedBy=multi-user.target
EOF'

# Prevent remote access to MariaDB
clear
echo "In a few seconds we are going to secure your MariaDB configuration. You'll be asked for your MariaDB root passphrase (which hasn't been set), you'll set the MariaDB root passphrase and then be asked to confirm some security configurations."
sudo sh -c 'echo [mysqld] > /etc/my.cnf.d/bind-address.cnf'
sudo sh -c 'echo bind-address=127.0.0.1 >> /etc/my.cnf.d/bind-address.cnf'
mysql_secure_installation
sudo systemctl restart mariadb.service

# Allow the services through the firewall
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-port=4000/tcp --permanent
sudo firewall-cmd --reload

################################
######## Services e#############
################################

# Prepare the service environment
sudo systemctl daemon-reload

# Set Gitea and Apache to start at boot
sudo systemctl enable gitea.service
sudo systemctl enable httpd.service
sudo systemctl enable mariadb.service

# Start services
sudo systemctl start gitea.service
sudo systemctl start httpd.service
sudo systemctl start mariadb.service

################################
########## Remove gcc ##########
################################
sudo yum -y remove gcc-c++

###############################
### Clear your Bash history ###
###############################
# We don't want anyone snooping around and seeing any passphrases you set
cat /dev/null > ~/.bash_history && history -c

# Success page
echo "Your Nuc has sucessfully be configured now it's time to deploy the servers."
