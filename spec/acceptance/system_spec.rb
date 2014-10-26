require 'spec_helper_acceptance'

describe 'wget' do

  let(:manifest) { %Q(
    Exec {
      path => ['/bin', '/usr/bin'],
    }
  ) }

  before do
    # shell "rm -f /tmp/index*"
  end

  context 'when installing in tomcat' do
    let(:manifest) { super() + %Q(
        class { 'acme::tomcat_node':
          appfuse_version => '2.2.1'
        }
      )
    }

    it 'should be idempotent' do
      apply_manifest(manifest, :catch_failures => true)
      apply_manifest(manifest, :catch_changes => true)
      shell('test -e /tmp/index.html')
    end
  end

end
