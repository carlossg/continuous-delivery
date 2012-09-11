require 'spec_helper'

describe 'www.acme.com' do
  let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'CentOS', :operatingsystemrelease => 6.3} }

  it { should_not contain_class('java') }
  it { should contain_package('httpd') }
end
