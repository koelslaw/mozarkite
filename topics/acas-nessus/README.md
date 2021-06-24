
# Assured Compliance Assessment Solution (ACAS)
The Assured Compliance Assessment Solution (ACAS)is a suite of COTS applications that each meets a variety of security objectives and was developed by Tenable. The new DISA program awarded Tenable the DoD contract in 2012, and the deployment of ACAS throughout the enterprise has been occurring slowly but surely.

## ACAS Components
### Nessus
Many security practitioners are familiar with the product Nessus as it's been around for many years. Nessus is the scanning component of ACAS that is compliant with not only CVE vulnerability identifiers but also DISA STIGs. This is one of the main advantages of Nessus over DoD's previous scanner, Retina. In the DoD world, compliance with STIGS is just as important as compliance with software vulnerabilities. The library of Nessus plugins (audit files) is massive and is updated almost daily to account for the latest threat vectors.

### Passive Vulnerability Scanner
The primary purpose of Passive Vulnerability Scanner (PVS) is to monitor network traffic at the packet level. While Nessus monitors device vulnerabilities, PVS monitors the network traffic traversing your network for vulnerabilities. Please note that PVS is not an IDS and does not replace one in your network. PVS provides the ability to discover new hosts added to a network, find out which ports are passing traffic across the network, identify when applications are compromised and monitor mobile devices connected to your network.

### Security Center
Security Center (SC) is the central management console for the configuration of Nessus & PVS. SC can collect scan data from all PVS and Nessus instances to provide custom dashboards and reports. One of the neat features of SC is the ability to roll-up SC instances for reporting purposes. This allows the DoD to deploy SC at various levels, with all of them reporting to one or more main SC instances. As you can imagine, this reporting capability can be very beneficial as leadership now can view policy, vulnerability compliance, and total IT assets across the enterprise. Assessing the security posture of the DoD's infrastructure is now easier than ever.

### Installation
Substitute Nesssus and ACAS as needed.

> If you are using commercial Nessus, then use the link below. Download the rpm package to the NUC when it connected to the internet.
 https://www.tenable.com/downloads/api/v1/public/pages/nessus/downloads/10197/download?i_agree_to_tenable_license_agreement=true

- You can download it via command line with:
```
sudo wget -O nessus.rpm https://www.tenable.com/downloads/api/v1/public/pages/nessus/downloads/10197/download?i_agree_to_tenable_license_agreement=true
```

- Install using:
```
sudo rpm -ivh Nessus-<version number>-es6.x86_64.rpm
```

- Open the firewall using
```
firewall-cmd --add-port=8834/tcp --permanent
firewall-cmd --reload
```

- Now, we are ready to start Nessus:
```
sudo systemctl start nessusd
```

- Connect to the scanner using your browser with the following URL:
```
https://10.[state octet].20.2:8834
```

- Create an account:

- Register your scanner with the activation code

- Once you have entered your activation code, Nessus will start initializing. This can take some time.
