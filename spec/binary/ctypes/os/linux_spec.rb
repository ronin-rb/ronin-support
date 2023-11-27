require 'spec_helper'
require 'ronin/support/binary/ctypes/os/linux'
require 'ronin/support/binary/ctypes/arch/x86'
require 'ronin/support/binary/ctypes/arch/x86_64'

require_relative 'linux_examples'

describe Ronin::Support::Binary::CTypes::OS::Linux do
  it { expect(described_class).to be < Ronin::Support::Binary::CTypes::OS::UNIX }

  context "when initialized with a 32bit Types module" do
    let(:types) { Ronin::Support::Binary::CTypes::Arch::X86 }

    subject { described_class.new(types) }

    include_examples "32bit GNU/Linux types"
  end

  context "when initialized with a 64bit Types module" do
    let(:types) { Ronin::Support::Binary::CTypes::Arch::X86_64 }

    subject { described_class.new(types) }

    include_examples "64bit GNU/Linux types"
  end
end
