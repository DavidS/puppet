require 'puppet/indirector'

# A class for managing external trusted facts
class Puppet::TrustedExternal
  # Set up indirection, so that external trusted facts can be loaded
  extend Puppet::Indirector

  indirects :trusted_external, :terminus_setting => :trusted_external_terminus, :doc => "Where to find node external trusted facts."
end
