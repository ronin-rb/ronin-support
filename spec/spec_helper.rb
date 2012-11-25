require 'rspec'
require 'ronin/spec/ui/printing'
require 'ronin/support/version'

include Ronin

RSpec.configure do |specs|
  specs.treat_symbols_as_metadata_keys_with_true_values = true
  specs.filter_run_excluding :network
end
