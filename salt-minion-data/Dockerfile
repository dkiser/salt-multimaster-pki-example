# Salt Minion data container

FROM centos:centos7

MAINTAINER Domingo Kiser domingo.kiser@gmail.com

RUN echo "create salt user and directories" \
    && groupadd -r salt \
    && useradd  -r -g salt salt \
    && mkdir -p /etc/salt/minion.d /etc/salt/pki /var/cache/salt /var/logs/salt /srv/salt \
    && chown -R salt:salt /etc/salt /var/cache/salt /var/logs/salt /srv/salt

# setup /home/salt's ssh folder
RUN mkdir -p /home/salt/.ssh \
  && chown salt:salt /home/salt/.ssh \
  && chmod 700 /home/salt/.ssh

# Add minion config
ADD minion /etc/salt/minion
RUN chown salt:salt /etc/salt/minion

# Add master_sign pub key file for multi-master pki
ADD master_sign.pub /etc/salt/pki/minion/master_sign.pub
RUN chown -R salt:salt /etc/salt/pki/minion \
  && chmod 644 /etc/salt/pki/minion/master_sign.pub

# Volumes used in our main Salt Minion container
VOLUME ["/home/salt", "/etc/salt", "/etc/salt/pki", "/var/cache/salt", "/var/logs/salt", "/etc/salt/minion.d", "/srv/salt"]

USER salt

CMD ["echo", "Data container for dkiser/docker-salt-minion"]
