require 'spec_helper'

describe 'www.acme.com' do
  let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'CentOS', :lsbmajdistrelease => 6} }

  it { should_not contain_class('java') }
  it { should contain_package('httpd') }
end
