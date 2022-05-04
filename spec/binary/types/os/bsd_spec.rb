require 'spec_helper'
require 'ronin/support/binary/types/os/bsd'
require 'ronin/support/binary/types/arch/x86'
require 'ronin/support/binary/types/arch/x86_64'

require_relative 'bsd_examples'

describe Ronin::Support::Binary::Types::OS::BSD do
  context "when initialized with a 32bit Types module" do
    let(:types) { Ronin::Support::Binary::Types::Arch::X86 }

    subject { described_class.new(types) }

    include_context "common BSD types"
  end

  context "when initialized with a 64bit Types module" do
    let(:types) { Ronin::Support::Binary::Types::Arch::X86_64 }

    subject { described_class.new(types) }

    include_context "common BSD types"
  end
end
