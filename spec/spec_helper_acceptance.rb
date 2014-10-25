# Beaker workaround for Docker https://github.com/swipely/docker-api/issues/202
require 'docker'
require 'beaker/hypervisor'

module Beaker
  class Docker < Beaker::Hypervisor
    def initialize(hosts, options)
      require 'docker'
      @options = options
      @logger = options[:logger]
      @hosts = hosts

      # increase the http timeouts as provisioning images can be slow
      ::Docker.options[:write_timeout] ||= 300
      ::Docker.options[:read_timeout] ||= 300
      # assert that the docker-api gem can talk to your docker
      # enpoint.  Will raise if there is a version mismatch
      ::Docker.validate_version!
      # Pass on all the logging from docker-api to the beaker logger instance
      ::Docker.logger = @logger
    end
  end
end

ENV['DOCKER_HOST'] = ENV['DOCKER_HOST'].gsub(%r{tcp://}, 'https://')
cert_path = File.expand_path ENV['DOCKER_CERT_PATH']
Docker.options = {
  :client_cert => File.join(cert_path, 'cert.pem'),
  :client_key => File.join(cert_path, 'key.pem'),
  :ssl_ca_file => File.join(cert_path, 'ca.pem'),
  :ssl_verify_peer => false,
  :ssl_version => :TLSv1_2
}

# End workaround


require 'puppet'
require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'


RSpec.configure do |c|

  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.before(:each) do
    Puppet::Util::Log.level = :warning
    Puppet::Util::Log.newdestination(:console)
  end

  c.before :suite do
    hosts.each do |host|
      unless (ENV['RS_PROVISION'] == 'no' || ENV['BEAKER_provision'] == 'no')
        begin
          on host, 'puppet --version'
        rescue
          if host.is_pe?
            install_pe
          else
            install_puppet
          end
        end
      end

      # Install module and dependencies
      on host, puppet('module','install','puppetlabs-java', '--version', '1.0.1')
      on host, puppet('module','install','camptocamp-tomcat', '--version', '0.7.1')
      on host, puppet('module','install','maestrodev-maven', '--version', '1.1.7')
      puppet_module_install(:source => File.join(proj_root,'mymodules','acme'), :module_name => 'acme')
    end
  end

end
