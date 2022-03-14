require 'spec_helper'
require 'ronin/support/binary/types/arch/mips64'

describe Ronin::Support::Binary::Types::Arch::MIPS64 do
  it { expect(subject).to include(Ronin::Support::Binary::Types::BigEndian) }
end
