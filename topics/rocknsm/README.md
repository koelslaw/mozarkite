# RockNSM

RockNSM CMAT Kit has 2 Servers, the data node (top half or Server 2) and the sensor (bottom half or Server 1). However we don't have to limit ourselves to just those 2 servers. Starting in 2.3.0 there is better support for multi node deployments. These allow use to deploy them faster and hopefully with fewer mistakes. To keep everything as close to the sensor as required we will execute the deployment from the sensor. That way the new `rock start` and `rock stop` scripts can do their job.

### Data Node
The data node has the indexing/storage and visualization elements:
- Elasticsearch x3 but can be up to 10 if the ram is available
  - if there is more RAM available the you can setup elastic node setup as 3 master and 1 kibana only node and then the rest are data and ingest nodes.
- Elastic Kibana (w/ RockNSM's Docket)

#### Create the Sensor Data Tier Virtual Machine
> Note: You're going to create three of these named "data-tier-[1, 2, and 3]"
- Log into Esxi
- Select `Create/Register VM`  
  - Name: `data-tier-[#]`  
  - Compatibility: Leave default  
  - Guest OS Family: `Linux`  
  - Guest OS Version: `Red Hat Enterprise Linux 7 (64-bit)`  
- Select your storage  
- Customize the VM  
  - CPU: `12`  
  - Memory: `12 GB` , Reserved   
  - Hard disk 1: `1 TB`  
  - SCSI Controller 0: Leave default  
  - SATA Controller 0: Leave default  
  - USB controller 1:  Leave default  
  - Network Adapter: `Passive`, ensure that `Connect` is enabled  
  - CD/DVD Drive 1: `Datastore ISO file`, select the RHEL ISO you uploaded above, ensure that `Connect` is enabled  
  - Video Card:  Leave default  
- Review your settings  
- Click Finish  

### Sensor
The sensor has the network security monitoring and data shipping elements:
- Bro protocol analyzer
- Suricata IDS
- Emerson fsf
- Google Stenographer
- Apache Kafka
- Elastic Logstash
- Elastic Beats

## Rock Versions
- [RockNSM](./topics/rocknsm/README.md)
  - [Hardware Requirements](./topics/rocknsm-requirements.md)
  - [Rock NSM 2.2.x](./topics/rocknsm2-2-0/README.md)
  - [Rock NSM 2.3.x](./topics/rocknsm2-3-0/README.md)
  - Rock NSM 2.4.x
    - [Rock NSM 2.4.x (CENTOS)](./topics/rocknsm2-4-0/CENTOS/README.md)
    - [Rock NSM 2.4.x (RHEL)](./topics/rocknsm2-4-0/RHEL/README.md)
  - Rock NSM 2.5.x (Pending)
    - [Rock NSM 2.5.x (CENTOS)](./topics/rocknsm2-5-0/CENTOS/README.md)
    - [Rock NSM 2.5.x (RHEL)](./topics/rocknsm2-5-0/RHEL/README.md)