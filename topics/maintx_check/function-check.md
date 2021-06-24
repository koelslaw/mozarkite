# Function Check of Rock Sensor
- ***CHECK YOUR CABLES*** Seems stupid, but it happens all the time
- **IF** allowed, connect a computer to the network/tap to ensure you have traffic flowing
> NOTE: only do this at home station or exercise ***DO NOT DO ON MISSION***
- Run `tcpdump -iv NAMEOFINTERFACE` on the capture interface to ensure traffic is flowing
- Ping `dns.[state].cmat.lan`
- Log into the `sensor.[state].cmat.lan` and run a `sudo systemctl status SOMESERVICE` ensure that all the installed portions of the sensor return no errors. Also, ensure that there are no errors in the files in  `/var/log/` ,  `tailf` is handy for this
  - Stenographer
  - kafka
  - FSF
  - BRO (use broctl instead)
  - Suricata
- Check suricata using by adding a rule that will likely trigger an alert in `/etc/suricata/rules/ET-xxx.rules`  like:
```
alert ip $HOME_NET any -> !$HOME_NET any (msg:"Test rule that fires on external IPS"; sid:1;)
```
or
```
alert icmp any any -> any any (msg: "ICMP Packet found";)
```

- Make sure there are logs in `/data/bro/current/`
  -if you are having issues, try `bro -a local` to see if the config file is good.
- Run `/opt/kafka/bin/kafka-console-consumer.sh --from-beginning --topic bro-raw --bootstrap-server sensor.[state].cmat.lan:9092` and ensure Kafka is creating topics
- log into `es1.[state].cmat.lan` and run a `sudo systemctl status SOMESERVICE` ensure that all the installed portions of the sensor return no errors. Also, ensure that there are no errors in the files in  `/var/log/` ,  `tailf` is handy for this
  - Logstash
  - Elasticsearch
  - Kibana
  - docket
> NOTE: Logstash can be a bit of a pain to work with. The error reporting to in `systemctl` and `/var/log` is usually only helpful for basic stuff. The command `/usr/share/logstash/bin/logstash -t -f /etc/logstash/conf.d/$confFiles` is used to ensure there are no error with the logstash config file. It will test the file to give you exact error line number, because even though it says line 392 it really could be before that or even after that line or in the file before the one described in an error
-  Navigate to Kibana `http://kibana.[state].cmat.lan` and ensure it loads, and you see traffic from Bro and Suricata
- Go forth and find Evil.
