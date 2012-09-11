require 'rspec-puppet'

RSpec.configure do |c|
   c.module_path = 'modules'
   c.manifest_dir = 'manifests'
end

# Fix for Puppet::Error: invalid byte sequence in US-ASCII at modules/tomcat/manifests/connector.pp:1 on node tomcat1.acme.com

if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end
