
# Network Configuration

## Address tables

The CMAT kits will use the following network standard: `10.[KIT].[VLAN].[HOST]`

## VLANs to Physical Ports
| VLAN  |  Port     | Description |
|-------|-----------|-------------|
| 10    | 1 - 35    | Internal    |
| 20    | 36 - 48   | Active      |

## Gateways
| IP       | Router Gateway                              |
|:---------|:--------------------------------------------|
|10.[state].10.1 | [VLAN 10 Gateway (Passive)](#passive-table) |
|10.[state].20.1 | [VLAN 20 Gateway (Active)](#active-table)   |
|10.[state].50.1 | VLAN 50 Gateway (Remote)                    |
|10.[state].60.1 | VLAN 60 Gateway (Remote)                    |

- Move to [Dell R840 Configuration](../dell/README.md)