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

> it should show something like this with `agent-state: installed` and `public-address`:
> ```
> services:
>   pybossa:
>     charm: local:trusty/pybossa-0
>     exposed: true
>     units:
>       pybossa/0:
>         agent-state: installed
>         agent-version: 1.18.4.1
>         machine: "1"
>         open-ports:
>         - 5000/tcp
>         public-address: 10.0.3.89
> ```

Finally open your browser on port 5000 with the IP you got from `juju status`, e.g.:
```
http://10.0.3.89:5000
```

### HAProxy (optional)

Instead of exposing PyBossa directly it is also possible to use a load balancer
like HAProxy in front which will enable to run more than one PyBossa instance
when DB connections are ready.

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
