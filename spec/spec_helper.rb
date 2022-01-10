require 'rspec'
require 'simplecov'
require 'ronin/spec/cli/printing'
require 'ronin/support/version'

include Ronin

SimpleCov.start

RSpec.configure do |specs|
  specs.filter_run_excluding :network
end
