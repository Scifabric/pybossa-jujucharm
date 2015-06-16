## Install PyBossa charm with local LXC container (Ubuntu only)

This guide requires **Ubuntu 14.04** (Trusty Tahr).

### Based on [Ubuntu's local LXC guide](https://juju.ubuntu.com/docs/config-LXC.html). Follow this steps:

Install Juju on Ubuntu with this commands:
```
sudo apt-add-repository ppa:juju/stable
sudo apt-get update
sudo apt-get install juju-local git-core
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

Clone this repo:
```
git clone https://github.com/PyBossa/pybossa-jujucharm.git
cd pybossa-jujucharm
```

For first time usage on Juju we need to bootstrap it:
```
juju bootstrap
```
 
and install our cloned pybossa charm with:
```
juju deploy local:trusty/pybossa
```

> **Note:** Installation for the pybossa charm can take a while (some minutes) because Juju is deploying a new LXC machine and is installing PyBossa's Juju charm.
>
> You can watch progress of installation in the logs which are in directory `~/.juju/local/log`. Example:
> ```
> tail -f ~/.juju/local/log/unit-pybossa-0.log
> ```
> or
> ```
> juju status
> ```

### PostgreSQL

Install the PostgreSQL charm and connect PyBossa with the database:
```
juju deploy postgresql
juju add-relation pybossa postgresql:db-admin
```

## Redis and Sentinel (optional)

First you need to deploy at least two nodes of Redis: a master and a slave:

```
juju deploy cs:~juju-gui/trusty/redis-1
juju deploy cs:~juju-gui/trusty/redis-1 redis2
```

Then, you need link them:

```
juju add-relation redis:master redis2:slave
```

Now you can add the Sentinel:

```
juju git-deploy PyBossa/redis-sentinel-jujucharm
```

**NOTE**: If you don't have the git-deploy command for juju, you can install it with these commands:

```
sudo apt-get install python3-pip
sudo pip install juju-git-deploy
```

And monitor Redis master:

```
juju add-relation redis-sentinel redis:master
```

Finally, you can link PyBossa to sentinel:

```
juju add-relation pybossa redis-sentinel
```



### HAProxy

HAProxy is a load balancer and necessary once more than one running PyBossa
charm can connect to the DB (not supported yet).

Deploy HAProxy and connect it to the PyBossa instance:
```
juju deploy haproxy
juju add-relation haproxy pybossa
juju expose haproxy
```

Wait till HAProxy is exposed (you should see an ip here of haproxy):
```
juju status
```

and open your browser normally (port 80) with the IP you've got from `juju status`, e.g.:
```
http://10.0.3.89
```
