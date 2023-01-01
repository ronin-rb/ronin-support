require 'spec_helper'
require 'ronin/support/network/packet'

describe Ronin::Support::Network::Packet do
  subject { described_class }

  it { expect(subject).to be(Ronin::Support::Binary::Packet) }
end
