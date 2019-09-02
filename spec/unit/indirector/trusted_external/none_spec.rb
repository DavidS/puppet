require 'spec_helper'

require 'puppet/indirector/trusted_external/none'

describe Puppet::TrustedExternal::None do
  describe '#find(request)' do
    it { expect(subject.find(nil)).to eq({}) }
  end
end
