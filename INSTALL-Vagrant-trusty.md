## Testing PyBossa charm with Vagrant (Windows, OS X, Linux)

With this guide you can test the PyBossa Juju charm inside a Virtualbox VM.

### Follow this steps:

#### Install Virtualbox & Vagrant

> Ubuntu example:
> ```
> sudo apt-get update 
> sudo apt-get -y install virtualbox vagrant
> ```

> Windows & OS X example:
>
> Install and download [Virtualbox](https://www.virtualbox.org) and [Vagrant](http://www.vagrantup.com) manually.

#### Get the source code

If you have not git installed you can simply download and extract a ZIP file of the source `https://github.com/PyBossa/pybossa-jujucharm/archive/master.zip` and extract it.

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
> What do this juju commands do?
> * Generate config files for Juju
> * Switch Juju to local usage (LXC)
> * Bootstrap Juju so that it is ready to use

#### Setup Juju GUI (optional)

```
juju deploy juju-gui
```

wait till juju-gui is deployed by Juju (can take some time):
```
juju status
```
copy&paste the ip and setup IP Routing (NAT) with this command:
```
sudo ./natgui.sh 10.0.3.x
```
which will map the Juju-GUI to your localhost's port 8000.  
You can now view Juju-GUI in your browser:  
[https://localhost:8000](https://localhost:8000)

#### Setup PyBossa

We need git clone the PyBossa repo inside the VM with
```
git clone https://github.com/PyBossa/pybossa-jujucharm.git
cd pybossa-jujucharm
```
and deploy it with juju:
```
juju deploy local:trusty/pybossa
cd ..
```

> You can watch progress of installation in detail (for debugging):
> ```
> tail -f /var/log/juju-vagrant-local/unit-pybossa-0.log
> ```

wait till pybossa is deployed and you see an public ip on
```
juju status
```
copy&paste the ip and setup IP Routing (NAT) with this command:
```
sudo ./natpybossa.sh 10.0.3.x
```
which will map the Juju-GUI to your localhost's port 7000.  
You can now view PyBossa in your browser:  
[https://localhost:7000](https://localhost:7000) 

### PostgreSQL

Install the PostgreSQL charm and connect PyBossa with the database:
```
juju deploy postgresql
juju add-relation pybossa postgresql:db-admin
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
copy&paste the ip and setup IP Routing (NAT) with this command:
```
sudo ./natpybossa.sh 10.0.3.x
```
which will map the HAProxy to your localhost's port 7001.  
You can now view HAProxy in front of PyBossa in your browser:  
[https://localhost:7001](https://localhost:7001)

### sshuttle whole network mapping (optional)

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