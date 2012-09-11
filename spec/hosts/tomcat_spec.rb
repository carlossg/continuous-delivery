require 'spec_helper'

describe 'tomcat1.acme.com' do
  let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'CentOS', :lsbmajdistrelease => 6} }

  it { should contain_class('java').with_distribution /openjdk/ }

  it "configure webapp" do
    should contain_maven('/srv/tomcat/appfuse/webapps/ROOT.war')
    should contain_maven('/srv/tomcat/appfuse/webapps/ROOT/WEB-INF/lib/postgresql-9.1-901.jdbc4.jar')
  end
end
