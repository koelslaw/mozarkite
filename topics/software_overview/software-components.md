# Software Components
These are the software components of the CMAT kit.

| Software                | Purpose                          | Suite   |
|-------------------------|----------------------------------|---------|
| VMWare ESXi             | Hypervisor                       | NA      |
| RedHat Enterprise Linux | Operating System                 | NA      |
| GRASSMARLIN             | Passive ICS / SCADA Enumeration  | NA      |
| Nmap                    | Active Network Enumeration       | NA      |
| BlueScope               | Active Endpoint Interrogation    | NA      |
| OpenVAS                 | Active Vulnerability Scanning    | NA      |
| Google Stenographer     | Full Packet Capture & Indexing   | RockNSM |
| Suricata                | Signature Based Alerting         | RockNSM |
| Bro                     | Protocol Analysis & Metadata     | RockNSM |
| FSF                     | Recursive File Scanning          | RockNSM |
| Kafka                   | Message Queuing & Distribution   | RockNSM |
| Logstash                | Data Transport                   | RockNSM |
| Filebeat                | Data Transport                   | RockNSM |
| Elasticsearch           | Data Storage, Indexing, & Search | RockNSM |
| Kibana                  | Data UI & Visualization          | RockNSM |
| Docket                  | Packet Carving & Retrieval       | RockNSM |

## Component Descriptions
Specific descriptions of the software components.

### VMWare ESXi
VMware ESXi is a purpose-built bare-metal hypervisor that installs directly onto a physical server. With direct access to and control of underlying resources, ESXi is more efficient than hosted architectures and can effectively partition hardware to increase consolidation ratios and cut costs for our customers.

### RedHat Enterprise Linux
Red Hat Enterprise Linux (RHEL) is a Linux distribution developed by Red Hat and targeted toward the commercial market. Red Hat Enterprise Linux is released in server versions for x86-64, Power Architecture, ARM64, and IBM Z, and a desktop version for x86-64. Red Hat Enterprise Linux is often abbreviated to RHEL.

### GRASSMARLIN
GRASSMARLIN provides IP network situational awareness of industrial control systems (ICS) and Supervisory Control and Data Acquisition (SCADA) networks to support network security. Passively map, and visually display, an ICS/SCADA network topology while safely conducting device discovery, accounting, and reporting on these critical cyber-physical systems.

### Nmap
Nmap ("Network Mapper") is a free and open-source utility for network discovery and security auditing. Many systems and network administrators also find it useful for tasks such as network inventory, managing service upgrade schedules, and monitoring host or service uptime. Nmap uses raw IP packets in novel ways to determine what hosts are available on the network, what services (application name and version) those hosts are offering, what operating systems (and OS versions) they are running, what type of packet filters/firewalls are in use, and dozens of other characteristics. It was designed to rapidly scan large networks, but works fine against single hosts.

### BlueScope

TBD

### RockNSM
RockNSM is a collections platform, in the spirit of passive Network Security Monitoring by contributors from all over the industry and the public sector. Its primary focus is to provide a robust, scalable sensor platform for both enduring security monitoring and incident response missions. The platform consists of 3 core capabilities:

- Passive data acquisition via AF_PACKET, feeding systems for metadata (Bro), signature detection (Suricata), and full packet capture (Stenographer).
- A messaging layer (Kafka and Logstash) that provides flexibility in scaling the platform to meet operational needs, as well as providing some degree of data reliability in transit.
- Reliable data storage and indexing (Elasticsearch) to support rapid retrieval and analysis (Kibana) of the data.

## Software External References
- [VMWare ESXi](https://www.vmware.com/products/esxi-and-esx.html)
- [RedHat Enterprise Linux](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux)
- [GRASSMARLIN](https://github.com/nsacyber/GRASSMARLIN)
- [Nmap](https://nmap.org/)
- [BlueScope]()
- [RockNSM](http://rocknsm.io)

Move onto [Hardware Components](/topics/hardware/hardware-components.md)
