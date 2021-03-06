# PyBossa

Juju Charm for PyBossa.

PyBossa is a free, 100% open-source framework for crowdsourcing. It enables you
to create and run projects where volunteers help you with image classification,
transcription, geocoding and more. PyBossa lets researchers, civic hackers
and developers connect with people all around the world to solve problems faster
and more efficiently. Embrace the power of the crowd!

# Usage

Install PyBossa charm:
```
juju deploy pybossa
```

## PostgreSQL

Install the PostgreSQL charm and connect PyBossa with the database:
```
juju deploy postgresql
juju add-relation pybossa postgresql:db-admin
```

## Redis and Sentinel

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


## HAProxy

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

## Scale out Usage

Scaling of PyBossa is in this first version not supported.

## Known Limitations and Issues

* Redis is currently used inside the charm. The official Redis charm will be used on a later version. Main reason is the usage of Sentinel service.
* Master slave DBs not yet supported.

# Configuration

There is no configuration needed at this time.

# Contact Information

## Charm source code

Charm source code is maintained mainly on GitHub: [PyBossa Charm](https://github.com/PyBossa/pybossa-jujucharm)

Every release will be pushed to the Juju charm store.

Report any bug, issue or improvement here: [GitHub Charm issues](https://github.com/PyBossa/pybossa-jujucharm/issues)

## PyBossa itself

### [PyBossa webpage](http://pybossa.com)

You can read more about the architecture in the [PyBossa Documentation](http://docs.pybossa.com/en/latest/overview.html) and follow the [step-by-step tutorial to create your own projects](http://docs.pybossa.com/en/latest/build_with_pybossa.html).

For more info, send us an e-mail to: info@pybossa.com or follow us on [Twitter](https://twitter.com/pybossa)!

Report any bug, issue or improvement: [PyBossa GitHub Issues](https://github.com/PyBossa/pybossa/issue)

