# Intel Nuc Configuration

The intel Nuc is an essential part of the initial setup and maintenance. It is used as your:
- RPM repo
- Documentation Repo
- Generally to build/rebuild and maintain the kit

## Prereqs

- [RHEL](../rhel/README.md) Installed
> Note: if necessary, these steps can be replicated to work with [CentOS Minimal](http://mirror.mobap.edu/centos/7.5.1804/isos/x86_64/CentOS-7-x86_64-Minimal-1804.iso).

- Network connection to the Internet

## Deploy Initial Configuration
We are going to deploy the initial configuration for the Nuc. This will configure the Nuc as a repository to build the rest of the kit, as well as to store documentation.  

- Before that, we need some upstream packages for installation. To get those, we need to grab our RHEL subscription.

  ```
  sudo subscription-manager register --username [see Platform Management] --password [see Platform Management] --auto-attach
  ```

  Congrats! You have access to the RHEL RPM Repos. By extension, so does the rest of the stack.

- The next script is meant to take some of the work on setting up the Nuc. Using the script also ensures the rest of the kit has what it needs to function.

- Clone the mozarkite GitHub repo. If you cannot access di2e, check with d2ie to ensure you have the authorization to be on di2e. Also, check with technical SME to ensure you have access to the git repo also. If you don't have git already installed using `sudo yum install git`.

  ```
  sudo git clone https://di2euserfirstname.lastname@bitbucket.di2e.net/scm/mozarkite/mozarkite-docs.git
  ```


:warning: The next action will result in large downloads. I would not recommend completing the following actions unless you have a decent internet connection and/or some time. :warning:

- Run the deploy Nuc Script
  ```
  sudo sh ~/mozarkite-docs/topics/nuc/deploy-nuc.sh
  ```

#### Post-Install Configuration
When you browse to Gitea for the first time, you'll enter a post-installation configuration pipeline.

* The database user will be `gitea` and the passphrase will be what you set at the beginning of the install process  
* Use the explicit IP of the Gitea server instead of `localhost` for the `Domain` and `Application URL` fields  
* Under `Server and other Services Settings` check the `Disable Avatar Service` box  

![gitea install](img/install.png)

##### Configure SSH Usage

Gitea provides the ability to perform git functions via http or ssh.  To enable `ssh` complete the following steps:  

* edit gitea's app.ini file  
`sudo vi /opt/gitea/custom/conf/app.ini`  

make the following changes & additions to the `[server]` section:  

`START_SSH_SERVER = true`     # ensure this is set to true  
`DISABLE_SSH      = false`    # ensure this is set to false  
`SSH_PORT         = 4001`     # set this to any available port that is **NOT 22**   
`SSH_LISTEN_PORT  = 4001`     # set this to any available port that is **NOT 22**  

here's an example (showing only the `[server]` section):  

```
[server]
LOCAL_ROOT_URL   = http://localhost:4000/
SSH_DOMAIN       = <ip>
START_SSH_SERVER = true
DOMAIN           = <ip>
HTTP_PORT        = 4000
ROOT_URL         = http://<ip>:4000/
DISABLE_SSH      = false
SSH_PORT         = 4001
SSH_LISTEN_PORT  = 4001
LFS_START_SERVER = true
LFS_CONTENT_PATH = /opt/gitea/data/lfs
LFS_JWT_SECRET   = xxxxxxxxxxxxxxxxxxx
OFFLINE_MODE     = false

```

##### Wrapping it up
```
sudo firewall-cmd --add-port=4001/tcp --permanent
sudo firewall-cmd --reload
sudo systemctl restart gitea
sudo systemctl restart sshd
```

Once the post-installation steps have been completed, then we need to clone a few git repositories to ensure we have what we need to build ROCK. Navigate to '10.[state].10.19:4000` or `nuc.[STATE].cmat.lan:4000` if you already have DNS set up in accordance with the documentation.

Mirror the following Repositories in gitea

 - rock-scripts https://github.com/rocknsm/rock-scripts.git (Rock Sensor Installation)
 - rock-dashboards https://github.com/rocknsm/rock-dashboards.git (Rock Data Tier Installation)
 - CAPES https://github.com/capesstack/capes.git (Capes Installation)
 - Rock https://github.com/rocknsm/rock.git (Data and Sensor Installation)
 - hackmd  https://github.com/hackmdio/hackmd.git
 - Cortex https://github.com/TheHive-Project/Cortex-Analyzers.git
 - Any Repos you have for quick references like the handy once that was included in the book you received during software training


## Download Iso images
While you don't have to have these, it will make it easier if you need them in the future. `curl` or `scp` onto the Nuc into the `var/www/html/iso` directory
 - RHEL - DVD iso (Should have this one already downloaded from Nuc installation)
 - ESXi ISO

Move onto [Gigamon Configuration](../gigamon/README.md)
