#!/bin/bash

set -ex

apt-get update -y
apt-get install -y git-core python3-pip libyaml-cpp0.3-dev
pip3 install juju-git-deploy
