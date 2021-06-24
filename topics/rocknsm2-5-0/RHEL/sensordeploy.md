# ROCK Deploy
This will cover the deployment of the RockNSM sensor/data node elements. This installation is for RHEL but uses the ROCKNSM iso to aid in deployment.
​
## Prereqs
 - ESXi installed if you need it
 - ROCK NSM already installed but not deployed
 - Already SSHd into all systems that need to be deployed
 - DNS Setup or synced `/etc/hosts` file
 - Connectivity to all servers
### Install OS
> NOTE: add flags to Anaconda Preinstall **IF** any of the nodes are Virtual Machines
​

When you boot the installer, called Anaconda. Before it boots, press and append the following, which disables physical NIC naming and sets the screen resolution that is better for VMware.
​
  `net.ifnames=0 vga=791 biosdevname=0`
​
​
Install os in accordance with [RHEL Docs](../topics/rhel/README.md)

#### Disable FIPS to allow Deployment on all components
> NOTE: if you didn't DISA STIG the machine, then you do not need to do this.
​

- Disable FIPS
​
  - Remove the dracut-fips* packages
  ```
  sudo yum remove dracut-fips\*
  ```
​
  - Backup existing FIPS initramfs
  ```
  sudo mv -v /boot/initramfs-$(uname -r).img{,.FIPS-bak}
  ```
​
  - Run dracut to rebuild the initramfs
  ```
  sudo dracut
  ```
​
  - Run Grubby
  ```
  sudo grubby --update-kernel=ALL --remove-args=fips=1
  ```
​
  - Carefully up date the grub config file setting fips=0
  ```
  sudo vi /etc/default/grub
  ```
​
  - Reboot the VM
  ```
  sudo reboot
  ```
​
  - Log back in.
​
  - Confirm that fips is disabled by
  ```
  sysctl crypto.fips_enabled
  ```
​
    if it returns 0 then it has been properly disabled
​
#### Sync the Clocks across all machines
Due to the nature of virtual machines, we have to keep the VMs and Baremetal equipment in sync. To this, we set the sensor as the authority for time for the rest of the kit. We do this for a couple of reasons, the biggest being that it is where the time-based data is generated from Zeek(Bro), FSF, and Suricata. Aligning the rest of the stack along this guideline keeps us from writing events in the future. All events should be written in UTC to help with the response across timezones. This is done via chrony.
​
- If you have any time-based services running, turn them off. Otherwise, continue if this a new installation as we have not deployed ROCK yet.
​
- If not already installed then install chrony, this should be done on the iso
```
sudo yum install chrony
```
​
- Edit the config file with `vi`
```
sudo vi /etc/chrony.conf
```
​
- **Time Server (Likely Sensor)** Uncomment/edit the following line in the the `/etc/chrony.conf`
```
allow 10[state].10.0/24  
```
​
- Add ntp to the firewall on the sensor
```
sudo firewall-cmd --add-service=ntp --zone=work --permanent
```
​
- Reload the firewall
```
sudo firewall-cmd --reload
```
​
- **Time Client (Everything not the Sensor Server)** Uncomment all the time servers and point it to `sensor.[state].cmat.lan` or the IP address.
```
server 10.[state].10.21 iburst
```
​
- Start and enable the service.
```
sudo systemctl enable --now chronyd
```
​
- Add ntp to the firewall on the sensor
```
sudo firewall-cmd --add-service=ntp --zone=work --permanent
```
​
- Reload the firewall
```
sudo firewall-cmd --reload
```
- Verify on all the applicable clients that they can talk to the server for time.
```
chronyc sources
```
​
#### Deployment of Rock across All Machines
​
> NOTE: If not already done, then log into every server that rock will be deployed so that the key can be added to the ssh hosts file.

