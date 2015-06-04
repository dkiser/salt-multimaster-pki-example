# salt-multimaster-pki-example

Example using [dkiser/salt-master](https://github.com/dkiser/docker-salt-master.git) and [dkiser/salt-minion](https://github.com/dkiser/docker-salt-master.git) to show a Multi Master Salt setup with 2 Salt masters and 1 Salt minion where the masters are configured for [multi-master pki failover](http://docs.saltstack.com/en/latest/topics/tutorials/multimaster_pki.html).  In this Multi-Master topology, the minions connect to the first master, and then fail over to the 2nd.

## Requirements

* [Vagrant](https://www.vagrantup.com)

## Topology

Vagrant VM's are used to create the following topology.  The Vagrant Salt provisioner is used to bootstrap all of the boxes.

* ```salt-master-01``` - VM with dkiser/salt-master container
* ```salt-master-02``` - VM with dkiser/salt-master container
* ```salt-minion-01``` - VM with dkiser/salt-minion configured for the 2 masters in failover mode

## Directory Structure

* [Vagrantfile](./Vagrantfile) - Used to bootstrap all the VM's
* [bootstrap.sh](./Vagrantfile) - Shell provisioner to make sure the Vagrant Salt provisioner can handle managing docker
* [salt](./salt) - root dir for Vagrant salt provisioner
* [salt/file](./salt/file) - All salt states used to build the various VM's.
* [salt-master-data](./salt/) - Docker data only container for use with [dkiser/salt-master](https://github.com/dkiser/docker-salt-master.git)
* [salt-minion-data](./salt/) - Docker data only container for use with [dkiser/salt-minion](https://github.com/dkiser/docker-salt-minion.git)


## Steps

1. Clone this repo
```bash
$ git clone https://github.com/dkiser/salt-multimaster-pki-example.git
```

2. CD to the example
```bash
$ cd salt-multimaster-pki-example
```

3. ```vagrant up``` to build the demo - GRAB SOME COFFEE!
```bash
vagrant up
```

4. SSH to salt-master-01 and enter the salt-master container
```bash
$ vagrant ssh salt-master-01 -c 'sudo docker exec -it salt-master /bin/bash'
```

5. Test salt connectivity from salt-master-01
```bash
$ salt '*' test.ping
ee8017fc97f2:
    True
```

6. SSH to salt-master-02 and enter the salt-master container
```bash
$ vagrant ssh salt-master-02 -c 'sudo docker exec -it salt-master /bin/bash'
```

7. Test salt connectivity from salt-master-02
```bash
$ salt '*' test.ping
ee8017fc97f2:
    True
```

8. SSH to minion container and tail the logs of the minion container
```bash
$ vagrant ssh salt-minion-01 -c 'sudo docker logs -f salt-minion'
```

9. Bring down the salt-master-01 docker container
```bash
$ vagrant ssh salt-master-01 -c 'sudo docker stop salt-master'
```

7. Verify the salt-minion fails over as expected by noticing the following in the minion tail'd logs (wait 30 seconds, as we set in the minion config)
```bash
$ vagrant ssh salt-minion-01 -c 'sudo docker logs -f salt-minion'
[INFO    ] Master 192.168.69.20 could not be reached, trying next master (if any)
[WARNING ] Master ip address changed from 192.168.69.20 to 192.168.69.30
[DEBUG   ] Attempting to authenticate with the Salt Master at 192.168.69.30
[DEBUG   ] Initializing new SAuth for ('/etc/salt/pki/minion', 'ee8017fc97f2', 'tcp://192.168.69.30:4506')
[DEBUG   ] salt.crypt.verify_signature: Loading public key
[DEBUG   ] salt.crypt.verify_signature: Verifying signature
[DEBUG   ] Successfully verified signature of master public key with verification public key master_sign.pub
[INFO    ] Received signed and verified master pubkey from master 192.168.69.30
```


## Having vboxfs mount problems?

> Do following if you have vboxfs mount problems (and give it a few minutes)

```bash
for host in salt-master-01 salt-master-02 salt-minion-01; do
  vagrant up $host;
  vagrant ssh $host -c 'sudo /etc/init.d/vboxadd setup';
  vagrant reload $host;
done
```
