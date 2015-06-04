base:
  '*':
    - epel
    - docker

  'salt-master-*':
    - docker-salt-master

  'salt-minion-*':
    - docker-salt-minion
