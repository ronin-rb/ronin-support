require 'spec_helper'
require 'ronin/support/binary/hexdump/core_ext/file'

describe File do
  let(:fixtures_dir) { File.expand_path('../fixtures',__dir__)        }
  let(:hexdump_path) { File.join(fixtures_dir,'hexdump_hex_byte.txt') }

  it "must provide File#unhexdump" do
    expect(described_class).to respond_to(:unhexdump)
  end

  describe ".unhexdump" do
    subject { described_class }

    let(:binary_path)  { File.join(fixtures_dir,'ascii.bin') }
    let(:raw_data)     { File.binread(binary_path) }

    it "must unhexdump a String" do
      expect(subject.unhexdump(hexdump_path)).to eq(raw_data)
    end
  end
end
