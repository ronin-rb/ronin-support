require 'spec_helper'
require 'ronin/support/binary/types/os/unix'
require 'ronin/support/binary/types/arch/x86'
require 'ronin/support/binary/types/arch/x86_64'

require_relative 'unix_examples'

describe Ronin::Support::Binary::Types::OS::UNIX do
  context "when initialized with a 32bit Types module" do
    let(:types) { Ronin::Support::Binary::Types::Arch::X86 }

    subject { described_class.new(types) }

    include_context "common UNIX types"
  end

  context "when initialized with a 64bit Types module" do
    let(:types) { Ronin::Support::Binary::Types::Arch::X86_64 }

    subject { described_class.new(types) }

    include_context "common UNIX types"
  end
end
