# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "kmaster01" do |controlplane|
    controlplane.vm.box = "ubuntu/jammy64"
    controlplane.vm.hostname = "kmaster01" 
    controlplane.vm.network "private_network", ip: "192.168.56.10"
    controlplane.vm.synced_folder "partage", "/home/vagrant/partage"
    controlplane.vm.synced_folder "wordpress", "/home/vagrant/wordpress"
    controlplane.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
      vb.name = "kmaster01"
    end
    controlplane.vm.provision "shell", path: "setup-hosts.sh"
    controlplane.vm.provision "shell", path: "install-master.sh"
  end

  (1..2).each do |i|
    config.vm.define "knode0#{i}" do |node|
      node.vm.box = "ubuntu/jammy64"
      node.vm.hostname = "knode0#{i}"
      node.vm.network "private_network", ip: "192.168.56.1#{i}"
      node.vm.synced_folder "partage", "/home/vagrant/partage"
      node.vm.provider "virtualbox" do |vb|
        vb.memory = 2048
        vb.cpus = 2
        vb.name = "knode0#{i}"
      end
      node.vm.provision "shell", path: "setup-hosts.sh"
      node.vm.provision "shell", path: "install-worker.sh" 
    end  
  end  

end 