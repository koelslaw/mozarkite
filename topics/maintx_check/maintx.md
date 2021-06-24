# Kit Maintx

## Iso Images for Installation
Download the latest versions of need isos. See Tech SME for iso images with support contracts

## RPM repos
 This will largely depend on the space considerations on the nuc. As default it will keep the latest 2 versions. RPM repos will grow slowly over time even if packages are deleted.

 ```
 repomanage --new --keep 2 ~/var/www/html/
 ```
 After that is done do not forget to reposync so the rpm databases will know the older versions are gone.

### EPEL
 ```
 cd /var/www/html/epel
 sudo createrepo -v  /var/www/html/epel -g comps.xml
 ```
### Server
 ```
 cd /var/www/html/rhel-7-server-rpms
 sudo createrepo -v  /var/www/html/rhel-7-server-rpms -g comps.xml
 ```
### Optional
 ```
 cd /var/www/html/rhel-7-server-optional-rpms
 sudo createrepo -v  /var/www/html/rhel-7-server-optional-rpms -g comps.xml
 ```
### Extras
 ```
 cd /var/www/html/rhel-7-server-extras-rpms
 sudo createrepo -v  /var/www/html/rhel-7-server-extras-rpms -g comps.xml
 ```
### Atomic (OpenVAS)
Standard
```
 cd /var/www/html/atomic
 sudo createrepo -v  /var/www/html/atomic -g comps.xml
```
Testing
```
 cd /var/www/html/atomic-testing
 sudo createrepo -v  /var/www/html/atomic-testing -g comps.xml
```
### Elasticsearch
```
 cd /var/www/html/Elasticsearch-6.x
 sudo createrepo -v  /var/www/html/Elasticsearch-6.x -g comps.xml
```

## Hardware Maintx
- Cleaning of fan assemblies
- Tightening of all screws
