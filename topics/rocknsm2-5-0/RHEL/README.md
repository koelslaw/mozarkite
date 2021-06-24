# RockNSM 2.5.0 Readme
2.5 Changelog will go here:
 - Bro to Zeek
 - Suricata 5
 - Removal of several Deprecated Python 2 pkg
 - Removal of GeoIP

## Data Node
- Elasticsearch x3 but can be up to 10 if the ram is available
- Elastic Kibana (w/ RockNSM's Docket)

## Sensor
The sensor has the network security monitoring and data shipping elements:
- Bro protocol analyzer
- Suricata IDS
- Emerson FSF
- Google Stenographer
- Apache Kafka
- Elastic Logstash
- Elastic Beats

## Pre-deployment on all machines

- Even though this is RHEL, we are going to use the CENTOS iso to bootstrap our deployment. This is to ensure a stable implementation with no bleeding edge stuff that may be included if you clone the git repo.

- Download the latest 2.5.X iso if you haven't already downloaded it to the nuc. If you have already `scp` or `rsync` it over to all the machines that will be part of your sensor.

-  Mount it using
```
sudo mount -o loop /home/admin/rocknsm-<ROCK VERSION HERE>.-1902.iso /mnt
```


## Build Steps
- [Hardware Requirements](rocknsm-requirements.md)
- [RockNSM Deployment](sensordeploy.md)
- [Usage](rocknsm-usage.md)
