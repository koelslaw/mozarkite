# RCDcap

## Description
RCDCap is a packet processing framework. At its core, it incorporates basic mechanisms for local and remote capturing and decapsulation of packets (CISCO ERSPAN and HP ERM are supported). It can be extended to support many types of packet-based traffic analysis by creating plug-ins and loading them in the main application. It includes many optimizations to ensure high-performance traffic processing. Some of them are multithreaded traffic processing, explicit thread pinning; configurable packet burst processing; support for PF_PACKET, and PF_RING. It can also be used to inject the processed traffic to a TAP device or regular physical Ethernet interface. Its basic functionalities make it a viable solution for preprocessing CISCO ERSPAN and HP ERM traffic, which can be handed to some other application. In our case, Gigamon

RCDCap offers its own set of plug-ins for doing different types of traffic analysis. Notably, it has its plug-in for analyzing NDP, ARP, DHCP, and DHCPv6 traffic.

Features:
- CISCO ERSPAN decapsulation
- HP ERM decapsulation
- VLAN support (802.1Q and 802.1P)
- Outputting to the standard output, pcap dump file, or a network device
- Extendable through plug-ins
- Multithreaded packet processing
- Packet burst processing
- Performance tuning
- libpcap (PF_PACKET) and libpfring (PF_RING) support
- UDP socket-based support of HP ERM
- Plug-in: VLAN monitor
- Plug-in: Experimental Python binding
- Plug-in: DHCP, DHCPv6, NDP and ARP monitor


Prereq:
- Rhel Installed / STiG'd
- DNS
- NUC Configured
- 2 Physical NICS w/ isolation from the rest of ESXi nets



- Download the latest version of RCDCap

  ```
  sudo wget https://sourceforge.net/projects/rcdcap/files/RCDCap-0.9.0-Source.tar.bz2/download -o rcpcap.tar.bz2
  ```

- "Unzip" the file

  ```
  sudo tar xjf rcdcap.tar.bz2
  ```

- Prepare the environment to compile RCDCap

  ```
  sudo yum groupinstall "Development Tools"

  ```
  ```
  sudo yum install boost-devel libpcap-devel libstdc++-static cmake rpmrebuild
  ```

- Change into the project top directory(the directory
outside the extracted source folder) and type:

  ```
  sudo mkdir build-make
  ```
  ```
  cd build-make
  ```
  ```
  sudo cmake -G"Unix Makefiles" ../RCDCap-*/
  ```
  ```
  sudo make
  ```
  ```
  sudo cpack -D CPACK_RPM_PACKAGE_DEBUG=1 -D CPACK_RPM_SPEC_INSTALL_POST="/bin/true" -G RPM
  ```

- The build for this tool is a little rough around the edges. I tried to create a directory that is not required during installation. We are going to `rpmrebuild`, the new rpm we just built.  

  ```
  sudo rpmrebuild -pve ~/RCDCap-0.9.0-Source/RCDCap-0.9.0-Linux.rpm 
  ```

- Find the lines that contain the directories `/man/` and `/man1` and delete those lines.

- Finally, install the package that you have just rebuilt:

  ```
  sudo rpm -ihv RCDCap-*.rpm
  ```

- Ensure it starts without errors

  ```
  sudo LD_LIBRARY_PATH=/usr/lib rcdcap -i {recieving interface} --erspan -t tap0
  ```

- Remove the packages we used to compile

  ```
  sudo yum groupremove "Development Tools"
  ```
