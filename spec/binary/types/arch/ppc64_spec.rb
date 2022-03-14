require 'spec_helper'
require 'ronin/support/binary/types/arch/ppc64'

describe Ronin::Support::Binary::Types::Arch::PPC64 do
  it { expect(subject).to include(Ronin::Support::Binary::Types::BigEndian) }
end
