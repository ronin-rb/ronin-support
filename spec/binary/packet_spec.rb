require 'spec_helper'
require 'ronin/support/binary/packet'

describe Ronin::Support::Binary::Packet do
  subject { described_class }

  it "must set .type_system to Ronin::Support::Binary::CTypes::Network" do
    expect(subject.type_system).to be(Ronin::Support::Binary::CTypes::Network)
  end

  it "must set .alignment to 1" do
    expect(subject.alignment).to eq(1)
  end

  it "must set .padding to false" do
    expect(subject.padding).to be(false)
  end
end
