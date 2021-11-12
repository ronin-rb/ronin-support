require 'rspec'
require 'simplecov'
SimpleCov.start

require 'ronin/support/version'

include Ronin

RSpec.configure do |specs|
  specs.filter_run_excluding :network
end
