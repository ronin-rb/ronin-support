require 'spec_helper'
require 'ronin/support/network/domain'

describe Ronin::Support::Network::Domain do
  it "must inherit from Ronin::Support::Network::Host" do
    expect(described_class).to be < Ronin::Support::Network::Host
  end
end
