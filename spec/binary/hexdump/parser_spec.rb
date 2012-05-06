require 'spec_helper'
require 'binary/hexdump/helpers/hexdumps'

require 'ronin/binary/hexdump/parser'

describe Binary::Hexdump::Parser do
  include Helpers

  context "GNU hexdump" do
    let(:ascii) { load_binary_data('ascii') }
    let(:repeated) { load_binary_data('repeated') }

    context "octal bytes" do
      subject do
        described_class.new(:format => :hexdump, :encoding => :octal_bytes)
      end

      let(:hexdump) { load_hexdump('hexdump_octal_bytes') }

      it "should unhexdump octal-byte hexdump output" do
        subject.parse(hexdump).should == ascii
      end
    end

    context " hex bytes" do
      subject do
        described_class.new(:format => :hexdump, :encoding => :hex_bytes)
      end

      let(:hexdump) { load_hexdump('hexdump_hex_bytes') }

      it "should unhexdump hex-byte hexdump output" do
        subject.parse(hexdump).should == ascii
      end
    end

    context "decimal shorts" do
      subject do
        described_class.new(:format => :hexdump, :encoding => :decimal_shorts)
      end

      let(:hexdump) { load_hexdump('hexdump_decimal_shorts') }

      it "should unhexdump decimal-short hexdump output" do
        subject.parse(hexdump).should == ascii
      end
    end

    context "octal shorts" do
      subject do
        described_class.new(:format => :hexdump, :encoding => :octal_shorts)
      end

      let(:hexdump) { load_hexdump('hexdump_octal_shorts') }

      it "should unhexdump octal-short hexdump output" do
        subject.parse(hexdump).should == ascii
      end
    end

    context "hex shorts" do
      subject do
        described_class.new(:format => :hexdump, :encoding => :hex_shorts)
      end

      let(:hexdump) { load_hexdump('hexdump_hex_shorts') }

      it "should unhexdump hex-short hexdump output" do
        subject.parse(hexdump).should == ascii
      end
    end

    context "repeated" do
      subject do
        described_class.new(:format => :hexdump, :encoding => :hex_bytes)
      end

      let(:hexdump) { load_hexdump('hexdump_repeated') }

      it "should unhexdump repeated hexdump output" do
        subject.parse(hexdump).should == repeated
      end
    end
  end

  context "od" do
    let(:ascii) { load_binary_data('ascii') }
    let(:repeated) { load_binary_data('repeated') }

    context "octal bytes" do
      subject do
        described_class.new(:format => :od, :encoding => :octal_bytes)
      end

      let(:hexdump) { load_hexdump('od_octal_bytes') }

      it "should unhexdump octal-byte hexdump output" do
        subject.parse(hexdump).should == ascii
      end
    end

    context "octal shorts" do
      subject do
        described_class.new(:format => :od, :encoding => :octal_shorts)
      end

      let(:hexdump) { load_hexdump('od_octal_shorts') }

      it "should unhexdump octal-shorts hexdump output" do
        subject.parse(hexdump).should == ascii
      end
    end

    context "octal ints" do
      subject do
        described_class.new(:format => :od, :encoding => :octal_ints)
      end

      let(:hexdump) { load_hexdump('od_octal_ints') }

      it "should unhexdump octal-ints hexdump output" do
        subject.parse(hexdump).should == ascii
      end
    end

    context "octal quads" do
      subject do
        described_class.new(:format => :od, :encoding => :octal_quads)
      end

      let(:hexdump) { load_hexdump('od_octal_quads') }

      it "should unhexdump octal-quads hexdump output" do
        subject.parse(hexdump).should == ascii
      end
    end

    context "decimal bytes" do
      subject do
        described_class.new(:format => :od, :encoding => :decimal_bytes)
      end

      let(:hexdump) { load_hexdump('od_decimal_bytes') }

      it "should unhexdump decimal-byte hexdump output" do
        subject.parse(hexdump).should == ascii
      end
    end

    context "decimal shorts" do
      subject do
        described_class.new(:format => :od, :encoding => :decimal_shorts)
      end

      let(:hexdump) { load_hexdump('od_decimal_shorts') }

      it "should unhexdump decimal-shorts hexdump output" do
        subject.parse(hexdump).should == ascii
      end
    end

    context "decimal ints" do
      subject do
        described_class.new(:format => :od, :encoding => :decimal_ints)
      end

      let(:hexdump) { load_hexdump('od_decimal_ints') }

      it "should unhexdump decimal-ints hexdump output" do
        subject.parse(hexdump).should == ascii
      end
    end

    context "decimal quads" do
      subject do
        described_class.new(:format => :od, :encoding => :decimal_quads)
      end

      let(:hexdump) { load_hexdump('od_decimal_quads') }

      it "should unhexdump decimal-quads hexdump output" do
        subject.parse(hexdump).should == ascii
      end
    end

    context "hex bytes" do
      subject do
        described_class.new(:format => :od, :encoding => :hex_bytes)
      end

      let(:hexdump) { load_hexdump('od_hex_bytes') }

      it "should unhexdump hex-byte hexdump output" do
        subject.parse(hexdump).should == ascii
      end
    end

    context "hex shorts" do
      subject do
        described_class.new(:format => :od, :encoding => :hex_shorts)
      end

      let(:hexdump) { load_hexdump('od_hex_shorts') }

      it "should unhexdump hex-shorts hexdump output" do
        subject.parse(hexdump).should == ascii
      end
    end

    context "hex ints" do
      subject do
        described_class.new(:format => :od, :encoding => :hex_ints)
      end

      let(:hexdump) { load_hexdump('od_hex_ints') }

      it "should unhexdump hex-ints hexdump output" do
        subject.parse(hexdump).should == ascii
      end
    end

    context "hex quads" do
      subject do
        described_class.new(:format => :od, :encoding => :hex_quads)
      end

      let(:hexdump) { load_hexdump('od_hex_quads') }

      it "should unhexdump hex-quads hexdump output" do
        subject.parse(hexdump).should == ascii
      end
    end

    context "repeated" do
      subject do
        described_class.new(:format => :od, :encoding => :octal_shorts)
      end

      let(:hexdump) { load_hexdump('od_repeated') }

      it "should unhexdump repeated hexdump output" do
        subject.parse(hexdump).should == repeated
      end
    end
  end
end
