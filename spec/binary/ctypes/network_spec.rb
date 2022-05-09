require 'spec_helper'
require 'ronin/support/binary/ctypes/network'

describe "Ronin::Support::Binary::CTypes::Network" do
  subject { Ronin::Support::Binary::CTypes::Network }

  it { expect(subject).to be(Ronin::Support::Binary::CTypes::BigEndian) }
end
