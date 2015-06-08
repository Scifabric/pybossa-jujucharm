#!/bin/bash

set -ex

apt-get update -y
apt-get install -y git-core python3-pip libyaml-cpp0.3-dev
pip3 install juju-git-deploy

# https://jujucharms.com/docs/devel/config-vagrant
echo
echo Ubuntu Juju GUI password on http://127.0.0.1:6080
grep admin-secret: /home/vagrant/.juju/environments.yaml

echo "Finished Vagrant install!"