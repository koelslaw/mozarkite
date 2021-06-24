# Node Configuration

- The following files need to be edited in `vi`. They can be copy and pasted. Just make sure you replace [state] with your state. Also, replace `[#]` with the appropriate number for the elastic cluster `1, 2, or 3`.

---

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

---

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

___

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

##### /etc/logstash/conf.d/logstash-999-output-es-fsf.conf

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
