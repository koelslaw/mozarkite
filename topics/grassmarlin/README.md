# GRASSMARLIN Install
GRASSMARLIN provides IP network situational awareness of industrial control systems (ICS) and Supervisory Control and Data Acquisition (SCADA) networks to support network security. Passively map, and visually display, an ICS/SCADA network topology while safely conducting device discovery, accounting, and reporting on these critical cyber-physical systems.

## Documentation
GrassMarlin v3.2 User Guide:  
- [Download PDF](topics/grassmarlin/GRASSMARLIN User Guide.pdf)   
- [Presentation on GRASSMARLIN](topics/grassmarlin/GRASSMARLIN_Briefing_20170210.pptx)  

## Create the Active Virtual Machine for GRASSMARLIN
- Select `Create/Register VM`  
  - Name: `GRASSMARLIN`  
  - Compatibility: Leave default  
  - Guest OS Family: `Linux`  
  - Guest OS Version: `Red Hat Enterprise Linux 7 (64-bit)`  
- Select your storage  
- Customize the VM  
  - CPU: `4`  
  - Memory: `8 GB`, Reserved
  - Hard disk 1: `50 GB`  
  - SCSI Controller 0: Leave default  
  - SATA Controller 0: Leave default  
  - USB controller 1:  Leave default  
  - Network Adapter: `Passive`, ensure that `Connect` is enabled  
  - CD/DVD Drive 1: `Datastore ISO file`, select the RHEL ISO you uploaded above, ensure that `Connect` is enabled  
  - Video Card: Leave default  
- Review your settings  
- Click Finish  

## Install Instructions
- Install OS in accordance with [Rhel Documentation](../rhel/README.md)

## Install GRASSMARLIN
```
sudo yum install http://10.[state octet].10.19/grassmarlin-3.2.1-1.el6.x86_64.rpm -y
```

## Notes
 For other versions visit: https://github.com/nsacyber/GRASSMARLIN/releases


Move to [OpenVAS](../openvas/README.md)
