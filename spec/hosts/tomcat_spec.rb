require 'spec_helper'

describe 'tomcat1.acme.com' do
  let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'CentOS', :lsbmajdistrelease => 6} }

  it { should contain_class('java').with_distribution /openjdk/ }
end
