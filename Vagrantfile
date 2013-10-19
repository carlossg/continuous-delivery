# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "CentOS-6.4-x86_64-minimal"
  config.vm.box_url = "https://repo.maestrodev.com/archiva/repository/public-releases/com/maestrodev/vagrant/CentOS/6.4/CentOS-6.4-x86_64-minimal.box"

  # cache rpms in host
  config.vm.provision :shell, :inline => "sed -i 's/keepcache=0/keepcache=1/' /etc/yum.conf"
  yum = File.expand_path(File.join(__FILE__, "..", ".yum"))
  File.exists?(yum) or Dir.mkdir(yum)
  config.vm.synced_folder yum, "/var/cache/yum", :owner => "root", :group => "root"

  # ssh may take some extra time, increase timeout or avoid network dns resolution
  config.ssh.timeout = 20
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
