base:
  '*':
    - epel
    - git
    - docker

  'salt-master-*':
    - docker-salt-master

  'salt-minion-*':
    - docker-salt-minion
