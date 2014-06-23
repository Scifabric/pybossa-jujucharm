## Testing PyBossa charm with Vagrant (Windows, OS X, Linux)

### This guide is based on [Ubuntu's Juju Vagrant guide](https://juju.ubuntu.com/docs/config-vagrant.html). Follow this steps:

Install `virtualbox`,`vagrant` & `sshuttle` depending on your OS.

> Ubuntu example:
> ```
> sudo apt-get update 
> sudo apt-get -y install virtualbox vagrant sshuttle
> ```

> OS X example:
>
> * install virtualbox and vagrant manually by visiting their websites
> * install sshuttle with Homebrew `brew install sshuttle`. First usage requires maybe a reboot.

Clone this repo:
```
git clone https://github.com/PyBossa/pybossa-jujucharm.git
cd pybossa-jujucharm
```
 
Create a PyBossa Vagrant Virtualbox based on Ubuntu 14.04 Trusty:
```
vagrant box add JujuBox http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-juju-vagrant-disk1.box
```
 
Initialize this environment by running:
```
vagrant init JujuBox
```

Then start it with:
```
vagrant up
```

When this is successful (it takes some minutes) you should be able to see the Juju GUI on [http://127.0.0.1:6080](http://127.0.0.1:6080)

### Next we want to install PyBossa on Juju.

So we ssh into the vagrant box by:
```
vagrant ssh
```
and install our cloned pybossa charm with:
```
juju deploy --repository=/vagrant local:trusty/pybossa
```
> you can watch progress of installation (for debugging):
> ```
> tail -f /var/log/juju-vagrant-local/unit-pybossa-0.log
> ```

### PostgreSQL

Install the PostgreSQL charm and connect PyBossa with the database:
```
juju deploy postgresql
juju add-relation pybossa postgresql:db-admin
```

### HAProxy

HAProxy is a load balancer and necessary once more than one running PyBossa
charm can connect to the DB (not supported yet).

Deploy HAProxy and connect it to the PyBossa instance.
Also expose it so that it is reachable from the outside.
```
juju deploy haproxy
juju add-relation haproxy pybossa
juju expose haproxy
```

Wait till HAProxy is exposed (you should see an ip here of haproxy):
```
juju status
```

### sshuttle

The Virtualbox network is only internally visible on the VM side. If you want to see it on your local browser you need to redirect the VBox network with your network (make sure the 10.x.x.x is not already used!). The VBox is typically 10.0.3.xxx. Open a new console on your local machine and type:
```
sshuttle -r vagrant@localhost:2222 10.0.3.0/24
```
`sshuttle` maybe asks for local sudo password.  
If it asks for vagrant's password: `vagrant`

Finally open your browser with the IP you got from `juju status` and HAProxy, e.g.:
```
http://10.0.3.89
```