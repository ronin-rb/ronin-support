require 'spec_helper'
require 'ronin/support/binary/ctypes/os/apple_ios'
require 'ronin/support/binary/ctypes/arch/x86'
require 'ronin/support/binary/ctypes/arch/x86_64'

require_relative 'bsd_examples'

describe Ronin::Support::Binary::CTypes::OS::AppleIOS do
  context "when initialized with a 32bit Types module" do
    let(:types) { Ronin::Support::Binary::CTypes::Arch::X86 }

    subject { described_class.new(types) }

    include_context "common BSD types"
  end

  context "when initialized with a 64bit Types module" do
    let(:types) { Ronin::Support::Binary::CTypes::Arch::X86_64 }

    subject { described_class.new(types) }

    include_context "common BSD types"
  end
end
