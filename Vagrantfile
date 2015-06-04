# -*- mode: ruby -*-

# vi: set ft=ruby :

boxes = [
    {
        :name => "salt-master-01",
        :mem => "1024",
        :cpu => "1",
        :ip => "192.168.69.20"
    },
    {
        :name => "salt-master-02",
        :mem => "1024",
        :cpu => "1",
        :ip => "192.168.69.30"
    },
    {
        :name => "salt-minion-01",
        :mem => "1024",
        :cpu => "1",
        :ip => "192.168.69.40"
    }
]

Vagrant.configure(2) do |config|


  config.vm.box = "centos7-minimal-x86_64.box"
  config.vm.box_url = "https://f0fff3908f081cb6461b407be80daf97f07ac418.googledrive.com/host/0BwtuV7VyVTSkUG1PM3pCeDJ4dVE/centos7.box"

  # For masterless, mount your salt file root
  config.vm.synced_folder "salt/file", "/srv/salt"
  config.vm.synced_folder "salt/pillar", "/srv/pillar"

  boxes.each do |opts|
    config.vm.define opts[:name] do |config|
      config.vm.hostname = opts[:name]
      config.vm.network "private_network", ip: opts[:ip]

      config.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--memory", opts[:mem]]
        v.customize ["modifyvm", :id, "--cpus", opts[:cpu]]
      end

      # bootstrap allow Salt to manage docker
      config.vm.provision :shell, path: "bootstrap.sh"

      # provision with Salt
      config.vm.provision :salt do |salt|
        #salt.install_type = "git"
        salt.minion_config = "salt/minion"
        salt.run_highstate = true
      end



    end
  end
end
