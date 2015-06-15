pybossa-jujucharm
=================

Juju Charm for PyBossa

![PyBossa Charm](http://i.imgur.com/5cqgQRQ.jpg)

This is **alpha** software and currently only tested with LXC and Vagrant (Ubuntu 14.04)!

## Install instructions

* [Install PyBossa charm with Juju & Vagrant (Windows, OS X, Linux)](INSTALL-Vagrant-trusty.md)
* [Install PyBossa charm with local LXC container (Ubuntu only)](INSTALL-local-trusty.md)

## Known issues

* Master slave DBs are not yet supported in the charm

## Roadmap

We will duplicate our production environment which is visible on
[crowdcrafting.org](http://crowdcrafting.org) with HAProxy, Redis, PostgreSQL
and more than one PyBossa instance for instant production deployment based on
Juju and the cloud. More connections to other charms will follow!

PyBossa with PostgreSQL and HAProxy connection:

![Example of PostgreSQL,PyBossa,HAProxy](http://i.imgur.com/FqqX3bB.png)

## Copyright / License

Copyright 2014 SF Isle of Man Limited. 

Source Code License: The GNU Affero General Public License, either version 3 of the License
or (at your option) any later version. (see COPYING file)

The GNU Affero General Public License is a free, copyleft license for
software and other kinds of works, specifically designed to ensure
cooperation with the community in the case of network server software.

Documentation and media is under a Creative Commons Attribution License version
3.