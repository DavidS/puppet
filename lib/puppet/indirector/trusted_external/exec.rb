require 'puppet/trusted_external'
require 'puppet/indirector/exec'
require 'json'

class Puppet::TrustedExternal::Exec < Puppet::Indirector::Exec
  desc "Call an external program to get extended trusted facts information."
  include Puppet::Util

  def command
    command = Puppet[:trusted_external_command]
    raise ArgumentError, _("You must set the 'trusted_external_command' parameter to use the extended trusted facts terminus") unless command != "none"
    command.split
  end

  # unpack JSON output
  def find(request)
    JSON.parse(super)
  end
end
