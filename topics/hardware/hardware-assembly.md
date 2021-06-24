# CMAT Hardware Assembly
The CMAT kit contains [several hardware assets](/topics/hardware/hardware-components.md).


## Prereqs
- Two people (Cases are prone to tipping when servers have castor wheels installed)
- case on floor

# A Note about Rack Units (U's)
A Rack Unit (abbreviated U or RU) is a unit of measure defined as 1.75 in. It is most frequently used as a measurement of the overall height of 19-inch and 23-inch rack frames, as well as the height of equipment that mounts in these frames, whereby the height of the frame or equipment is expressed as multiples of rack units. For example, a typical full-size rack cage is 42U high, while equipment is typically 1U, 2U, 3U, or 4U high.

**The counting of U's starts at the bottom of the rack.**
___
# Case 1

## Step 1 - Disassemble Case

- Remove doors from the case - front and back

- Turn knobs until unlatched

-  Open doors

- Unhinge doors


## Step 2 - Installation of Cisco Switch - U1

- Attach front brackets (included) to both sides using four mounting holes (front and rear) and four short-set screws per side

- Installing the power supply into the switch

- Remove blanking from the back right of the switch using squeeze handles

- Insert power supply with letters facing up until latched into place

- Inserting Cisco Networking module

- Release two set screws from expansion plate right front and remove expansion plate

- Insert the network module and tighten captive bolts on the front of network module (Do not over tighten)

- Installation of 4 SFPs

- Insert all SFP-10G-SR modules into available SFP slots on the bottom right of the switch

- Mount switch to case

- From front mount the switch into u3 and install two screws per side to attach the switch to Case (use the assistance of two people)

## Step 3 - Install Server - U2 & U3

### Rail and Server Installation
Identifying the rail kit contents
To install the left rail:

- **DO NOT** Fully extend the rear sliding bracket of the rail.

- Position the rail end piece labeled FRONT facing inward and
orient the rear end piece to align with the holes on the rear
rack flanges.

- Push the rail straight toward the rear of the rack until the
latch locks into place.

- For the front end piece, rotate the latch outward and pull the
rail forward until the pins slide into the flange and release the
latch to secure the rail in place.

- Repeat the preceding steps to install the right rail.

- Pull the inner rails out of the rack until they lock into place.

- Locate the rear rail standoff on each side of the system and lower them into the rear J-slots on the slide assemblies.

- Install the system and ensure that the rail standoffs are seated in the J-slots.

- Push the system inward until the lock levers click into place.

- Pull the blue slide release lock tabs forward on both rails and slide the system into the rack until the system is in the rack.

- To secure the system, push the system into the rack until the slam latches engage and lock into the rack.

> NOTE: To secure the system for shipment in the rack or
in other unstable environments, locate the hard mount
captive screw under each latch and tighten each screw
using a Phillips #2 screwdriver.

- Release the system from the rack by lifting the slam latches
and sliding the system out of the rack.

> NOTE: If applicable, use a Phillips #2 screwdriver to
unscrew the captive screws that secure the system to
the rack. To secure the rails to a square hole or unthreaded round
hole rack for shipping or in unstable environments, install the
supplied screws to the rails.

- Insert and tighten the two screws using the Phillips #2
screwdriver to secure the back of the rails to the rack.

### Hardware Reconfiguration

- Remove 1 of 1.6 TB SSD to the Server that will be designated as you Sensor/Baremetal/RHEL Machine/Non-ESXi


## Step 4 - Installation of Cisco Edge Router - U4

- Remove two set screws from each side on the back of the router

- Place bracket past extending of the rear of the router and attach with four screws into the side of the router.

- Insert router with the rear-facing the front of the case and mount to the case with four

## Step 5 - Installation of Middle Atlantic Power Supply - U5

- Insert four screws to secure the power supply to the case

```
┌────────────────────────────────────┐
│              CASE 1                │
│ ┌────────────────────────────────┐ │
│ │     MIDDLE ATLANTIC POWER      │ │
│ ├────────────────────────────────┤ │
│ │       CISCO ROUTER 4321        │ │
│ ├────────────────────────────────┤ │
│ │        Dell R840               │ │
│ ├────────────────────────────────┤ │
│ │       CISCO SWITCH C3850       │ │
│ └────────────────────────────────┘ │
└────────────────────────────────────┘
```
___

# Case 2

## Step 1 - Dissemble Case
- Remove doors from the case - front and back

- Turn knobs until unlatched

- Open doors

- Unhinge doors

## Step 2 - Installation of Gigamon - U1

- Attach front brackets (included) to both sides using four lower mounting holes and four short-set screws per side

