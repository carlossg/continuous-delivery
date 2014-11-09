require 'spec_helper_acceptance'

describe 'webapp' do

  describe port(8080),
    :node => only_host_with_role(hosts, :webapp) do

    before do
      # wait for tomcat to start
      shell('while ! grep "Starting ProtocolHandler" /tomcat/logs/* > /dev/null; do echo Waiting for tomcat; sleep 2; done')
    end

    it { should be_listening }
  end

end
