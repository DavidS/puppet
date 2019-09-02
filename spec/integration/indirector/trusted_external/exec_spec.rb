require 'spec_helper'
require 'puppet_spec/files'
require 'puppet_spec/compiler'
require 'puppet/indirector/trusted_external/exec'

describe Puppet::TrustedExternal::Exec do
  include PuppetSpec::Files
  include PuppetSpec::Compiler

  context "with a trusted_external_command configured" do
    let(:script_path) do
      script_containing('script',
        windows: "@echo '{ \"fact\": \"ABCD\" }'"
        posix: "#!/bin/bash\necho '{ \"fact\": \"ABCD\" }'"
      )
    end

    before(:each) do
      # Ignore spec context which injects pre-baked :trusted_information
      Puppet.pop_context
    end

    it "loads script output into $trusted['external']" do
      Puppet.initialize_settings([
        '--trusted_external_terminus',
        'exec',
        '--trusted_external_command',
        script_path,
        '--trace',
        ])

      apply = Puppet::Application.find(:apply).new(double('command_line', :subcommand_name => :apply, :args => [ '-e', 'notify { $trusted[external][fact]: }' ]))

      expect do
        expect { apply.run }.to exit_with(0)
      end.to have_printed('ABCD')
    end
  end
end
