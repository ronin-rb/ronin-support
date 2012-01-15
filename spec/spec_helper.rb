require 'rspec'
require 'ronin/support/version'

include Ronin

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run_excluding :network
end
