require 'pry'

module Puppet::SimpleResource
  class TypeShim
    attr_reader :values

    def initialize(resource_hash)
      @values = resource_hash.dup.freeze # whatevs
    end

    def to_resource
      ResourceShim.new(@values)
    end

    def name
      values[:name]
    end
  end

  class ResourceShim
    attr_reader :values

    def initialize(resource_hash)
      @values = resource_hash.dup.freeze # whatevs
    end

    def title
      values[:name]
    end

    def prune_parameters(*args)
      puts "not pruning #{args.inspect}" if args.length > 0
      self
    end

    def to_manifest
      [
          "api { #{values[:name]}: ",
      ] + values.keys.select { |k| k != :name }.collect { |k| "#{k} => #{values[k]}," } + ['}']
    end
  end
end

Puppet::Type.newtype(:api) do
  @doc = 'This is an example type for the new Resource API'

  newparam(:name) do
    desc 'The primary key of this resource'

    isnamevar
  end

  newparam(:some_bool) do
    desc 'Test a boolean param'
    defaultto :false

    newvalues(:true, :false)
  end

  newproperty(:some_number) do
    desc 'test a numeric property'

    newvalue /\d/ do
    end

    munge do |v|
      # required for framework to catch onto string/numeric equality
      v.to_i
    end
  end

  def self.get
    puts 'get'
    [{
         name:        'foo',
         some_bool:   true,
         some_number: 1,
     },
     {
         name:        'bar',
         some_bool:   false,
         some_number: 3,
     }]
  end

  def self.set(current_state, target_state, noop=false)
    puts "setting #{target_state} onto #{current_state} (noop=#{noop})"
  end

  def self.instances
    puts 'instances'
    # klass = Puppet::Type.type(:api)
    get.collect do |resource_hash|
      Puppet::SimpleResource::TypeShim.new(resource_hash)
    end
  end

  def retrieve
    puts 'retrieve'
    result        = Puppet::Resource.new(self.class, title)
    current_state = self.class.get.first { |resource_hash| resource_hash[:name] == title }

    current_state.each do |k, v|
      result[k]=v
    end

    @rapi_current_state = current_state
    result
  end

  def flush
    puts 'flush'
    # binding.pry
    target_state = Hash[@parameters.collect { |k, v| [k, v.value] }]
    self.class.set([@rapi_current_state], [target_state], false)
  end
end
