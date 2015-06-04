# Salt Master data container

FROM centos:centos7

MAINTAINER Domingo Kiser domingo.kiser@gmail.com

RUN echo "create salt user and directories" \
    && groupadd -r salt \
    && useradd  -r -g salt salt \
    && mkdir -p /etc/salt/master.d /etc/salt/pki /var/cache/salt /var/logs/salt /srv/salt \
    && chown -R salt:salt /etc/salt /var/cache/salt /var/logs/salt /srv/salt

# setup /home/salt's ssh folder
RUN mkdir -p /home/salt/.ssh \
  && chown salt:salt /home/salt/.ssh \
  && chmod 700 /home/salt/.ssh
  
# Add master config
ADD master /etc/salt/master
RUN chown salt:salt /etc/salt/master

# Add master_sign key file
ADD master_sign.pem /etc/salt/pki/master/master_sign.pem
ADD master_sign.pub /etc/salt/pki/master/master_sign.pub
RUN chown -R salt:salt /etc/salt/pki/master \
  && chmod 600 /etc/salt/pki/master/master_sign.pem \
  && chmod 644 /etc/salt/pki/master/master_sign.pub

# Volumes used in our main Salt Master container
VOLUME ["/home/salt", "/etc/salt", "/etc/salt/pki", "/var/cache/salt", "/var/logs/salt", "/etc/salt/master.d", "/srv/salt"]

USER salt

CMD ["echo", "Data container for dkiser/docker-salt-master"]
