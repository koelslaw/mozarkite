# CMAT Documentation (Project MOZARKITE)
### Mozarkite
> Mozarkite is a form of chert (flint). It is the state rock of Missouri. The name is a portmanteau, formed from Mo (Missouri), zark (Ozarks), and ite (meaning rock).

<p align="center">
  <img src="images/mocyber.png">
</p>

## Note from the creators:
Since the main components of the CMAT kit are MOCYBER's ROCK platform, we found it fitting to name it after MO's State Rock.

As a git repo, this serves as the primary source of documentation for the Cyber Mission Assurance Team (CMAT) kit. This repository does not cover the concept of operations (CONOPS) for the team but rather how to build the equipment and the ideas of employing (CONEMP) the kit.

This documentation was made with the best effort on a short timeline. Most of the documentation is correct, but there could be nuances or minor details that still need to be adjusted to your environment. Please contribute fixes back to the project.  

  **Famous Quote: When you wait till the last minute, then it only takes a minute. -Jeff Geiger**


:warning: Getting Access to the latest and greatest :warning:

If you are reading this in a pdf, then you are likely reading it in a quick start guide. To get the latest, you need to request an account with the website below:


## Table of Contents

- [Cyber Mission Assurance Team (CMAT) Overview](./topics/cmat-overview.md)
- [Domestic Operations (DOMOPS) Overview](./topics/domops-overview.md)
- [Concept of Employment](./topics/cmat-conemp.md)
- [System Architecture](./topics/software_overview/system-architecture.md)
- [Software Components](./topics/software_overview/software-components.md)
- [Hardware Components](./topics/hardware/hardware-components.md)
- [Hardware Assembly](./topics/hardware/hardware-assembly.md)
- [Hardware Configuration](./topics/hardware/hardware-configuration.md)
  - [Intel Nuc Configuration](./topics/nuc/README.md)
  - [Gigamon Configuration](./topics/gigamon/README.md)
  - [Network Configuration](./topics/network/README.md)
  - [Dell R840 Configuration](./topics/dell/README.md)
- [Software Deployment](./topics/software_overview/software-deployment.md)
  - Infrastructure
    - [ESXi](./topics/vmware/README.md)
  - Passive Software Deployment
    - [RHEL DNS Server](./topics/dns/README.md)
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
      - [Usage](./topics/rocknsm/README.md)
    - [CAPES](./topics/capes/README.md)
    - [GRASSMARLIN](./topics/grassmarlin/README.md)
  - Active Software Deployment
    - [ACAS](./topics/acas/README.md) - *Not opensource but **may** be available*
    - [OpenVAS](./topics/openvas/README.md)
    - [Nmap](./topics/nmap/README.md)
    - [BlueScope](./bluescope/README.md) *Not opensource but **may** be available*
- [Preflight](./topics/deployment/README.md)
- [APPDX1 Network Layout](./topics/network/network-layout.md)
- [APPDX2 Function Check](./topics/maintx_check/function-check.md)
- [APPDX3 Platform Management (IPs, hostnames, creds, etc.)](./topics/platform-management.md)
