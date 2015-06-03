# salt-multimaster-pki-example
Example using dkiser/salt-master and dkiser/salt-minion to show multimaster poi

# Steps

1. CD to some directory in /Users
cd ~

2. Clone this repo
https://github.com/dkiser/salt-multimaster-pki-example.git

3. Clone and build dkiser containers

4. data container for salt-master-01
docker run -it --name salt-master-data-01 ~/salt-multimaster-pki-example/master-data-01/etc/salt:/etc/salt -v ~/salt-multimaster-pki-example/master-data-01/etc/salt/pki:/etc/salt/pki busybox /bin/true

5. data container for salt-master-02
docker run -it --name salt-master-data-02 ~/salt-multimaster-pki-example/master-data-02/etc/salt:/etc/salt -v ~/salt-multimaster-pki-example/master-data-02/etc/salt/pki:/etc/salt/pki busybox /bin/true

6. data container for salt-minion
docker run -it --name salt-minion-data ~/salt-multimaster-pki-example/minion-data/etc/salt:/etc/salt -v ~/salt-multimaster-pki-example/etc/salt/pki:/etc/salt/pki busybox /bin/true

7. start salt-master-01
docker run -d --name salt-master-01 --volumes-from salt-master-data-01 -e LOG_LEVEL=debug -p 4505:4505 -p 4506:4506 dkiser/salt-master

8. start salt-master-02
docker run -d --name salt-master-02 --volumes-from salt-master-data-02 -e LOG_LEVEL=debug -p 4507:4505 -p 4508:4506 dkiser/salt-master

9. start salt-minion
docker run -d --name salt-minion --volumes-from salt-minion-data -e LOG_LEVEL=debug dkiser/salt-minion

# TODO
* figure out a way to either use same ip/multiple ports or use vagrants to get more IP's for this demo (e.g. 2 ip's needed for 2 salt masters?)  (doesn't seem to be a way to configure ip/port on a per multi master setup, but only port globally as part of minion config)
