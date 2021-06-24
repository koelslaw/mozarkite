# RockNSM Sensor
This will cover the deployment of the RockNSM sensor elements.

## Prereqs
 -DNS setup

## Sensor Installation
- Perform system update and enable daily updates
```
sudo yum update -y
sudo yum install -y yum-cron wget
sudo systemctl enable yum-cron
sudo systemctl start yum-cron
sudo yum install wget
```

### Preparation for Rock Deployment

- Disable FIPS
  - Install dracut
  ```
  sudo yum install dracut
  ```
  - Remove the dracut-fips* packages
  ```
  sudo yum remove dracut-fips\*
  ```
  - Backup existing FIPS initramfs
  ```
  sudo mv -v /boot/initramfs-$(uname -r).img{,.FIPS-bak}
  ```
  - Run `dracut` to rebuild the initramfs
  ```
  sudo dracut
  ```
  - Run Grubby
  ```
  sudo grubby --update-kernel=ALL --remove-args=fips=1
  ```
  - **Carefully** up date the grub config file setting `fips=0`
  ```
  sudo vi /etc/default/grub
  ```
  - Reboot the VM
  ```
  sudo reboot
  ```

- Log back in...

- Confirm that fips is disabled by
  ```
  sysctl crypto.fips_enabled
  ```
  if it returns `0` then it has been properly disabled

- Install the Rock NSM dependencies

  ```
  sudo yum install jq GeoIP geopipupdate tcpreplay tcpdump bats policycoreutils-python htop vim git tmux nmap-ncat logrotate perl-LWP-Protocol-https perl-Sys-Syslog perl-Crypt-SSLeay perl-Archive-Tar java-1.8.0-openjdk-headless filebeat ansible
  ```
- Make a place for ROCK to live
  ```
  mkdir /opt/rocknsm
  ```

- Navigate there so we can clone the Rock NSM repo there
  ```
  cd /opt/rocknsm  
  ```

- Clone the Rock NSM repo from the NUC
  ```
  sudo git clone http://10.[state].10.19:4000/administrator/rock.git
  ```
  or if you have dns setup then
  ```
  sudo git clone http://nuc.[state].cmat.lan:4000/administrator/rock.git
  ```
- Navigate to the rock bin directory
  ```
  cd /opt/rocknsm/rock/bin
  ```
- Generate defaults for rock to deploy with
  ```
  sudo sh generate_defaults.sh
  ```

- Edit the `/etc/rocknsm/config.yml`
  ```
  sudo vi /etc/rocknsm/config.yml
  ```
> NOTE: The config file and deploy playbook at their current state is mean to automate the build of everything on a single machine and generic hardware. some "wrench turning" in the background will have to be done so that the cmat kit will deploy correctly. At this point the playbooks will handle most of the rock specific config and we will have to take care of the elastic parts

- Change the `/etc/rocknsm/config.yml` config to the following:

___

```yml
---
# These are all the current variables that could affect
# the configuration of ROCKNSM. Take care when modifying
# these. The defaults should be used unless you really
# know what you are doing!

# interfaces that should be configured for sensor applications
rock_monifs:
    - em1

# Secifies the hostname of the sensor
rock_hostname: sensor
# the FQDN
rock_fqdn: sensor.[STATE].cmat.lan
# the number of CPUs that bro will use
bro_cpu: 15
# name of elasticsearch cluster
es_cluster_name: rocknsm
# name of node in elasticsearch cluster
es_node_name: simplerockbuild
# how much memory to use for elasticsearch
es_mem: 31

########## Offline/Enterprise Network Options ##############

# configure if this system may reach out to the internet
# (configured repos below) during configuration
rock_online_install: False
# (online) enable RockNSM testing repos
rock_enable_testing: False
# (online) the URL for the EPEL repo mirror
epel_baseurl: http://download.fedoraproject.org/pub/epel/$releasever/$basearch/
# (online) the URL for the EPEL GPG key
epel_gpgurl: https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
# (online) the URL for the elastic repo mirror
elastic_baseurl: https://artifacts.elastic.co/packages/6.x/yum
# (online) the URL for the elastic GPG key
elastic_gpgurl: https://artifacts.elastic.co/GPG-KEY-elasticsearch
# (online) the URL for the rocknsm repo mirror
rocknsm_baseurl: https://packagecloud.io/rocknsm/2_2/el/7/$basearch
# (online) the URL for the rocknsm GPG key
rocknsm_gpgurl: https://packagecloud.io/rocknsm/2_2/gpgkey

#
rock_disable_offline_repo: True
# (offline) the filesytem path for a local repo if doing an "offline" install
rocknsm_local_baseurl: http://nuc.[STATE].cmat.lan/
# (offline) disable the gpgcheck features for local repos, contingent on a kickstart test checking for /srv/rocknsm/repodata/repomd.xml.asc
rock_offline_gpgcheck: 0

# the git repo from which to checkout rocknsm customization scripts for bro
bro_rockscripts_repo: http://nuc.[STATE].cmat.lan:4000/administrator/rock-scripts.git

#### Retention Configuration ####
elastic_close_interval: 15
elastic_delete_interval: 60
# Kafka retention is in Hour
kafka_retention: 168
# Log Retemtion in Days
bro_log_retention: 0
bro_stats_retention: 0
suricata_retention: 3
fsf_retention: 3

### Advanced Feature Selection ######
# Don't flip these unless you know what you're doing
with_stenographer: True
with_docket: False
with_bro: True
with_suricata: True
with_snort: False
with_suricata_update: True
with_logstash: False
with_elasticsearch: False
with_kibana: False
with_zookeeper: True
with_kafka: True
with_lighttpd: False
with_fsf: True

# Specify if a service is enabled on startup
enable_stenographer: True
enable_docket: False
enable_bro: True
enable_suricata: True
enable_snort: False
enable_suricata_update: True
enable_logstash: False
enable_elasticsearch: False
enable_kibana: False
enable_zookeeper: True
enable_kafka: True
enable_lighttpd: False
enable_fsf: True
```
___

