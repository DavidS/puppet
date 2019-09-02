require 'spec_helper'

require 'puppet/indirector/trusted_external/exec'
require 'puppet/indirector/request'

describe Puppet::TrustedExternal::Exec do
  let(:indirection) { mock 'indirection' }

  describe "when constructing the command to run" do
    it "uses the trusted_external_command script as the command" do
      Puppet[:trusted_external_command] = "/bin/echo"
      expect(subject.command).to eq(%w{/bin/echo})
    end

    it "should throw an exception if no trusted_external_command command is set" do
      Puppet[:trusted_external_command] = "none"
      expect { subject.command }.to raise_error(ArgumentError, /You must set the 'trusted_external_command' parameter/)
    end
  end

  describe "when handling the results of the command" do
    let(:request) { Puppet::Indirector::Request.new(:trusted_ext, :find, 'node_name', {}) }
    let(:output) { JSON.generate({foo: "foo value", bar: "bar value"})}
    let(:result) { subject.find(request) }

    before do
      allow(Puppet::Util::Execution).to receive(:execute).with(['/bin/echo', 'node_name'], anything).and_return(output)
      allow(Puppet::Util).to receive(:absolute_path?).with('/bin/echo').and_return(true)
      Puppet[:trusted_external_command] = "/bin/echo"
    end

    it "parses the JSON" do
      expect(result['foo']).to eq('foo value')
      expect(result['bar']).to eq('bar value')
    end

    context 'when the script returns invalid JSON' do
      let(:output) { '{' }
      it do
        expect {
          subject.find(request)
        }.to raise_error(JSON::ParserError)
      end
    end
  end
end