- Attach rear hanging brackets from the rear of case in U3

- Gigamon has three silver slide mounts on each side towards the rear of the device

- From front to the back of the case, insert slide mounts into rear mounts in U3

- Above step may take some wiggling, side-to-side, of Gigamon

- From the front, insert two screws per side to attach the device to the case

- Installation of the Tap

- Release thumb screw on far left expansion port to remove the cover

- Release thumb screw on tap before installation

- Insert tap into expansion slot (should not require much force)

- After inserting tap, close lever and tighten thumb screws

- Installation of 5 SFPs

- Insert SFP 503 - 1G single-mode - into slot x12

- Insert SFP 502 - 1G multi-mode - into slot x10

- Insert SFP 501 - 1G copper - into slot X8

- Insert SFP 533 - 10G single-mode - into slot X11

- Insert SFP 532 - 10G multi-mode - into slot X9

- Install Power Cords

## Step 3 - Install Server - U2 & U3
### Rail and Server Installation
- Identifying the rail kit contents
To install the left rail:
> **DO NOT** Fully extend the rear sliding bracket of the rail.

- Position the rail end piece labeled FRONT facing inward and
orient the rear end piece to align with the holes on the rear
rack flanges.

- Push the rail straight toward the rear of the rack until the
latch locks into place.

- For the front end piece, rotate the latch outward and pull the
rail forward until the pins slide into the flange and release the
latch to secure the rail in place.

- Repeat the preceding steps to install the right rail.

- Pull the inner rails out of the rack until they lock into place.

- Locate the rear rail standoff on each side of the system and
lower them into the rear J-slots on the slide assemblies.

- Install the system and ensure that the rail standoffs are seated
in the J-slots.

- Push the system inward until the lock levers click into place.

- Pull the blue slide release lock tabs forward on both rails and slide the system into the rack until the system is in the rack.

- To secure the system, push the system into the rack until the
slam latches engage and lock into the rack.

> NOTE: To secure the system for shipment in the rack or
in other unstable environments, locate the hard mount
captive screw under each latch and tighten each screw
using a Phillips #2 screwdriver.

- Release the system from the rack by lifting the slam latches
and sliding the system out of the rack.

> NOTE: If applicable, use a Phillips #2 screwdriver to
unscrew the captive screws that secure the system to
the rack. To secure the rails to a square hole or unthreaded round
hole rack for shipping or in unstable environments, install the
supplied screws to the rails.

- Insert and tighten the two screws using the Phillips #2
screwdriver to secure the back of the rails to the rack.


## Step 4 - Installation of Middle Atlantic Power Supply - U4

- Insert four screws to secure the power supply to the case

```
┌────────────────────────────────────┐
│              CASE 2                │
│ ┌────────────────────────────────┐ │
│ │     MIDDLE ATLANTIC POWER      │ │
│ ├────────────────────────────────┤ │
│ │      DELL R840                 │ │
│ ├────────────────────────────────┤ │
│ │      GIGAMON GIGAVUE HC1       │ │
│ └────────────────────────────────┘ │
└────────────────────────────────────┘
```
___

# Hardware Wiring

|Source | Port                 | Destination |Port             |Media
|--|--|--|--|--|
|Switch | Gi1/0/1              |Router       |0/0/0            |Ethernet|
|Switch | Gi1/0/2              |AP           |POE/mGig         |Ethernet|
|Switch | Gi1/0/3              |GIGAMON      |MGMT PORT        |Ethernet|
|Switch | Gi1/0/4              |Server 1     | iDRAC           |Ethernet|
|Switch | Gi1/0/5              |Server 2     |iDRAC            |Ethernet|
|Switch | Gi1/0/6              |NUC          |Port 1           |Ethernet|
|Switch | Te1/0/1 (SR SFP)     |Server 1     | 0/0/2(SR SFP)   |Multimode Fiber|
|Switch | Te1/0/2 (SR SFP)     |Server 2     | 0/0/1(SR SFP)   |Multimode Fiber|
|Gigamon| Tool Port 1 (1/0/x11)|Server 1     | SFP Port 1      |Multimode Fiber|

Physical Port Assignments to VLANs

|VLAN|Port              |Description|
|--|--|--|
|10  |1-36                |Internal or Passive|
|20  |37-48               |Active|
|30  |Internal to Switch  |VPN Tunnel|
|50  |Internal to switch  |Management interface for wireless AP|
|60  |Internal to switch  |DHCP Pool for Clients|

![](../images/netlayout.png)  

Move onto [Hardware Configuration](/topics/hardware/hardware-configuration.md)