-  Create the following directory
```
sudo mkdir -p /srv/rocknsm/support
```

- `wget` the following files from the nuc to aid in the deployment of ROCK

  - cd to the user's /home directory
    ```
    cd    
    ```

  - Grab the rock scripts
    ```
    sudo wget http://10.[state].10.19:4000/administrator/rock-scripts/archive/master.tar.gz
    ```

  - Rename the file.
    ```
    sudo mv master.tar.gz rock-scripts_master.tar.gz
    ```

  - Grab the rock dashboards
    ```
    sudo wget http://10.[state].10.19:4000/administrator/rock-dashboards/archive/master.tar.gz
    ```

  - Rename the file
    ```
    sudo mv master.tar.gz rock-dashboards_master.tar.gz
    ```

- Copy them to the need directory

  ```
  cd
  ```

  ```
  sudo cp ~/rock-dashboards_master.tar.gz /srv/rocknsm/support/rock-dashboards_master.tar.gz
  ```
  ```
  sudo cp ~/rock-scripts_master.tar.gz /srv/rocknsm/support/rock-scripts_master.tar.gz
  ```

- Comment the entire `setup yum repos` section out of the `/opt/rocknsm/rock/playbooks/roles/sensor-common/tasks/configure.yml` playbook in order to deploy rock correctly. We have our own. to block comment out use the following method
  - Crtl-v

  - Make your Selection

  - Type `:s/^/#/`

- With the current setup, the Ansible script doesn't play nicely with the shell script wrapper. So we will deploy the ansible script directly.

- Navigate to the /opt/rocknsm/rock/playbooks`
  ```
  cd /opt/rocknsm/rock/playbooks
  ```

- And then deploy
  ```
  sudo ansible-playbook -K deploy-rock.yml
  ```
  It should complete with **no** errors

- The following files need to be edited in `vi` they can be copy and pasted. Just make sure you replace [state] with your state.

___

##### /etc/kafka/server.properties


```yml
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# see kafka.server.KafkaConfig for additional details and defaults

############################# Server Basics #############################

# The id of the broker. This must be set to a unique integer for each broker.
broker.id=0

############################# Socket Server Settings #############################

# The address the socket server listens on. It will get the value returned from
# java.net.InetAddress.getCanonicalHostName() if not configured.
#   FORMAT:
#     listeners = listener_name://host_name:port
#   EXAMPLE:
#     listeners = PLAINTEXT://your.host.name:9092
listeners=PLAINTEXT://sensor.[STATE].cmat.lan:9092

# Hostname and port the broker will advertise to producers and consumers. If not set,
# it uses the value for "listeners" if configured.  Otherwise, it will use the value
# returned from java.net.InetAddress.getCanonicalHostName().
advertised.listeners=PLAINTEXT://sensor.[STATE].cmat.lan:9092

# Maps listener names to security protocols, the default is for them to be the same. See the config documentation for more details
#listener.security.protocol.map=PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_SSL:SASL_SSL

# The number of threads that the server uses for receiving requests from the network and sending responses to the network
num.network.threads=3

# The number of threads that the server uses for processing requests, which may include disk I/O
num.io.threads=8

# The send buffer (SO_SNDBUF) used by the socket server
socket.send.buffer.bytes=102400

# The receive buffer (SO_RCVBUF) used by the socket server
socket.receive.buffer.bytes=102400

# The maximum size of a request that the socket server will accept (protection against OOM)
socket.request.max.bytes=104857600


############################# Log Basics #############################

# A comma seperated list of directories under which to store log files
log.dirs=/data/kafka

# The default number of log partitions per topic. More partitions allow greater
# parallelism for consumption, but this will also result in more files across
# the brokers.
num.partitions=1

# The number of threads per data directory to be used for log recovery at startup and flushing at shutdown.
# This value is recommended to be increased for installations with data dirs located in RAID array.
num.recovery.threads.per.data.dir=1

