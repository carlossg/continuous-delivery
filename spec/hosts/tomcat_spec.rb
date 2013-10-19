require 'spec_helper'

describe 'tomcat1.acme.com' do
  include_context :centos

  it { should contain_package('java').with_name('java-1.7.0-openjdk-devel') }

  it "configure webapp" do
    should contain_maven('/srv/tomcat/appfuse/webapps/ROOT.war')
    should contain_maven('/srv/tomcat/appfuse/webapps/ROOT/WEB-INF/lib/postgresql-9.1-901.jdbc4.jar')
  end
end
