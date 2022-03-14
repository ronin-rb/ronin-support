require 'spec_helper'
require 'ronin/support/binary/types/arch/x86_64'

describe Ronin::Support::Binary::Types::Arch::X86_64 do
  it { expect(subject).to include(Ronin::Support::Binary::Types::LittleEndian) }
end
