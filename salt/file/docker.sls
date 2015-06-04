docker:
  pkg.installed

docker-service:
  service.running:
    - name: docker
    - enable: True
    - watch:
      - pip: six
