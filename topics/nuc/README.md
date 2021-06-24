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

 -There are two versions of this deployment. Unless something specific is needed, then I recommend using version 2, which is known as "AYR" (Alternate Yum Repository).
   - [Version 1](..topics/nuc/v1/README.md) (Soon to be deprecated, because of openvas)
   - [Version 2](..topics/nuc/v2/ayr/README.md)

- **IF** you are going to use OpenVAS, Run the deployment for under the [v2/openvas-offline](..topics/nuc/v2/ayr/README.md) directory

- Clone the mozarkite GitHub repo. If you cannot access di2e, check with d2ie to ensure you have the authorization to be on di2e. Also, check with technical SME to ensure you have access to the git repo also. If you don't have git already installed using `sudo yum install git`.

```
sudo git clone https://di2euserfirstname.lastname@bitbucket.di2e.net/scm/mozarkite/mozarkite-docs.git
```

## Download Iso images
While you don't have to have these, it will make it easier if you need them in the future. `curl` or `scp` onto the Nuc into the `var/www/html/iso` directory
 - RHEL - DVD iso (Should have this one already downloaded from Nuc installation)
 - ESXi ISO

## Add Docker Images
>NOTE: This is the rough outline of what needs to happen to support CAPES v2.

**If** you are deploying version 2 of CAPES or Version 3 of ROCK then you will need to add docker to the Nuc. This will serve as the base for your docker builds. If you have not already done so, enable the "extras" repository on your RHEL or CENTOS installation and sync. This will make it available to the rest of the stack. After docker is installed then `docker pull` each of the containers for ROCK and CAPES


Move onto [Gigamon Configuration](../gigamon/README.md)
