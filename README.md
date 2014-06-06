pybossa-jujucharm
=================

Juju Charm for PyBossa

This is **pre alpha** and currently only tested with Ubuntu 14.04 and Vagrant!

## Testing PyBossa charm with Vagrant

### This guide is based on [Ubuntu's Juju Vagrant guide][1]. Follow this steps:

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

When this is successful (it takes some minutes) you should be able to see the Juju GUI on [http://127.0.0.1:6080][2]

### Next we want to install PyBossa on Juju.

So we ssh into the vagrant box by:
```
vagrant ssh
```
and install our cloned pybossa charm with:
```
juju deploy --repository=/vagrant local:trusty/pybossa
```
you can watch progress of installation (for debugging):
```
tail -f /var/log/juju-vagrant-local/unit-pybossa-0.log
```

After pybossa is installed it only needs to be exposed so that it is reachable (can be done also by Juju GUI):
```
juju expose pybossa
```

Now get the internal IP of pybossa:
```
juju status
```

Internally on the Virtualbox network Pybossa is reachable. If you want to see it on your local browser you need to redirect the VBox network with your network. The VBox is typically 10.0.3.xxx. Open a new console on your local machine and type:
```
sshuttle -r vagrant@localhost:2222 10.0.3.0/24
```
`sshuttle` maybe asks for local sudo password.  
If it asks for vagrant's password: `vagrant`

Finally open your browser on port 5000 with the IP you got from `juju status`, e.g.:
```
http://10.0.3.89:5000
```

## TO DO:
- [ ] Connect with PostgreSQL Charm
- [ ] Charm for Precise
- [ ] Integrate PGPool
- [ ] Connect with HAProxy (should be easy according to docs)
- [ ] Test charm for different environments
  - [x] Test charm with local installation on Ubuntu (LXC)
  - [ ] Test charm with MAAS


  [1]: https://juju.ubuntu.com/docs/config-vagrant.html
  [2]: http://127.0.0.1:6080