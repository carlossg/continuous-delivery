# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "CentOS-6.3-x86_64-minimal"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "https://dl.dropbox.com/u/7225008/Vagrant/CentOS-6.3-x86_64-minimal.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  # config.vm.network :hostonly, "192.168.33.10"

  # Assign this VM to a bridged network, allowing you to connect directly to a
  # network using the host's network device. This makes the VM appear as another
  # physical device on your network.
  # config.vm.network :bridged

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  # config.vm.forward_port 80, 8080

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"

  #config.vm.customize ["modifyvm", :id, "--memory", 4096]
  config.vm.customize ["modifyvm", :id, "--rtcuseutc", "on"] # use UTC clock https://github.com/mitchellh/vagrant/issues/912

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file vagrant.pp in the manifests_path directory.
  #
  # An example Puppet manifest to provision the message of the day:
  #
  # # group { "puppet":
  # #   ensure => "present",
  # # }
  # #
  # # File { owner => 0, group => 0, mode => 0644 }
  # #
  # # file { '/etc/motd':
  # #   content => "Welcome to your Vagrant-built virtual machine!
  # #               Managed by Puppet.\n"
  # # }
  #
  # config.vm.provision :puppet do |puppet|
  #   puppet.manifests_path = "manifests"
  #   puppet.manifest_file  = "vagrant.pp"
  # end

  # ssh may take some extra time, increase timeout or avoid network dns resolution
  config.ssh.timeout = 20
  config.vm.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]

  # qa server
  config.vm.define :qa do |config|
    config.vm.host_name = "qa.acme.local"
    config.vm.customize ["modifyvm", :id, "--name", "qa"] # name for VirtualBox GUI
    config.vm.forward_port 5432, 9432
    config.vm.forward_port 8080, 9081
    config.vm.forward_port 80, 9080
    config.vm.network :hostonly, "192.168.33.13"
    config.vm.provision :puppet do |puppet|
      puppet.module_path = "modules"
      puppet.manifest_file = "site.pp"
    end
  end


  # db server
  config.vm.define :db do |config|
    config.vm.host_name = "db.acme.local"
    config.vm.customize ["modifyvm", :id, "--name", "db"] # name for VirtualBox GUI
    config.vm.forward_port 5432, 15432
    config.vm.network :hostonly, "192.168.33.10"
    config.vm.provision :puppet do |puppet|
      puppet.module_path = "modules"
      puppet.manifest_file = "site.pp"
    end
  end

  # tomcat server
  config.vm.define :tomcat1 do |config|
    config.vm.host_name = "tomcat1.acme.local"
    config.vm.customize ["modifyvm", :id, "--name", "tomcat1"] # name for VirtualBox GUI
    config.vm.forward_port 8080, 18080
    config.vm.network :hostonly, "192.168.33.11"
    config.vm.provision :puppet do |puppet|
      puppet.module_path = "modules"
      puppet.manifest_file = "site.pp"
    end
  end

  # web server
  config.vm.define :www do |config|
    config.vm.host_name = "www.acme.local"
    config.vm.customize ["modifyvm", :id, "--name", "www"] # name for VirtualBox GUI
    config.vm.forward_port 80, 10080
    config.vm.network :hostonly, "192.168.33.12"
    config.vm.provision :puppet do |puppet|
      puppet.module_path = "modules"
      puppet.manifest_file = "site.pp"
    end
  end

end
