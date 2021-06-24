#!/bin/bash
#make sure you use the approprite version of rock
sudo reposync -n -l --repoid=epel --repoid=atomic --repoid=rhel-7-server-rpms --repoid=rhel-7-server-optional-rpms --repoid=rhel-7-server-extras-rpms --repoid=elastic-6.x --repoid=group_rocknsm-rocknsm-2.[x] --download_path=/var/www/html --downloadcomps --download-metadata
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
#ensure you specify the version you wish to use.
cd /var/www/html/group_rocknsm-rocknsm-2.[x]
sudo createrepo -v  /var/www/html/elastic-6.x -g comps.xml
cd /var/www/html/elastic-6.x
#please ensure you specify the version you wish to use
sudo createrepo -v  /var/www/html/copr-rocknsm-2.[x]
sudo createrepo -v /var/www/html/rock2
sudo createrepo -v /var/www/html/capes
sudo chcon -R -t httpd_sys_content_t /var/www/html/*
