require 'spec_helper'

describe 'www.acme.com' do
  include_context :centos

  it { should_not contain_class('java') }
  it { should contain_package('httpd') }
end
