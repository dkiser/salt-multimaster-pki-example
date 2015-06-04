docker:
  pkg.installed

docker-py:
  pkg.installed:
    - name: python-pip
  pip.installed:
    - reload_modules: True
    - require:
      - pkg: python-pip

docker-service:
  service.running:
    - name: docker
    - enable: True
