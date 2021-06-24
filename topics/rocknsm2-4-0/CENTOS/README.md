# RockNSM 2.4.0 Readme
This version has taken feedback from previous versions and made multinodal deployment easier. All installation of the rock components is "driven" from the sensor. From there, the `hosts.ini` takes care of stitching the two servers together and making the appropriate changes to the config files to account for every server that that is part of the sensor. This should aid in the initial config and also aid in the further configuration if more hardware is required to support a mission.

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

## Build Steps
- [Hardware Requirements](rocknsm-requirements.md)
- [RockNSM Deployment](sensordeploy.md)
- [Usage](rocknsm-usage.md)
