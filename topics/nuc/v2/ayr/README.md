# Alternate Yum Repository
Used to create a local mirror for redistribution on a local network. If you live in the sticks as I do, bandwidth is precious, so reaching out repeatedly to get the same stuff sucks. Also, some repositories are notorious for being available when you need them. I have forked the original and simplified it a little. The big difference is that you will have to register your RHEL stuff before firing things off instead of adding creds to the script. I wouldn't say I like keeping my RHEL creds in a clear text file. This also makes it easier to deploy on centos. The TL;DR, if you have it enabled as a repo in the etc/yum/repos.d/* then it can make a local copy of it. Regular syncs are recommended (weekly or monthly).


## Prep Work
- Update things ` sudo yum update`
- add the epel repo for git
`sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm`
- then install the ansible and git `sudo yum install ansible git`
- Clone this playbook
- Add the repos you wish to have loaded on your system like:
  - EPEL (should have this if you installed ansible already)
  `sudo yum install epel-release`
  - Custom Yum Repository Like "ROCK NSM"
  `sudo yum-config-manager --add-repo https://copr.fedorainfracloud.org/coprs/g/rocknsm/rocknsm-2.1/repo/epel-7/group_rocknsm-rocknsm-2.1-epel-7.repo`

>NOTE: You don't have to clone all the repos in your `/etc/yum.repos.d/` directory. If you are going to clone it, you need to have it there. Edit the list in `~/ayr/vars/main.yml` only for the repos you wish to replicate locally.

:warning:***This a bandwidth-intensive operation, grab a cup of coffee or go to lunch. This will take a while! Disable or move any repos that you do not want to be syncd*** :warning:

Once you have repos that you wish to have replicated, fire off the ansible script with `sudo ansible-playbook -vv site.yml -i hosts.ini`

>NOTE: I run this verbose because this usually takes a while, and I want to make sure that nothing has died.

## Repo synchronization

Regular syncs of the repo are required in order to keep it up to date. Rerunning the playbook should achieve the expected result. If you wish to automate it you can add a cron job to update it.  
The cronjob that will automatically trigger the repository
synchronization on the schedule you decide. To enable it, you need to set the
`repo_autosync` var to True. To define the schedule for the cronjob,
the following vars can be set:
* crontab_day
* crontab_hour
* crontab_minute
* crontab_month
* crontab_weekday

When setting `repo_autosync` var to False, the cronjob will be removed.
In order to just set up the cronjob, you can execute the playbook with the
`prepare_cron` tag with `sudo ansible-playbook site.yml --tags=prepare_cron -i hosts.ini`


TODO:
 - Add script to keep the last two versions to the cron job
