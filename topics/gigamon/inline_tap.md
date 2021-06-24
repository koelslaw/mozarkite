# Inline Tap Configuration

> WARNING: This may require a network interruption.

- Right Click the Modules on the tap under the `Chassis` tab and select `Config`.

- The ports you wish to be your tapping interface. For example, 1/1/g- Mouse over `Admin` and select `Enable`, do the same for 1/1/g2.
> NOTE: This is where the network traffic will pass through

- Do the same for the interfaces that connect your Gigamon to your sensor.

- At this point, everything should be a network port. We need to change that to an inline network port. So right-click on `1/1/g1` mouseover `Type` and select `Inline Network`, do the same for 1/1/g2.

- Setup the ports that are going to your server as tool ports in our case `1/1/g1`

- On the left-hand pane click `Maps` so we can start sending our traffic to the tool interfaces from the inline network interfaces, click `New`, give it the following parameters:
  - Map Alias: Tap
  - Type: Regular
  - Subtype: Pass All
  - Source: 1/2/g1
  - Destination: 1/1/x11

- Click `Ok`

- Find `Inline Bypass`, click `New` and give it the following parameters:
  - Alias: Capture
  - Port A: 1/2/g1
  - Port B: 1/2/g2
  - Traffic Path: Bypass with Monitoring
  - Link Failure Propagation: Checked

- At this point, if you ssh into your `sensor.[state].cmat.lan` the machine will start receiving traffic.
