## Testing PyBossa charm with Vagrant

With this guide you can test the PyBossa Juju charm inside a Virtualbox VM. Vagrant will help us to setup a new VM.
This should work on all supported OSes where Vagrant and Virtualbox runs (Windows, OS X, Ubuntu).

### Follow these steps:

#### Install Virtualbox & Vagrant

Install Vagrant and Virtualbox if they are not available on your machine.

> Ubuntu example:
> ```
> sudo apt-get update 
> sudo apt-get -y install virtualbox vagrant
> ```

> Windows & OS X example:
>
> Install and download [Virtualbox](https://www.virtualbox.org) and [Vagrant](http://www.vagrantup.com) manually.

#### Get the source code

If you do not have git installed you can simply download and extract a ZIP file of the source  
https://github.com/PyBossa/pybossa-jujucharm/archive/master.zip and extract it.

Or you use git to clone it:
```
git clone https://github.com/PyBossa/pybossa-jujucharm.git
```

Go the source code folder
```
cd pybossa-jujucharm
```
 
#### Start the VM

This is very easy:
```
vagrant up
```

#### Setup Juju

SSH to the Vagrant box and **stay** in the VM
```
vagrant ssh
```

Prepare Juju for initial usage:
```
juju init
juju switch local
juju bootstrap
```
> Explanation of the commands:
> * Generate config files for Juju
> * Switch Juju to local usage (LXC)
> * Bootstrap Juju so that it is ready to use

### Juju GUI (optional)

```
juju deploy juju-gui
```

> This will setup a new Linux container (LXC) with its own network and resources.
> So you can say this will make a VM in a VM ;)

wait till juju-gui is deployed and you see a public IP (can take some time):
```
juju status
```
copy&paste the IP here:
```
sudo natgui 10.0.3.x
```
which will map the Juju-GUI to your localhost's port 8000. 

You can now view Juju-GUI in your browser:  
[https://localhost:8000](https://localhost:8000)

### PyBossa

Now we deploy PyBossa directly from git:
```
juju git-deploy github.com/PyBossa/pybossa-jujucharm
```

> You can watch progress of installation in detail (for debugging):
> ```
> tail -f /var/log/juju-vagrant-local/unit-pybossa-0.log
> ```

wait till pybossa is deployed and you see an public IP on
```
juju status
```
copy&paste the IP here:
```
sudo natpybossa 10.0.3.x
```
which will map the Juju-GUI to your localhost's port 7000.

You can now view PyBossa in your browser:  
[http://localhost:7000](http://localhost:7000)

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




### HAProxy (optional)

HAProxy is a load balancer and necessary once more than one running PyBossa
charm can connect to the DB (not supported yet).

Deploy HAProxy and connect it to the PyBossa instance.
Also expose it so that it is reachable from the outside.
```
juju deploy haproxy
juju add-relation haproxy pybossa
juju expose haproxy
```

Wait till HAProxy IP is visible:
```
juju status
```
copy&paste the IP here:
```
sudo natpybossa 10.0.3.x
```
which will map the HAProxy to your localhost's port 7001.  
You can now view HAProxy in front of PyBossa in your browser:  
[http://localhost:7001](http://localhost:7001)

## Email configuration

By default you don't need to setup an email server for PyBossa. However it's recommended. 

The current setup only uses a testing server, so you can see how it works. 

If you want to use email notifications, then configure an email server with all your running credentials (i.e. DKIM and SFP). You will need
to modify the DNS entries of you domain, so that's why this is not covered in this installation guide.


### sshuttle whole network mapping (optional)

This is an alternative for using the shell scripts used for NAT used above. You need to install sshuttle in Ubuntu with apt-get or in OS X with Homebrew.

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