​
- Insert the following text into `/etc/rocknsm/host.ini`. These will tell the script what to deploy and where
​
​
```
sensor.[state].cmat.lan ansible_host=10.[state].10.21 ansible_connection=ssh
es1.[state].cmat.lan ansible_host=10.[state].10.25 ansible_connection=ssh
es2.[state].cmat.lan ansible_host=10.[state].10.26 ansible_connection=ssh
es3.[state].cmat.lan ansible_host=10.[state].10.27 ansible_connection=ssh
es4.[state].cmat.lan ansible_host=10.[state].10.28 ansible_connection=ssh
es5.[state].cmat.lan ansible_host=10.[state].10.29 ansible_connection=ssh
es6.[state].cmat.lan ansible_host=10.[state].10.30 ansible_connection=ssh
es7.[state].cmat.lan ansible_host=10.[state].10.31 ansible_connection=ssh
es8.[state].cmat.lan ansible_host=10.[state].10.32 ansible_connection=ssh
es9.[state].cmat.lan ansible_host=10.[state].10.33 ansible_connection=ssh
es10.[state].cmat.lan ansible_host=10.[state].10.34 ansible_connection=ssh
# If you have any other sensor or data nodes then you would place them in the list above.
​
​
[rock]
sensor.[state].cmat.lan
​
[web]
es1.[state].cmat.lan
​
[sensors:children]
rock
​
[zeek:children]
sensors
​
[fsf:children]
sensors
​
[kafka:children]
sensors
​
[stenographer:children]
sensors
​
[suricata:children]
sensors
​
[zookeeper]
sensor.[state].cmat.lan
​
[elasticsearch:children]
es_masters
es_data
es_ingest
​
[es_masters]
es[1:10]mocyber.lan
​
[es_data]
es[1:10]mocyber.lan
​
[es_ingest]
es[1:10]mocyber.lan
​
[elasticsearch:vars]
# Disable all node roles by default
node_master=false
node_data=false
node_ingest=false
​
[es_masters:vars]
node_master=true
​
[es_data:vars]
node_data=true
​
[es_ingest:vars]
node_ingest=true
​
[docket:children]
web
​
[kibana:children]
web
​
[logstash:children]
sensors
```
​
### Hotfixes for rock iso for a multinode deploy.
​
- remove/comment the following steps in the following playbook files:
  - for adding entries to the /etc/hosts `/mnt/rock/roles/common/tasks/configure.yml`
  - ensure that you edit the playbook in `/mnt/rock/roles/elasticsearch/templates/elasticsearch.yml.j2` and change
   `es_node_name: "{{ ansible_hostname }}"` to `{{ inventory_hostname }}`
  - disable step `Configure firewall ports for internal elastic communication` as we have already done this in predeploy in `/mnt/rock/roles/elasticsearch/tasks/before.yml`
​
  - disable step `Determine if Elasticsearch needs to be restarted`  in `/mnt/rock/roles/elasticsearch/tasks/before.yml`
  - disable step `Enable and start filebeat` in
  `/mnt/rock/roles/filebeat/tasks/main.yml`
​
  - disable subtask `notify: Enable and restart lighttpd` that is a part of `Install ROCK lighttpd configuration` in `/mnt/rock/roles/lighttpd/tasks/main.yml`
​
  - disable step `Download RockNSM elastic configs` in
  `/mnt/rock/roles/kibana/tasks/main.yml` as it ignores the offline flag and they already present
​
### Installation
Most of the Rock configuration is now automated and can be called from anywhere on the os.
​
- Start the interactive text interface for setup using `sudo rock tui`
​
- Select "Select Interfaces". This allows you to choose which interface you will manage and capture with.
​
- Choose your management interface
​
- Choose your capture interface(s).
​
> NOTE: Any interface you set for capture will spawn a Bro/Zeek, Suricata, and FSF process. So if you don't intend on using the interface, do not set it for capture.
​

- You will then be forwarded to the interface summary screen. make sure all the things are to your satisfaction
​
- Once it has returned to the installation setup screen, then choose the  "Offline/Online" installation option. This tells the installation playbook where to pull the packages. As these kits are meant to be offline, we will choose the offline installation option.
​
- Choose "No" for the offline installation.
​
- Once it has returned to the installation setup screen, then choose the  "Choose Components" installation option.
​
- Here is where you decide what capabilities your sensor will have. If you are low on resources, the recommendation is to disable docket and stenographer. Otherwise, just enable everything.
​
​
- Once it has returned to the installation setup screen, then choose the  "Choose enabled services" installation option. This needs to match the installed components unless you have a specific reason to do so.
​
- This will write the config to the ansible deployment script.
​
- Once it has returned to the installation setup screen, then choose the  "Run Installer" installation option.
​
​
**It should complete with no errors**
​
​
- start and enable filebeat
```
sudo systemctl start filebeat
sudo systemctl enable filebeat
```
​
- Check the Suricata `threads` per interface. This is so Suricata doesn't compete with bro for CPU threads in `etc/suricata/rock-overrides.yml`
```
%YAML 1.1
​
default-rule-path: "/var/lib/suricata/rules"
rule-files:
  - suricata.rules
​
af-packet:
  - interface: em4
    threads: 4   <--
    cluster-id: 99
    cluster-type: cluster_flow
    defrag: yes
    use-mmap: yes
    mmap-locked: yes
    #rollover: yes
    tpacket-v3: yes
    use-emergency-flush: yes
```
​
- make sure Suricata has been restarted. If it complains, check permissions in `etc/suricata/rock-overides.yml`
