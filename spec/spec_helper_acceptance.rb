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


require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
