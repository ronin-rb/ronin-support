require 'spec_helper'
require 'ronin/support/binary/types/arch/arm64/big_endian'

describe Ronin::Support::Binary::Types::Arch::ARM64::BigEndian do
  it { expect(subject).to include(Ronin::Support::Binary::Types::BigEndian) }
end
