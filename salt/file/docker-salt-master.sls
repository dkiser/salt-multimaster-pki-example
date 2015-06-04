
# make sure git is installed
git:
  pkg.installed

docker-py:
  pkg.installed:
    - name: python-pip
  pip.installed:
    - require:
      - pkg: python-pip

# upgrade six, cause centos reasons ;(
# https://github.com/saltstack/salt/issues/15803
six:
  pip.installed:
    - upgrade: True
    - require:
      - pkg: python-pip


# git clone the master docker container
docker-salt-master:
  git.latest:
    - name: https://github.com/dkiser/docker-salt-master.git
    - target: /tmp/docker-salt-master
    - require:
        - pkg: git

# build the master docker container
dkiser/salt-master:
  docker.built:
    - path: /tmp/docker-salt-master
    - require:
      - git: docker-salt-master


# blow out any previous data containers
dkiser/salt-master-data-absent:
  docker.absent:
    - name: dkiser/salt-master-data

# build the data container image for the salt master
dkiser/salt-master-data:
  docker.built:
    - path: /vagrant/salt-master-data
    - require:
      - docker: dkiser/salt-master-data-absent

# install the data container for use
salt-master-data:
  docker.installed:
    - image: dkiser/salt-master-data

# run master with volumes from shared volume container
salt-master:
  docker.running:
    - image: dkiser/salt-master
    - volumes_from:
      - salt-master-data
    - environment:
      - LOG_LEVEL: debug
    - ports:
      - "4505/tcp":
          HostIp: ""
          HostPort: "4505"
      - "4506/tcp":
          HostIp: ""
          HostPort: "4506"
