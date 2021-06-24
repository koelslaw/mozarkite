# Usage Guide

## Start / Stop / Status

Most of the Rock configuration/operation is now automated and can be called from anywhere on the os. Below are the options. Run `sudo rock help` for help.  
```
[admin@sensor ~]$ sudo rock help
Usage: /sbin/rock COMMAND [options]
Commands:
setup               Launch TUI to configure this host for deployment
tui                 Alias for setup
ssh-config          Configure hosts in inventory to use key-based auth (multinode)
deploy              Deploy selected ROCK components
deploy-offline      Same as deploy --offline (Default ISO behavior)
deploy-online       Same as deploy --online
stop                Stop all ROCK services
start               Start all ROCK services
restart             Restart all ROCK services
status              Report status for all ROCK services
genconfig           Generate default configuration based on current system
destroy             Destroy all ROCK data: indexes, logs, PCAP, i.e. EVERYTHING
                      NOTE: Will not remove any services, just the data

Options:
--config, -c <config_yaml>         Specify full path to configuration overrides
--extra, -e <ansible variables>    Set additional variables as key=value or YAML/JSON passed to ansible-playbook
--help, -h                         Show this usage information
--inventory, -i <inventory_path>   Specify path to Ansible inventory file
--limit <host>                     Specify host to run plays
--list-hosts                       Outputs a list of matching hosts; does not execute anything else
--list-tags                        List all available tags
--list-tasks                       List all tasks that would be executed
--offline, -o                      Deploy ROCK using only local repos (Default ISO behavior)
--online, -O                       Deploy ROCK using online repos
--playbook, -p <playbook_path>     Specify path to Ansible playbook file
--skip-tags <tags>                 Only run plays and tasks whose tags do not match these values
--tags, -t <tags>                  Only run plays and tasks tagged with these values
--verbose, -v                      Increase verbosity of ansible-playbook
```

## Key web interfaces

https://localhost - Kibana web interface

https://localhost:8443 - Docket - web interface for pulling PCAP from the sensor (must be enabled in config)
> localhost is the data node management IP address from the [../platform-management.md](Platform Management) page

Move onto [CAPES](../capes/README.md)
