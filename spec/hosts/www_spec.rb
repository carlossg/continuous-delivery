require 'spec_helper'

describe 'www.acme.com' do
  include_context :centos

  it { should_not contain_class('java') }
  it { should contain_package('httpd') }
  it { should contain_firewall('100 allow apache').with_action('accept') }
  it { should have_firewall_resource_count(2) } # avahi and apache
end
