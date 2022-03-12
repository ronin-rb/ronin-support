require 'spec_helper'
require 'ronin/support/binary/types/network'

describe "Ronin::Support::Binary::Types::Network" do
  subject { Ronin::Support::Binary::Types::Network }

  it { expect(subject).to be(Ronin::Support::Binary::Types::BigEndian) }
end