############################# Internal Topic Settings  #############################
# The replication factor for the group metadata internal topics "__consumer_offsets" and "__transaction_state"
# For anything other than development testing, a value greater than 1 is recommended for to ensure availability such as 3.
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1

############################# Log Flush Policy #############################

# Messages are immediately written to the filesystem but by default we only fsync() to sync
# the OS cache lazily. The following configurations control the flush of data to disk.
# There are a few important trade-offs here:
#    - Durability: Unflushed data may be lost if you are not using replication.
#    - Latency: Very large flush intervals may lead to latency spikes when the flush does occur as there will be a lot of data to flush.
#    - Throughput: The flush is generally the most expensive operation, and a small flush interval may lead to exceessive seeks.
# The settings below allow one to configure the flush policy to flush data after a period of time or
# every N messages (or both). This can be done globally and overridden on a per-topic basis.

# The number of messages to accept before forcing a flush of data to disk
#log.flush.interval.messages=10000

# The maximum amount of time a message can sit in a log before we force a flush
#log.flush.interval.ms=1000

############################# Log Retention Policy #############################

# The following configurations control the disposal of log segments. The policy can
# be set to delete segments after a period of time, or after a given size has accumulated.
# A segment will be deleted whenever *either* of these criteria are met. Deletion always happens
# from the end of the log.

# The minimum age of a log file to be eligible for deletion due to age
log.retention.hours=168

# A size-based retention policy for logs. Segments are pruned from the log unless the remaining
# segments drop below log.retention.bytes. Functions independently of log.retention.hours.
#log.retention.bytes=1073741824

# The maximum size of a log segment file. When this size is reached a new log segment will be created.
log.segment.bytes=1073741824

# The interval at which log segments are checked to see if they can be deleted according
# to the retention policies
log.retention.check.interval.ms=300000

############################# Zookeeper #############################

# Zookeeper connection string (see zookeeper docs for details).
# This is a comma separated host:port pairs, each corresponding to a zk
# server. e.g. "127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002".
# You can also append an optional chroot string to the urls to specify the
# root directory for all kafka znodes.
zookeeper.connect=localhost:2181

# Timeout in ms for connecting to zookeeper
zookeeper.connection.timeout.ms=6000


############################# Group Coordinator Settings #############################

# The following configuration specifies the time, in milliseconds, that the GroupCoordinator will delay the initial consumer rebalance.
# The rebalance will be further delayed by the value of group.initial.rebalance.delay.ms as new members join the group, up to a maximum of max.poll.interval.ms.
# The default value for this is 3 seconds.
# We override this to 0 here as it makes for a better out-of-the-box experience for development and testing.
# However, in production environments the default value of 3 seconds is more suitable as this will help to avoid unnecessary, and potentially expensive, rebalances during application startup.
group.initial.rebalance.delay.ms=0

```

___

##### /usr/share/bro/site/scripts/rock/plugins/kafka.bro
```yml

#Copyright (C) 2016-2018 RockNSM
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
module Kafka;

redef Kafka::kafka_conf = table(
   ["metadata.broker.list"] = "10.[state].10.21:9092",
   ["client.id"] = "bro"
);

redef Kafka::topic_name = "bro-raw";
redef Kafka::json_timestamps = JSON::TS_ISO8601;
redef Kafka::tag_json = F;

# Enable bro logging to kafka for all logs
event bro_init() &priority=-5
{
   for (stream_id in Log::active_streams)
   {
       if (|Kafka::logs_to_send| == 0 || stream_id in Kafka::logs_to_send)
       {
           local filter: Log::Filter = [
               $name = fmt("kafka-%s", stream_id),
               $writer = Log::WRITER_KAFKAWRITER,
               $config = table(["stream_id"] = fmt("%s", stream_id))
           ];

           Log::add_filter(stream_id, filter);
       }
   }
}

```
- Change the suricata threads per interface so suricata doesnt compete with bro for threads
```
%YAML 1.1
---
default-rule-path: "/var/lib/suricata/rules"
rule-files:
  - suricata.rules

af-packet:
  - interface: em4
    threads: 4   <--------
    cluster-id: 99
    cluster-type: cluster_flow
    defrag: yes
    use-mmap: yes
    mmap-locked: yes
    #rollover: yes
    tpacket-v3: yes
    use-emergency-flush: yes
  - interface: em3
    threads: 4 <---------
    cluster-id: 98
    cluster-type: cluster_flow
    defrag: yes
    use-mmap: yes
    mmap-locked: yes
    #rollover: yes
    tpacket-v3: yes
    use-emergency-flush: yes
default-log-dir: /data/suricata


```

- Open the following ports on the firewall for the sensor

  - 9092 TCP - Kafka

  ```
  sudo firewall-cmd --add-port=9092/tcp --permanent
  ```
  Reload the firewall config

  ```
  sudo firewall-cmd --reload
  ```
- Restart Rock with `rock_stop` and `rock_start`

Move onto [Rock NSM Data Node](rocknsm-datanode.md)
