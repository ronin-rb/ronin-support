require 'spec_helper'
require 'matchers/fully_match'
require 'ronin/support/text/patterns/numeric'

describe Ronin::Support::Text::Patterns do
  describe "NUMBER" do
    subject { described_class::NUMBER }

    let(:number) { '0123456789' }

    it "must match one or more digits" do
      expect(number).to fully_match(subject)
    end

    it "must match negative numbers" do
      expect("-#{number}").to fully_match(subject)
    end

    it "must match numbers with an 'e' exponent suffix" do
      expect("1e10").to fully_match(subject)
    end

    it "must match numbers with an 'e+' exponent suffix" do
      expect("1e+10").to fully_match(subject)
    end

    it "must match numbers with an 'e-' exponent suffix" do
      expect("1e-10").to fully_match(subject)
    end
  end

  describe "FLOAT" do
    subject { described_class::FLOAT }

    it "must match 0.5" do
      expect('0.5').to fully_match(subject)
    end

    it "must match 0.1234" do
      expect('0.1234').to fully_match(subject)
    end

    it "must match 1234.0" do
      expect('1234.0').to fully_match(subject)
    end

    it "must match 1234.5678" do
      expect('1234.5678').to fully_match(subject)
    end

    it "must match 1.0e10" do
      expect('1.0e10').to fully_match(subject)
    end

    it "must match 1.0e+10" do
      expect('1.0e+10').to fully_match(subject)
    end

    it "must match 1.0e-10" do
      expect('1.0e-10').to fully_match(subject)
    end

    it "must match negative numbers" do
      expect("-1.234").to fully_match(subject)
    end
  end

  describe "OCTAL_BYTE" do
    subject { described_class::OCTAL_BYTE }

    it "must match 0 - 377" do
      numbers = (0..255).map { |byte| byte.to_s(8) }

      expect(numbers).to all(match(subject))
    end

    it "must not match numbers greater than 377" do
      expect('378').to_not match(subject)
    end
  end

  describe "DECIMAL_BYTE" do
    subject { described_class::DECIMAL_BYTE }

    it "must match 0 - 255" do
      numbers = (0..255).map(&:to_s)

      expect(numbers).to all(match(subject))
    end

    it "must not match numbers greater than 255" do
      expect('256').to_not match(subject)
    end
  end

  describe "DECIMAL_OCTET" do
    subject { described_class::DECIMAL_OCTET }

    it "must be an alias for DECIMAL_BYTE" do
      expect(subject).to be(described_class::DECIMAL_BYTE)
    end
  end

  describe "HEX_BYTE" do
    subject { described_class::HEX_BYTE }

    it "must match 00 - ff" do
      hex_bytes = (0..0xff).map { |byte| "%.2x" % byte }

      expect(hex_bytes).to all(match(subject))
    end

    it "must match 00 - FF" do
      hex_bytes = (0..0xff).map { |byte| "%.2X" % byte }

      expect(hex_bytes).to all(match(subject))
    end

    it "must match 0x00 - 0xff" do
      hex_bytes = (0..0xff).map { |byte| "0x%.2x" % byte }

      expect(hex_bytes).to all(match(subject))
    end

    it "must match 0x00 - 0xFF" do
      hex_bytes = (0..0xff).map { |byte| "0x%.2X" % byte }

      expect(hex_bytes).to all(match(subject))
    end

    it "must only match two hexadecimal digits" do
      string = "a1b2"

      expect(string[subject]).to eq("a1")
    end
  end

  describe "HEX_WORD" do
    subject { described_class::HEX_WORD }

    it "must match 0000 - ffff" do
      expect("0000").to match(subject)
      expect("ffff").to match(subject)
    end

    it "must match 0000 - FFFF" do
      expect("0000").to match(subject)
      expect("FFFF").to match(subject)
    end

    it "must match 0x0000 - 0xffff" do
      expect("0x0000").to match(subject)
      expect("0xffff").to match(subject)
    end

    it "must match 0x0000 - 0xFFFF" do
      expect("0x0000").to match(subject)
      expect("0xFFFF").to match(subject)
    end

    it "must only match four hexadecimal digits" do
      string = "a1b2c3"

      expect(string[subject]).to eq("a1b2")
    end
  end

  describe "HEX_DWORD" do
    subject { described_class::HEX_DWORD }

    it "must match 00000000 - ffffffff" do
      expect("00000000").to match(subject)
      expect("ffffffff").to match(subject)
    end

    it "must match 00000000 - FFFFFFFF" do
      expect("00000000").to match(subject)
      expect("FFFFFFFF").to match(subject)
    end

    it "must match 0x00000000 - 0xffffffff" do
      expect("0x00000000").to match(subject)
      expect("0xffffffff").to match(subject)
    end

    it "must match 0x00000000 - 0xFFFFFFFF" do
      expect("0x00000000").to match(subject)
      expect("0xFFFFFFFF").to match(subject)
    end

    it "must only match eight hexadecimal digits" do
      string = "1234abcdefg"

      expect(string[subject]).to eq("1234abcd")
    end
  end

  describe "HEX_QWORD" do
    subject { described_class::HEX_QWORD }

    it "must match 0000000000000000 - ffffffffffffffff" do
      expect("0000000000000000").to match(subject)
      expect("ffffffffffffffff").to match(subject)
    end

    it "must match 0000000000000000 - FFFFFFFFFFFFFFFF" do
      expect("0000000000000000").to match(subject)
      expect("FFFFFFFFFFFFFFFF").to match(subject)
    end

    it "must match 0x0000000000000000 - 0xffffffffffffffff" do
      expect("0x0000000000000000").to match(subject)
      expect("0xffffffffffffffff").to match(subject)
    end

    it "must match 0x0000000000000000 - 0xFFFFFFFFFFFFFFFF" do
      expect("0x0000000000000000").to match(subject)
      expect("0xFFFFFFFFFFFFFFFF").to match(subject)
    end

    it "must only match eight hexadecimal digits" do
      string = "1234567890abcdef11111"

      expect(string[subject]).to eq("1234567890abcdef")
    end
  end

  describe "HEX_NUMBER" do
    subject { described_class::HEX_NUMBER }

    it "must match one or more decimal digits" do
      number = "0123456789"

      expect(number).to fully_match(subject)
    end

    it "must match one or more lowercase hexadecimal digits" do
      hex = "0123456789abcdef"

      expect(hex).to fully_match(subject)
    end

    it "must match one or more uppercase hexadecimal digits" do
      hex = "0123456789ABCDEF"

      expect(hex).to fully_match(subject)
    end

    context "when the number begins with '0x'" do
      it "must match one or more decimal digits" do
        number = "0x0123456789"

        expect(number).to fully_match(subject)
      end

      it "must match one or more lowercase hexadecimal digits" do
        hex = "0x0123456789abcdef"

        expect(hex).to fully_match(subject)
      end

      it "must match one or more uppercase hexadecimal digits" do
        hex = "0x0123456789ABCDEF"

        expect(hex).to fully_match(subject)
      end
    end
  end
end
