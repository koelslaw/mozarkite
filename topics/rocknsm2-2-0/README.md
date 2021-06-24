# RockNSM Readme
RockNSM has 2 components, the data node (top half or Server 2) and the sensor (bottom half or Server 1).

## Data Node
The data node has the indexing/storage and visualization elements:
- Elastic Elasticsearch
- Elastic Kibana (w/ RockNSM's Docket)

## Sensor
The sensor has the network security monitoring and data shipping elements:
- Bro protocol analyzer
- Suricata IDS
- Emerson fsf
- Google Stenographer
- Apache Kafka
- Elastic Logstash
- Elastic Beats

## Build Steps
- [Hardware Requirements](rocknsm-requirements.md)
- [RockNSM Sensor](rocknsm-sensor.md)
- [RockNSM Data Node](rocknsm-datanode.md)
- [Connecting the Sensor to the Data Node](rocknsm-configuration.md)
- [Usage](rocknsm-usage.md)

Start with [Hardware Requirements](rocknsm-requirements.md).
