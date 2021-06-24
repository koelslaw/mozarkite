# RockNSM Data Node
This will cover the deployment of the RockNSM data node elements.
## Prereqs
- ESXi installed
- logged in `ssh` or vm console in ESXi
- DNS Setup
## Install OS

### Preinstall
When you boot the installer, called Anaconda. Before it boots, press <TAB> and append the following, which disables physical NIC naming and sets the screen resolution that is better for VMware.

  ```
  net.ifnames=0 vga=791
  ```

Install OS in accordance with [RHEL](../rhel/README.md)
Documentation

### Install Data Node Elements


There are 2 type of Elastic Nodes. There are 3 nodes total. two of the node will only have elasticsearch and logstash on them (EL). The third will have elasticsearch, logstash, and kibana (ELK).

___

#### "ELK" Node
- Perform system update and enable daily updates
  ```
  sudo yum update -y
  sudo yum install -y yum-cron
  sudo systemctl enable yum-cron
  sudo systemctl start yum-cron
  sudo yum install wget
  ```

##### Preparation for Rock Deployment
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
  mkdir /opt/rocknsm/
  ```

- Navigate there so we can clone the Rock NSM repo there
  ```
  cd /opt/rocknsm/  
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
  sudo vi /etc/rocknsm.config.yml
  ```

> NOTE: The config file and deploy playbook at thier current state is mean tto autmate the build of everything on a single machine and generic hardware. some "wrench turning" in the background will have to be done so that the cmat kit will deploy correctly. At this point the playbooks will handle most of the rock specific config and we will have to tke care of the elastic parts

- Change the config to the following:
  Replace the `[#]` with the number of the cluster. In this case of the ELK cluster it will be `1`.

  ```yml

  # These are all the current variables that could affect
  # the configuration of ROCKNSM. Take care when modifying
  # these. The defaults should be used unless you really
  # know what you are doing!

  # interfaces that should be configured for sensor applications
  rock_monifs:

  # Secifies the hostname of the sensor
  rock_hostname: es[#]
  # the FQDN
  rock_fqdn: [NAME OF THIS ELASTICSEARCH NODE].[STATE].cmat.lan
  # the number of CPUs that bro will use
  bro_cpu: 6
  # name of elasticsearch cluster
  es_cluster_name: rocknsm [NAME OF ENTIRE CLUSTER]
  # name of node in elasticsearch cluster
  es_node_name: es[#] [NAME OF THIS ELASTICSEARCH NODE]
  # how much memory to use for elasticsearch
  es_mem: 6

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
  bro_rockscripts_repo: https://nuc.[STATE].cmat.lan:4000/administrator/rock-scripts.git

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
  with_stenographer: False
  with_docket: True
  with_bro: False
  with_suricata: False
  with_snort: False
  with_suricata_update: False
  with_logstash: True
  with_elasticsearch: True
  with_kibana: True
  with_zookeeper: False
  with_kafka: False
  with_lighttpd: True
  with_fsf: False

  # Specify if a service is enabled on startup
  enable_stenographer: False
  enable_docket: True
  enable_bro: False
  enable_suricata: False
  enable_snort: False
  enable_suricata_update: False
  enable_logstash: True
  enable_elasticsearch: True
  enable_kibana: True
  enable_zookeeper: False
  enable_kafka: False
  enable_lighttpd: True
  enable_fsf: False
  ```

-  Create the following directory
  ```
  sudo mkdir -p /srv/rocknsm/support
  ```

- `wget` the following files from the nuc to aid in the deployment of ROCK

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

- With the current setup, the ansible script doesn't play nicely with the shell script wrapper. So we will deploy the ansible script directly.

- Navigate to the /opt/rocknsm/rock/playbooks

  ```
  cd /opt/rocknsm/rock/playbooks
  ```

- And then deploy

  ```
  sudo ansible-playbook -K deploy-rock.yml
  ```
  It should complete with **no** errors

- Copy the following files for logstash

  ```
  sudo -cp /opt/rocknsm/rock/plabooks/files/logstash-500-* /etc/logstash/conf.d/.
  ```

- The following files need to be edited in `vi` they can be copy and pasted. Just make sure you replace [state] with your state. Also replace `[#]` with the appropriate number for the elastic cluster `1,2, or 3`

---

##### logstash-100-input.conf
```
input {
    kafka {
    topics => ["bro-raw"]
    add_field => { "[@metadata][stage]" => "broraw_kafka" }
    # Set this to one per kafka partition to scale up
    #consumer_threads => 4
    group_id => "bro_logstash"
    bootstrap_servers => "sensor.[state].cmat.lan:9092"
    codec => json
    auto_offset_reset => "earliest"
    }
    file {
        codec => "json"
        path => "/data/suricata/eve.json"
        add_field => { "[@metadata][stage]" => "suricata_eve" }
    }
    file {
        codec => "json"
        path => "/data/fsf/rockout.log"
        add_field => { "[@metadata][stage]" => "fsf" }
    }
}
```
---

##### logstash-100-input-kafka-bro.conf
```
input {
 kafka {
   topics => ["bro-raw"]
   add_field => { "[@metadata][stage]" => "broraw_kafka" }
   # Set this to one per kafka partition to scale up
   #consumer_threads => 4
   group_id => "bro_logstash"
   bootstrap_servers => "sensor.[state].cmat.lan:9092"
   codec => json
   auto_offset_reset => "earliest"
 }
}
```
---

##### logstash-100-input-kafka-fsf.conf
```
input {
 kafka {
   topics => ["fsf-raw"]
   add_field => { "[@metadata][stage]" => "fsfraw_kafka" }
   # Set this to one per kafka partition to scale up
   #consumer_threads => 4
   group_id => "fsf_logstash"
   bootstrap_servers => "sensor.[state].cmat.lan:9092"
   codec => json
   auto_offset_reset => "earliest"
 }
}
```
---

##### logstash-100-input-kafka-suricata.conf
```
input {
 kafka {
   topics => ["suricata-raw"]
   add_field => { "[@metadata][stage]" => "suricataraw_kafka" }
   # Set this to one per kafka partition to scale up
   #consumer_threads => 4
   group_id => "suricata_logstash"
   bootstrap_servers => "sensor.[state].cmat.lan:9092"
   codec => json
   auto_offset_reset => "earliest"
 }
}
```
---

##### logstash-500-kafka-bro.conf
```
filter {
  if [@metadata][stage] == "broraw_kafka" {
    # Tags will determine if there is some sort of parse failure
    if ![tags] {
      # Set the timestamp
      date { match => [ "ts", "ISO8601" ] }

      # move metadata to new field
      mutate {
        rename => {
          "@stream" => "[@meta][stream]"
          "@system" => "[@meta][system]"
          "@proc"   => "[@meta][proc]"
        }
      }

      # Rename ID field from file analyzer logs
      if [@meta][stream] in ["pe", "x509", "files"] {
      mutate { rename => { "id" => "fuid" } }
      mutate {
      add_field => { "[@meta][event_type]" => "file" }
      add_field => { "[@meta][id]" => "%{fuid}" }
      }
      } else if [@meta][stream] in ["intel", "notice", "notice_alarm", "signatures", "traceroute"] {
        mutate { add_field => { "[@meta][event_type]" => "detection" } }
      } else if [@meta][stream] in [ "capture_loss", "cluster", "communication", "loaded_scripts", "packet_filter", "prof", "reporter", "stats", "stderr", "stdout" ] {
        mutate { add_field => { "[@meta][event_type]" => "diagnostic" } }
      } else if [@meta][stream] in ["netcontrol", "netcontrol_drop", "netcontrol_shunt", "netcontrol_catch_release", "openflow"] {
        mutate { add_field => { "[@meta][event_type]" => "netcontrol" } }
      } else if [@meta][stream] in ["known_certs", "known_devices", "known_hosts", "known_modbus", "known_services", "software"] {
        mutate { add_field => { "[@meta][event_type]" => "observations" } }
      } else if [@meta][stream] in ["barnyard2", "dpd", "unified2", "weird"] {
        mutate { add_field => { "[@meta][event_type]" => "miscellaneous" } }
      } else {

        # Network type
        mutate {
          convert => {
          "id_orig_p" => "integer"
          "id_resp_p" => "integer"
          }
          add_field => {
            "[@meta][event_type]" => "network"
            "[@meta][id]" => "%{uid}"
            "[@meta][orig_host]" => "%{id_orig_h}"
            "[@meta][orig_port]" => "%{id_orig_p}"
            "[@meta][resp_host]" => "%{id_resp_h}"
            "[@meta][resp_port]" => "%{id_resp_p}"
          }
        }
        geoip {
          source => "id_orig_h"
          target => "[@meta][geoip_orig]"
        }
        geoip {
          source => "id_resp_h"
          target => "[@meta][geoip_resp]"
        }
      }

      # Tie related records
      mutate { add_field => { "[@meta][related_ids]" => [] }}
      if [uid] {
        mutate { merge => {"[@meta][related_ids]" => "uid" }}
      }
      if [fuid] {
        mutate { merge => {"[@meta][related_ids]" => "fuid" }}
      }
      if [related_fuids] {
        mutate { merge => { "[@meta][related_ids]" => "related_fuids" }}
      }
      if [orig_fuids] {
        mutate { merge => { "[@meta][related_ids]" => "orig_fuids" }}
      }
      if [resp_fuids] {
        mutate { merge => { "[@meta][related_ids]" => "resp_fuids" }}
      }
      if [conn_uids] {
        mutate { merge => { "[@meta][related_ids]" => "conn_uids" }}
      }
      if [cert_chain_fuids] {
        mutate { merge => { "[@meta][related_ids]" => "cert_chain_fuids" }}
      }

      # Nest the entire document
      ruby {
        code => "
          require 'logstash/event'

          logtype = event.get('[@meta][stream]')
          ev_hash = event.to_hash
          meta_hash = ev_hash['@meta']
          timestamp = ev_hash['@timestamp']

          # Cleanup duplicate info
          #meta_hash.delete('stream')
          ev_hash.delete('@meta')
          ev_hash.delete('@timestamp')
          ev_hash.delete('tags')

          result = {
          logtype => ev_hash,
          '@meta' => meta_hash,
          '@timestamp' => timestamp
          }
          event.initialize( result )
        "
      }
      mutate { add_field => {"[@metadata][stage]" => "broraw_kafka" } }
    }
    else {
      mutate { add_field => { "[@metadata][stage]" => "_parsefailure" } }
    }
  }
}
```
---

##### logstash-500-suricata-es.conf
```
filter {
    if [@metadata][stage] == "suricata_eve" {
    # Tags will determine if there is some sort of parse failure
        if ![tags] {
             mutate { remove_field => ["path"] }
        }
        else {
            mutate { add_field => { "[@metadata][stage]" => "_parsefailure" } }
        }
    }
}
```
---
##### logstash-999-output.conf
```
output {
    if [@metadata][stage] == "broraw_kafka" {
        kafka {
        codec => json
        topic_id => "bro-clean"
        bootstrap_servers => "sensor.[state].cmat.lan:9092"
        }

        elasticsearch {
            hosts => ["127.0.0.1"]
            index => "bro-%{+YYYY.MM.dd}"
            document_type => "%{[@meta][event_type]}"
            manage_template => false
        }
    }
    else if [@metadata][stage] == "suricata_eve" {
        #stdout { codec => rubydebug }
        elasticsearch {
            hosts => ["127.0.0.1"]
            index => "suricata-%{+YYYY.MM.dd}"
            document_type => "%{event_type}"
        }
    }
    else if [@metadata][stage] == "fsf" {
        #stdout { codec => rubydebug }
        elasticsearch {
            hosts => ["127.0.0.1"]
            index => "fsf-%{+YYYY.MM.dd}"
            document_type => "fsf"
        }
    }
    else if [@metadata][stage] == "_parsefailure" {
        elasticsearch {
            hosts => ["127.0.0.1"]
            index => "parse-failures-%{+YYYY.MM.dd}"
            document_type => "_parsefailure"
        }
    }
}
```
---

###### logstash-999-output-es-bro.conf
```
output {
   if [@metadata][stage] == "broraw_kafka" {
#        kafka {
#          codec => json
#          topic_id => "bro-%{[@meta][event_type]}"
#          bootstrap_servers => "127.0.0.1:9092"
#        }

       elasticsearch {
           hosts => ["es1.[state].cmat.lan","es2.[state].cmat.lan","es3.[state].cmat.lan"]
           index => "bro-%{[@meta][event_type]}-%{+YYYY.MM.dd}"
           template => "/opt/rocknsm/rock/playbooks/files/es-bro-mappings.json"
           document_type => "_doc"
       }
   }
}
```
---

##### logstash-999-output-es-fsf.conf
```
output {
 if [@metadata][stage] == "fsfraw_kafka" {
#    kafka {
#     codec => json
#     topic_id => "fsf-clean"
#     bootstrap_servers => "127.0.0.1:9092"
#    }

   elasticsearch {
     hosts => ["es1.[state].cmat.lan","es2.[state].cmat.lan","es3.[state].cmat.lan"]
     index => "fsf-%{+YYYY.MM.dd}"
     manage_template => false
     document_type => "_doc"
   }
 }
}
```
---

##### logstash-999-output-es-suricata.conf
```
output {
 if [@metadata][stage] == "suricataraw_kafka" {
#    kafka {
#     codec => json
#     topic_id => "suricata-clean"
#     bootstrap_servers => "127.0.0.1:9092"
#    }

   elasticsearch {
     hosts => ["es1.[state].cmat.lan","es2.[state].cmat.lan","es3.[state].cmat.lan"]
     index => "suricata-%{+YYYY.MM.dd}"
     manage_template => false
     document_type => "_doc"
   }
 }
}
```
---

##### /etc/elasticsearch/elasticsearch.yml

```yml

# ======================== Elasticsearch Configuration =========================
#
# NOTE: Elasticsearch comes with reasonable defaults for most settings.
#       Before you set out to tweak and tune the configuration, make sure you
#       understand what are you trying to accomplish and the consequences.
#
# The primary way of configuring a node is via this file. This template lists
# the most important settings you may want to configure for a production cluster.
#
# Please consult the documentation for further information on configuration options:
# https://www.elastic.co/guide/en/elasticsearch/reference/index.html
#
# ---------------------------------- Cluster -----------------------------------
#
# Use a descriptive name for your cluster:
#
cluster.name: rocknsm
#
# ------------------------------------ Node ------------------------------------
#
# Use a descriptive name for the node:
#
node.name: es[#]
#
# Add custom attributes to the node:
#
#node.attr.rack: r1
#
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data (separate multiple locations by comma):
#
path.data: /data/elasticsearch
#
# Path to log files:
#
path.logs: /var/log/elasticsearch
#
# ----------------------------------- Memory -----------------------------------
#
# Lock the memory on startup:
#
bootstrap.memory_lock: true
#
# Make sure that the heap size is set to about half the memory available
# on the system and that the owner of the process is allowed to use this
# limit.
#
# Elasticsearch performs poorly when the system is swapping the memory.
#
# ---------------------------------- Network -----------------------------------
#
# Set the bind address to a specific IP (IPv4 or IPv6):
#
network.host: 0.0.0.0
#
# Set a custom port for HTTP:
#
#http.port: 9200
#
# For more information, consult the network module documentation.
#
# --------------------------------- Discovery ----------------------------------
#
# Pass an initial list of hosts to perform discovery when new node is started:
# The default list of hosts is ["127.0.0.1", "[::1]"]
#
discovery.zen.ping.unicast.hosts: ["es[#].[STATE].cmat.lan","es[#].[STATE].cmat.lan", "es[#].[STATE].cmat.lan"]
#
# Prevent the "split brain" by configuring the majority of nodes (total number of master-eligible nodes / 2 + 1):
#
#discovery.zen.minimum_master_nodes:
#
# For more information, consult the zen discovery module documentation.
#
# ---------------------------------- Gateway -----------------------------------
#
# Block initial recovery after a full cluster restart until N nodes are started:
#
#gateway.recover_after_nodes: 3
#
# For more information, consult the gateway module documentation.
#
# ---------------------------------- Various -----------------------------------
#
# Require explicit names when deleting indices:
#
#action.destructive_requires_name: true
```

___

##### /etc/kibana/kibana.yml

```yml

# Kibana is served by a back end server. This setting specifies the port to use.
#server.port: 5601

# Specifies the address to which the Kibana server will bind. IP addresses and host names are both valid values.
# The default is 'localhost', which usually means remote machines will not be able to connect.
# To allow connections from remote users, set this parameter to a non-loopback address.
server.host: "0.0.0.0"

# Enables you to specify a path to mount Kibana at if you are running behind a proxy.
# Use the `server.rewriteBasePath` setting to tell Kibana if it should remove the basePath
# from requests it receives, and to prevent a deprecation warning at startup.
# This setting cannot end in a slash.
#server.basePath: ""

# Specifies whether Kibana should rewrite requests that are prefixed with
# `server.basePath` or require that they are rewritten by your reverse proxy.
# This setting was effectively always `false` before Kibana 6.3 and will
# default to `true` starting in Kibana 7.0.
#server.rewriteBasePath: false

# The maximum payload size in bytes for incoming server requests.
#server.maxPayloadBytes: 1048576

# The Kibana server's name.  This is used for display purposes.
#server.name: "10.[state].10.27"

# The URL of the Elasticsearch instance to use for all your queries.
elasticsearch.url: "http://0.0.0.0:9200"

# When this setting's value is true Kibana uses the hostname specified in the server.host
# setting. When the value of this setting is false, Kibana uses the hostname of the host
# that connects to this Kibana instance.
#elasticsearch.preserveHost: true

# Kibana uses an index in Elasticsearch to store saved searches, visualizations and
# dashboards. Kibana creates a new index if the index doesn't already exist.
#kibana.index: ".kibana"

# The default application to load.
#kibana.defaultAppId: "home"

# If your Elasticsearch is protected with basic authentication, these settings provide
# the username and password that the Kibana server uses to perform maintenance on the Kibana
# index at startup. Your Kibana users still need to authenticate with Elasticsearch, which
# is proxied through the Kibana server.
#elasticsearch.username: "user"
#elasticsearch.password: "pass"

# Enables SSL and paths to the PEM-format SSL certificate and SSL key files, respectively.
# These settings enable SSL for outgoing requests from the Kibana server to the browser.
#server.ssl.enabled: false
#server.ssl.certificate: /path/to/your/server.crt
#server.ssl.key: /path/to/your/server.key

# Optional settings that provide the paths to the PEM-format SSL certificate and key files.
# These files validate that your Elasticsearch backend uses the same key files.
#elasticsearch.ssl.certificate: /path/to/your/client.crt
#elasticsearch.ssl.key: /path/to/your/client.key

# Optional setting that enables you to specify a path to the PEM file for the certificate
# authority for your Elasticsearch instance.
#elasticsearch.ssl.certificateAuthorities: [ "/path/to/your/CA.pem" ]

# To disregard the validity of SSL certificates, change this setting's value to 'none'.
#elasticsearch.ssl.verificationMode: full

# Time in milliseconds to wait for Elasticsearch to respond to pings. Defaults to the value of
# the elasticsearch.requestTimeout setting.
#elasticsearch.pingTimeout: 1500

# Time in milliseconds to wait for responses from the back end or Elasticsearch. This value
# must be a positive integer.
#elasticsearch.requestTimeout: 30000

# List of Kibana client-side headers to send to Elasticsearch. To send *no* client-side
# headers, set this value to [] (an empty list).
#elasticsearch.requestHeadersWhitelist: [ authorization ]

# Header names and values that are sent to Elasticsearch. Any custom headers cannot be overwritten
# by client-side headers, regardless of the elasticsearch.requestHeadersWhitelist configuration.
#elasticsearch.customHeaders: {}

# Time in milliseconds for Elasticsearch to wait for responses from shards. Set to 0 to disable.
#elasticsearch.shardTimeout: 30000

# Time in milliseconds to wait for Elasticsearch at Kibana startup before retrying.
#elasticsearch.startupTimeout: 5000

# Logs queries sent to Elasticsearch. Requires logging.verbose set to true.
#elasticsearch.logQueries: false

# Specifies the path where Kibana creates the process ID file.
#pid.file: /var/run/kibana.pid

# Enables you specify a file where Kibana stores log output.
#logging.dest: stdout

# Set the value of this setting to true to suppress all logging output.
#logging.silent: false

# Set the value of this setting to true to suppress all logging output other than error messages.
#logging.quiet: false

# Set the value of this setting to true to log all events, including system usage information
# and all requests.
#logging.verbose: false

# Set the interval in milliseconds to sample system and process performance
# metrics. Minimum is 100ms. Defaults to 5000.
#ops.interval: 5000

# Specifies locale to be used for all localizable strings, dates and number formats.
#i18n.locale: "en"
```

___

- Open the following ports on the firewall for the elastic machines

  - 9300 TCP - Node coordination (I am sure elastic has abetter name for this)
  - 9200 TCP - Elasticsearch
  - 5601 TCP - Only on the elasticsearch node that has kibana installed, Likely es1.[STATE].cmat.lan
  - 22 TCP - SSH Access


  ```
  sudo firewall-cmd --add-port=9300/tcp --permanent
  ```

- Reload the firewall config

  ```
  sudo firewall-cmd --reload
  ```

- Restart services with `rock_stop` and the `rock_start`

- Deploy more nodes as needed.

____________________________________________________________
____________________________________________________________

#### "EL" Node
- Perform system update and enable daily updates
```
sudo yum update -y
sudo yum install -y yum-cron
sudo systemctl enable yum-cron
sudo systemctl start yum-cron
sudo yum sintall wget
```

##### Preparation for Rock Deployment

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
  mkdir /opt/rocknsm/
  ```

- Navigate there so we can clone the Rock NSM repo there
  ```
  cd /opt/rocknsm/  
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
  cd /opt/rocknsm/bin
  ```

- Generate defaults for rock to deploy with
  ```
  sudo sh generate_defaults.sh
  ```

- Edit the `/etc/rocknsm/config.yml`
  ```
  sudo vi /etc/rocknsm.config.yml
  ```
> NOTE: The config file and deploy playbook at thier current state is mean tto autmate the build of everything on a single machine and generic hardware. some "wrench turning" in the background will have to be done so that the cmat kit will deploy correctly. At this point the playbooks will handle most of the rock specific config and we will have to tke care of the elastic parts

- Change the config to the following:
  Replace the `[#]` with the number of the cluster. In this case of the ELK cluster it will be `1`.

___

```yml
---
# These are all the current variables that could affect
# the configuration of ROCKNSM. Take care when modifying
# these. The defaults should be used unless you really
# know what you are doing!

# interfaces that should be configured for sensor applications
rock_monifs:

# Secifies the hostname of the sensor
rock_hostname: es[#]
# the FQDN
rock_fqdn: [NAME OF THIS ELASTICSEARCH NODE].[STATE].cmat.lan
# the number of CPUs that bro will use
bro_cpu: 6
# name of elasticsearch cluster
es_cluster_name: rocknsm [NAME OF ENTIRE CLUSTER]
# name of node in elasticsearch cluster
es_node_name: es[#] [NAME OF THIS ELASTICSEARCH NODE]
# how much memory to use for elasticsearch
es_mem: 6

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
bro_rockscripts_repo: https://nuc.[STATE].cmat.lan:4000/administrator/rock-scripts.git

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
with_stenographer: False
with_docket: True
with_bro: False
with_suricata: False
with_snort: False
with_suricata_update: False
with_logstash: True
with_elasticsearch: True
with_kibana: False
with_zookeeper: False
with_kafka: False
with_lighttpd: True
with_fsf: False

# Specify if a service is enabled on startup
enable_stenographer: False
enable_docket: True
enable_bro: False
enable_suricata: False
enable_snort: False
enable_suricata_update: False
enable_logstash: True
enable_elasticsearch: True
enable_kibana: False
enable_zookeeper: False
enable_kafka: False
enable_lighttpd: True
enable_fsf: False

```

___

-  Create the following directory
```
sudo mkdir -p /srv/rocknsm/support
```

- `wget` the following files from the nuc to aid in the deployment of ROCK

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

- Navigate to the /opt/rocknsm/rock/playbooks

  ```
  cd opt/rocknsm/rock/playbooks
  ```

- And then deploy

  ```
  sudo ansible-playbook -K deploy-rock.yml
  ```
  It should complete with **no** errors

- The following files need to be edited in `vi` they can be copy and pasted. Just make sure you replace [state] with your state.

___

##### /etc/logstash/conf.d/logstash-100-input-kafka-bro.conf

```
input {
 kafka {
   topics => ["bro-raw"]
   add_field => { "[@metadata][stage]" => "broraw_kafka" }
   # Set this to one per kafka partition to scale up
   #consumer_threads => 4
   group_id => "bro_logstash"
   bootstrap_servers => "sensor.[STATE].cmat.lan:9092"
   codec => json
   auto_offset_reset => "earliest"
 }
}
```

___

##### /etc/logstash/conf.d/logstash-100-input-kafka-fsf.conf

```
input {
 kafka {
   topics => ["fsf-raw"]
   add_field => { "[@metadata][stage]" => "fsfraw_kafka" }
   # Set this to one per kafka partition to scale up
   #consumer_threads => 4
   group_id => "fsf_logstash"
   bootstrap_servers => "sensor.[STATE].cmat.lan:9092"
   codec => json
   auto_offset_reset => "earliest"
 }
}
```
___

##### /etc/logstash/conf.d/logstash-100-input-kafka-suricata.conf

```
input {
 kafka {
   topics => ["suricata-raw"]
   add_field => { "[@metadata][stage]" => "suricataraw_kafka" }
   # Set this to one per kafka partition to scale up
   #consumer_threads => 4
   group_id => "suricata_logstash"
   bootstrap_servers => "sensor.[STATE].cmat.lan:9092"
   codec => json
   auto_offset_reset => "earliest"
 }
}
```

____

##### /etc/logstash/conf.d/logstash-999-output-es-bro.conf

```
output {
   if [@metadata][stage] == "broraw_kafka" {
#        kafka {
#          codec => json
#          topic_id => "bro-%{[@meta][event_type]}"
#          bootstrap_servers => "127.0.0.1:9092"
#        }

       elasticsearch {
           hosts => ["es[#].[STATE].cmat.lan","es[#].[STATE].cmat.lan","es[#].[STATE].cmat.lan"]
           index => "bro-%{[@meta][event_type]}-%{+YYYY.MM.dd}"
           template => "/opt/rocknsm/rock/playbooks/files/es-bro-mappings.json"
           document_type => "_doc"
       }
   }
}
```

___

#####/etc/logstash/conf.d/logstash-999-output-es-fsf.conf

```
output {
 if [@metadata][stage] == "fsfraw_kafka" {
#    kafka {
#     codec => json
#     topic_id => "fsf-clean"
#     bootstrap_servers => "127.0.0.1:9092"
#    }

   elasticsearch {
     hosts => ["es[#].[STATE].cmat.lan","es[#].[STATE].cmat.lan","es[#].[STATE].cmat.lan"]
     index => "fsf-%{+YYYY.MM.dd}"
     manage_template => false
     document_type => "_doc"
   }
 }
}
```

___

##### /etc/logstash/conf.d/logstash-999-output-es-suricata.conf

```
output {
 if [@metadata][stage] == "suricataraw_kafka" {
#    kafka {
#     codec => json
#     topic_id => "suricata-clean"
#     bootstrap_servers => "127.0.0.1:9092"
#    }

   elasticsearch {
     hosts => ["es[#].[STATE].cmat.lan","es[#].[STATE].cmat.lan","es[#].[STATE].cmat.lan"]
     index => "suricata-%{+YYYY.MM.dd}"
     manage_template => false
     document_type => "_doc"
   }
 }
}
```

___

##### /etc/elasticsearch/elasticsearch.yml

```yml

# ======================== Elasticsearch Configuration =========================
#
# NOTE: Elasticsearch comes with reasonable defaults for most settings.
#       Before you set out to tweak and tune the configuration, make sure you
#       understand what are you trying to accomplish and the consequences.
#
# The primary way of configuring a node is via this file. This template lists
# the most important settings you may want to configure for a production cluster.
#
# Please consult the documentation for further information on configuration options:
# https://www.elastic.co/guide/en/elasticsearch/reference/index.html
#
# ---------------------------------- Cluster -----------------------------------
#
# Use a descriptive name for your cluster:
#
cluster.name: es[#]
#
# ------------------------------------ Node ------------------------------------
#
# Use a descriptive name for the node:
#
node.name: es[#]
#
# Add custom attributes to the node:
#
#node.attr.rack: r1
#
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data (separate multiple locations by comma):
#
path.data: /data/elasticsearch
#
# Path to log files:
#
path.logs: /var/log/elasticsearch
#
# ----------------------------------- Memory -----------------------------------
#
# Lock the memory on startup:
#
bootstrap.memory_lock: true
#
# Make sure that the heap size is set to about half the memory available
# on the system and that the owner of the process is allowed to use this
# limit.
#
# Elasticsearch performs poorly when the system is swapping the memory.
#
# ---------------------------------- Network -----------------------------------
#
# Set the bind address to a specific IP (IPv4 or IPv6):
#
network.host: 0.0.0.0
#
# Set a custom port for HTTP:
#
#http.port: 9200
#
# For more information, consult the network module documentation.
#
# --------------------------------- Discovery ----------------------------------
#
# Pass an initial list of hosts to perform discovery when new node is started:
# The default list of hosts is ["127.0.0.1", "[::1]"]
#
discovery.zen.ping.unicast.hosts: ["es[#].[STATE].cmat.lan","es[#].[STATE].cmat.lan", "es[#].[STATE].cmat.lan"]
#
# Prevent the "split brain" by configuring the majority of nodes (total number of master-eligible nodes / 2 + 1):
#
#discovery.zen.minimum_master_nodes:
#
# For more information, consult the zen discovery module documentation.
#
# ---------------------------------- Gateway -----------------------------------
#
# Block initial recovery after a full cluster restart until N nodes are started:
#
#gateway.recover_after_nodes: 3
#
# For more information, consult the gateway module documentation.
#
# ---------------------------------- Various -----------------------------------
#
# Require explicit names when deleting indices:
#
#action.destructive_requires_name: true
```

___

##### /etc/kibana/kibana.yml

```yml

# Kibana is served by a back end server. This setting specifies the port to use.
#server.port: 5601

# Specifies the address to which the Kibana server will bind. IP addresses and host names are both valid values.
# The default is 'localhost', which usually means remote machines will not be able to connect.
# To allow connections from remote users, set this parameter to a non-loopback address.
server.host: "0.0.0.0"

# Enables you to specify a path to mount Kibana at if you are running behind a proxy.
# Use the `server.rewriteBasePath` setting to tell Kibana if it should remove the basePath
# from requests it receives, and to prevent a deprecation warning at startup.
# This setting cannot end in a slash.
#server.basePath: ""

# Specifies whether Kibana should rewrite requests that are prefixed with
# `server.basePath` or require that they are rewritten by your reverse proxy.
# This setting was effectively always `false` before Kibana 6.3 and will
# default to `true` starting in Kibana 7.0.
#server.rewriteBasePath: false

# The maximum payload size in bytes for incoming server requests.
#server.maxPayloadBytes: 1048576

# The Kibana server's name.  This is used for display purposes.
#server.name: "10.[state].10.27"

# The URL of the Elasticsearch instance to use for all your queries.
elasticsearch.url: "http://0.0.0.0:9200"

# When this setting's value is true Kibana uses the hostname specified in the server.host
# setting. When the value of this setting is false, Kibana uses the hostname of the host
# that connects to this Kibana instance.
#elasticsearch.preserveHost: true

# Kibana uses an index in Elasticsearch to store saved searches, visualizations and
# dashboards. Kibana creates a new index if the index doesn't already exist.
#kibana.index: ".kibana"

# The default application to load.
#kibana.defaultAppId: "home"

# If your Elasticsearch is protected with basic authentication, these settings provide
# the username and password that the Kibana server uses to perform maintenance on the Kibana
# index at startup. Your Kibana users still need to authenticate with Elasticsearch, which
# is proxied through the Kibana server.
#elasticsearch.username: "user"
#elasticsearch.password: "pass"

# Enables SSL and paths to the PEM-format SSL certificate and SSL key files, respectively.
# These settings enable SSL for outgoing requests from the Kibana server to the browser.
#server.ssl.enabled: false
#server.ssl.certificate: /path/to/your/server.crt
#server.ssl.key: /path/to/your/server.key

# Optional settings that provide the paths to the PEM-format SSL certificate and key files.
# These files validate that your Elasticsearch backend uses the same key files.
#elasticsearch.ssl.certificate: /path/to/your/client.crt
#elasticsearch.ssl.key: /path/to/your/client.key

# Optional setting that enables you to specify a path to the PEM file for the certificate
# authority for your Elasticsearch instance.
#elasticsearch.ssl.certificateAuthorities: [ "/path/to/your/CA.pem" ]

# To disregard the validity of SSL certificates, change this setting's value to 'none'.
#elasticsearch.ssl.verificationMode: full

# Time in milliseconds to wait for Elasticsearch to respond to pings. Defaults to the value of
# the elasticsearch.requestTimeout setting.
#elasticsearch.pingTimeout: 1500

# Time in milliseconds to wait for responses from the back end or Elasticsearch. This value
# must be a positive integer.
#elasticsearch.requestTimeout: 30000

# List of Kibana client-side headers to send to Elasticsearch. To send *no* client-side
# headers, set this value to [] (an empty list).
#elasticsearch.requestHeadersWhitelist: [ authorization ]

# Header names and values that are sent to Elasticsearch. Any custom headers cannot be overwritten
# by client-side headers, regardless of the elasticsearch.requestHeadersWhitelist configuration.
#elasticsearch.customHeaders: {}

# Time in milliseconds for Elasticsearch to wait for responses from shards. Set to 0 to disable.
#elasticsearch.shardTimeout: 30000

# Time in milliseconds to wait for Elasticsearch at Kibana startup before retrying.
#elasticsearch.startupTimeout: 5000

# Logs queries sent to Elasticsearch. Requires logging.verbose set to true.
#elasticsearch.logQueries: false

# Specifies the path where Kibana creates the process ID file.
#pid.file: /var/run/kibana.pid

# Enables you specify a file where Kibana stores log output.
#logging.dest: stdout

# Set the value of this setting to true to suppress all logging output.
#logging.silent: false

# Set the value of this setting to true to suppress all logging output other than error messages.
#logging.quiet: false

# Set the value of this setting to true to log all events, including system usage information
# and all requests.
#logging.verbose: false

# Set the interval in milliseconds to sample system and process performance
# metrics. Minimum is 100ms. Defaults to 5000.
#ops.interval: 5000

# Specifies locale to be used for all localizable strings, dates and number formats.
#i18n.locale: "en"
```

___

- Open the following ports on the firewall for the elastic machines

  - 9300 TCP - Node coordination (I am sure elastic has abetter name for this)
  - 9200 TCP - Elasticsearch
  - 5601 TCP - Only on the elasticsearch node that has kibana installed, Likely es1.[STATE].cmat.lan
  - 22 TCP - SSH Access


  ```
  sudo firewall-cmd --add-port=9300/tcp --permanent
  ```
  Reload the firewall config

  ```
  sudo firewall-cmd --reload
  ```

- Restart the stack using `rock_stop` and `rock_start`

Move onto [USAGE](rocknsm-usage.md)
