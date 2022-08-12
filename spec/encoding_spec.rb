require 'spec_helper'
require 'ronin/support/encoding'

describe Ronin::Support::Encoding do
  it "must sub-class ::Encoding" do
    expect(described_class).to be < ::Encoding
  end
end
