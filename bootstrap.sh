#!/usr/bin/env bash

# Install docker-python so when Vagrant
# installs salt as part of the Salt provisioner
# it can manage docker
yum -y install epel-release
yum -y install docker-python

# Vagrant Salt provisioner handles the rest!
