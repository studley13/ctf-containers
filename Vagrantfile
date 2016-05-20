# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

    # Base on Precise Pangolin amd64
    config.vm.box = "ubuntu/trusty64"

    # Set up the provisioning script
    config.vm.provision "shell", inline: "cd /vagrant; ./setup.sh"

    # Set up the 4 boxes
    config.vm.define "box1" do |box1|
        box1.vm.network "private_network", ip: "172.31.169.24"
    end
    config.vm.define "box2" do |box2|
        box2.vm.network "private_network", ip: "172.31.169.26"
    end
    config.vm.define "box3" do |box3|
        box3.vm.network "private_network", ip: "172.31.169.28"
    end
    config.vm.define "box4" do |box4|
        box4.vm.network "private_network", ip: "172.31.169.30"
    end

    # Set up the machine details
    config.vm.provider "virtualbox" do |vb|
        # Display the VirtualBox GUI when booting the machine
        # vb.gui = true
        # Customize the amount of memory on the VM:
        vb.memory = 512
        vb.cpus   = 2
    end
end
