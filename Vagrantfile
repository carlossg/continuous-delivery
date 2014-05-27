# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "centos-65-x64-virtualbox-puppet"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-puppet.box"

  # redhat-lsb-core needed for lsb* facts in tomcat module
  config.vm.provision :shell, :inline => "yum install -y redhat-lsb-core"

  # ssh may take some extra time, avoid network dns resolution
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  # qa server
  config.vm.define :qa do |config|
    config.vm.hostname = "qa.acme.local"
    config.vm.network "forwarded_port", guest: 5432, host: 9432
    config.vm.network "forwarded_port", guest: 8080, host: 9081
    config.vm.network "forwarded_port", guest: 80, host: 9080
    config.vm.network "private_network", ip: "192.168.33.13"
  end


  # db server
  config.vm.define :db do |config|
    config.vm.hostname = "db.acme.local"
    config.vm.network "forwarded_port", guest: 5432, host: 15432
    config.vm.network "private_network", ip: "192.168.33.10"
  end

  # tomcat server
  config.vm.define :tomcat1 do |config|
    config.vm.hostname = "tomcat1.acme.local"
    config.vm.network "forwarded_port", guest: 8080, host: 18080
    config.vm.network "private_network", ip: "192.168.33.11"
  end

  # web server
  config.vm.define :www do |config|
    config.vm.hostname = "www.acme.local"
    config.vm.network "forwarded_port", guest: 80, host: 10080
    config.vm.network "private_network", ip: "192.168.33.12"
  end

  config.vm.provision :puppet do |puppet|
    puppet.module_path = "modules"
    puppet.manifest_file = "site.pp"
  end

end
