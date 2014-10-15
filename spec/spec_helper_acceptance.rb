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
