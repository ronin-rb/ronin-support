require 'spec_helper'
require 'ronin/support/binary/types/arch/arm64'

describe Ronin::Support::Binary::Types::Arch::ARM64 do
  it { expect(subject).to include(Ronin::Support::Binary::Types::LittleEndian) }
end
