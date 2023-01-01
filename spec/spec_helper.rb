require 'rspec'
require 'simplecov'
require 'ronin/support/version'

SimpleCov.start

ENV.delete('XDG_CACHE_HOME')
ENV.delete('XDG_CONFIG_HOME')
ENV.delete('XDG_DATA_HOME')

RSpec.configure do |specs|
  specs.filter_run_excluding :network
end
