require 'spec_helper'

describe 'db.acme.com' do
  include_context :centos

  it { should_not contain_class('java') }
  it { should contain_class('postgresql::server') }
end
