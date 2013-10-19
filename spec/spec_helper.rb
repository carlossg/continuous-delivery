require 'rspec-puppet'

RSpec.configure do |c|
   c.module_path = 'modules'
   c.manifest_dir = 'manifests'
end

shared_context :centos do

  let(:facts) {{
    :operatingsystem => 'CentOS',
    :kernel => 'Linux',
    :osfamily => 'RedHat',
    :operatingsystemrelease => '6.3',
    :lsbmajdistrelease => '6',
    :operatingsystemmajrelease => '6',
    :postgres_default_version => '8.4',
    :concat_basedir => 'tmp/concat'
  }}

end
