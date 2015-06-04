# git clone the minion docker container
docker-salt-minion:
  git.latest:
    - name: https://github.com/dkiser/docker-salt-minion.git
    - target: /tmp/docker-salt-minion
    - require:
        - pkg: git

# build the minion docker container
dkiser/salt-minion:
  docker.built:
    - path: /tmp/docker-salt-minion
    - require:
      - git: docker-salt-minion


# blow out any previous data containers
dkiser/salt-minion-data-absent:
  docker.absent:
    - name: dkiser/salt-minion-data

# build the data container image for the salt minion
dkiser/salt-minion-data:
  docker.built:
    - path: /vagrant/salt-minion-data
    - require:
      - docker: dkiser/salt-minion-data-absent

# install the data container for use
salt-minion-data:
  docker.installed:
    - image: dkiser/salt-minion-data

# run minion with volumes from shared volume container
salt-minion:
  docker.running:
    - image: dkiser/salt-minion
    - volumes_from:
      - salt-minion-data
    - environment:
      - LOG_LEVEL: debug
