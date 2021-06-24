# ERSPAN Tunneling
> **WARNING: THIS CONFIG IS NOT PASSIVE!!!**

> WARNING: This a very CPU and bandwidth-intensive process. It serves the same function as a regular span port on a switch but is routes it over Layer 3 UDP instead of staying on layer 2 like a normal. If possible, it is better to have the kit located in the same location. In that way, you are just forwarding the user interface traffic over a remote connection. Use this only in an emergency.


This is to de-encapsulate the traffic from an ERSPAN and pass the traffic to another interface
- Right Click the Modules on the tap under the `Chassis` tab and select `Config`.

>NOTE: The port on the passive card are unable to terminate an ERSPAN

- The ports you wish to be a termination point for your ERSPAN. For example, 1/2/x1- Mouse over `Admin` and select `Enable`.

- The ports you wish to be your sensor interface. For example, 1/1/x12. Mouse over `Admin` and select `Enable`.

- Ensure you have the tunneling license installed on your Gigamon

- Navigate to 'GigaSMART' and then click on `GigaSMART Groups` and create a new one by clicking `New`

- Name the group `ERSPAN_GS_Group` and use the default options and `Save` the config.

- Navigate to `GigaSMART Operations` and create a `New` config.

- Name it `tunnel_decap` select `ERSPAN_GS_Group` for the GigaSMART Group

- Select the `Tunnel Decapsulation` for the GigaSMART Operations (GSOP) field. Then click `Save`

- Select `Ports` from the left menu pane.

- Select `Tunnel Ports` and create a `New` config.

- Select the port that the termination will occur. Input the IP Destination, Subnet, and Gateway for the termination of the ERSPAN

- Select the appropriate MTU for the connection or input 1500

Select `ERSPAN_GS_Group` for the GigaSMART Group, then save the config.

Check the stats on GigaSMART Groups and GigaSMART operations to ensure that traffic is being routed correctly. 
