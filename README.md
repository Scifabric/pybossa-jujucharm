pybossa-jujucharm
=================

Juju Charm for PyBossa

![PyBossa Charm](http://i.imgur.com/5cqgQRQ.jpg)

This is **pre alpha** and currently only tested with Ubuntu 14.04 (local & Vagrant)!

## Install instructions

* [Install PyBossa charm with Juju & Vagrant (Windows, OS X, Linux)](INSTALL-Vagrant-trusty.md)
* [Install PyBossa charm with local LXC container (Ubuntu only)](INSTALL-local-trusty.md)

## TO DO:
- [x] Charm for Precise
- [x] Connect with HAProxy
- [ ] Submit charm to jujucharms.com when ready
- [x] Connect with PostgreSQL charm
- [ ] Connect with redis-master charm
- [x] Use nginx internally
- [x] Use supervisor for running pybossa
- [ ] Integrate PGPool

## Roadmap

We will duplicate our production environment which is visible on
[crowdcrafting.org](http://crowdcrafting.org) with HAProxy, Redis, PostgreSQL
and more than one PyBossa instance for instant production deployment based on
Juju and the cloud. More connections to other charms will follow!

PyBossa with PostgreSQL connection:

![Example of PostgreSQL and PyBossa](http://i.imgur.com/8Yb6Jfa.jpg)

## Copyright / License

Copyright 2014 SF Isle of Man Limited. 

Source Code License: The GNU Affero General Public License, either version 3 of the License
or (at your option) any later version. (see COPYING file)

The GNU Affero General Public License is a free, copyleft license for
software and other kinds of works, specifically designed to ensure
cooperation with the community in the case of network server software.

Documentation and media is under a Creative Commons Attribution License version
3.