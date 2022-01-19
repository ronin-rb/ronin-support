require 'spec_helper'
require 'binary/hexdump/helpers/hexdumps'

require 'ronin/support/binary/hexdump/parser'

shared_examples_for "hexdump format" do |format,encoding|
  encoding_name = encoding.to_s.gsub('_','-')

  context encoding_name do
    subject do
      described_class.new(format: format, encoding: encoding)
    end

    let(:hexdump) { load_hexdump("#{format}_#{encoding}") }
    let(:ascii) { load_binary_data('ascii') }

    it "should unhexdump #{encoding_name} hexdump output" do
      expect(subject.parse(hexdump)).to eq(ascii)
    end
  end
end

describe Binary::Hexdump::Parser do
  include Helpers

  context "GNU hexdump" do
    include_context "hexdump format", :hexdump, :octal_bytes
    include_context "hexdump format", :hexdump, :hex_bytes
    include_context "hexdump format", :hexdump, :decimal_shorts
    include_context "hexdump format", :hexdump, :octal_shorts
    include_context "hexdump format", :hexdump, :hex_shorts

    context "repeated" do
      subject do
        described_class.new(format: :hexdump, encoding: :hex_bytes)
      end

      let(:hexdump)  { load_hexdump('hexdump_repeated') }
      let(:repeated) { load_binary_data('repeated')     }

      it "should unhexdump repeated hexdump output" do
        expect(subject.parse(hexdump)).to eq(repeated)
      end
    end
  end

  context "od" do
    let(:ascii) { load_binary_data('ascii') }

    include_context "hexdump format", :od, :octal_bytes
    include_context "hexdump format", :od, :octal_shorts
    include_context "hexdump format", :od, :octal_ints
    include_context "hexdump format", :od, :octal_quads
    include_context "hexdump format", :od, :decimal_bytes
    include_context "hexdump format", :od, :decimal_shorts
    include_context "hexdump format", :od, :decimal_ints
    include_context "hexdump format", :od, :decimal_quads
    include_context "hexdump format", :od, :hex_bytes
    include_context "hexdump format", :od, :hex_shorts
    include_context "hexdump format", :od, :hex_ints
    include_context "hexdump format", :od, :hex_quads

    context "named chars" do
      subject do
        described_class.new(format: :od, encoding: :named_chars)
      end

      let(:mask)    { ~(1 << 7) }
      let(:data)    { ascii.bytes.map { |b| (b & mask).chr }.join }
      let(:hexdump) { load_hexdump('od_named_chars') }

      it "should unhexdump named characters" do
        expect(subject.parse(hexdump)).to eq(data)
      end
    end

    context "floats" do
      subject do
        described_class.new(format: :od, encoding: :floats)
      end

      let(:data) do
        data = ascii.dup
        data[-4..-1] = ("\0" * 4)
        data
      end

      let(:hexdump) { load_hexdump('od_floats') }

      it "should unhexdump floats" do
        expect(subject.parse(hexdump)).to eq(data)
      end
    end

    context "doubles" do
      subject do
        described_class.new(format: :od, encoding: :doubles)
      end

      let(:data) do
        data = ascii.dup
        data[-8..-1] = ("\0" * 8)
        data
      end

      let(:hexdump) { load_hexdump('od_doubles') }

      it "should unhexdump doubles" do
        expect(subject.parse(hexdump)).to eq(data)
      end
    end

    context "repeated" do
      subject do
        described_class.new(format: :od, encoding: :octal_shorts)
      end

      let(:hexdump)  { load_hexdump('od_repeated')  }
      let(:repeated) { load_binary_data('repeated') }

      it "should unhexdump repeated hexdump output" do
        expect(subject.parse(hexdump)).to eq(repeated)
      end
    end
  end
end
