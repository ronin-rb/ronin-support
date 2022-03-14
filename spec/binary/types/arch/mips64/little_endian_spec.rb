require 'spec_helper'
require 'ronin/support/binary/types/arch/mips64/little_endian'

describe Ronin::Support::Binary::Types::Arch::MIPS64::LittleEndian do
  it { expect(subject).to include(Ronin::Support::Binary::Types::LittleEndian) }
end
