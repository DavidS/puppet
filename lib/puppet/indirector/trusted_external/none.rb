require 'puppet/trusted_external'
require 'puppet/indirector/none'

class Puppet::TrustedExternal::None < Puppet::Indirector::None
  desc "Always return an empty Hash. This is a placeholder to make the default configuration a noop."

  # Just return an empty hash.
  def find(request)
    {}
  end
end
