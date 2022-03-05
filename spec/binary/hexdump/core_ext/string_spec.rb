require 'spec_helper'
require 'ronin/support/binary/hexdump/core_ext/string'

describe String do
  let(:fixtures_dir) { File.expand_path('../fixtures',__dir__)        }
  let(:hexdump_path) { File.join(fixtures_dir,'hexdump_hex_byte.txt') }
  let(:hexdump)      { File.read(hexdump_path) }

  subject { described_class.new(hexdump) }

  it "should provide String#unhexdump" do
    expect(subject).to respond_to(:unhexdump)
  end

  describe "#unhexdump" do
    let(:binary_path)  { File.join(fixtures_dir,'ascii.bin') }
    let(:raw_data)     { File.binread(binary_path) }

    it "should unhexdump a String" do
      expect(subject.unhexdump).to eq(raw_data)
    end
  end
end
