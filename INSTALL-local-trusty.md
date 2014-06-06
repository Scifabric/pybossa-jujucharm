## Install PyBossa charm with local LXC container (Ubuntu only)

This guide requires **Ubuntu 14.04** (Trusty Tahr).

### Based on [Ubuntu's local LXC guide](https://juju.ubuntu.com/docs/config-LXC.html). Follow this steps:

Install Juju on Ubuntu with this commands:
```
sudo apt-add-repository ppa:juju/stable
sudo apt-get update
sudo apt-get install juju-local
```

Configure Juju for first time usage. All information and settings for Juju will be stored in your home `~/.juju` directory.
```
juju generate-config
```

we want to switch to local installation for default (this changes settings in `.juju/` files)
```
juju switch local
```

### Install PyBossa charm

For first time usage on Juju we need to bootstrap it:
```
juju bootstrap
```

Clone this repo:
```
git clone https://github.com/PyBossa/pybossa-jujucharm.git
cd pybossa-jujucharm
```
 
and install our cloned pybossa charm with:
```
juju deploy local:trusty/pybossa
```

> **Note:** Installation for the pybossa charm can take a while (some minutes) because Juju is deploying a new LXC machine and is installing PyBossa's Juju charm.

You can watch progress of installation in the logs which are in directory `~/.juju/local/log`. Example:
```
tail -f ~/.juju/local/log/unit-pybossa-0.log
```
or
```
juju status
```

After pybossa is installed it only needs to be exposed so that it is reachable:
```
juju expose pybossa
```

Now get the internal IP of pybossa:
```
juju status
```

Finally open your browser on port 5000 with the IP you got from `juju status`, e.g.:
```
http://10.0.3.89:5000
```