require 'spec_helper'
require 'ronin/support/binary/cstring'

describe Ronin::Support::Binary::CString do
  describe "#initialize" do
    context "when given a String" do
      subject { described_class.new(string) }

      context "and the String contains a '\\0' byte" do
        let(:string) { "hello\0" }

        it "must set the #string to the given String as is" do
          expect(subject.string).to eq(string)
        end
      end

      context "but the String does not contain a '\\0' byte" do
        let(:string) { "hello" }

        it "must appends a '\\0' character to the #string" do
          expect(subject.string).to eq("#{string}\0")
        end
      end
    end

    context "when given an Array" do
    end

    context "when given no arguments" do
      subject { described_class.new() }

      it "must initialize #string to \"\\0\"" do
        expect(subject.string).to eq("\0")
      end
    end
  end

  describe ".[]" do
    context "of characters" do
      let(:chars) { %w[a b c] }

      subject { described_class[*chars] }

      it "must append each character to #string with a '\\0' byte at the end" do
        expect(subject.string).to eq("#{chars.join}\0")
      end
    end

    context "of bytes" do
      let(:bytes) { [0x41, 0x42, 0x43] }
      let(:chars) { bytes.map(&:chr)   }

      subject { described_class[*bytes] }

      it "must append each byte to #string with a '\\0' byte at the end" do
        expect(subject.string).to eq("#{chars.join}\0")
      end
    end

    context "when given no arguments" do
      subject { described_class[] }

      it "must initialize #string to \"\\0\"" do
        expect(subject.string).to eq("\0")
      end
    end
  end

  let(:string) { "hello" }

  subject { described_class.new(string) }

  describe "#concat" do
    before { subject.concat(string) }

    context "when the CString is empty" do
      subject { described_class.new }

      it "must add the String to the front of the #string" do
        expect(subject.string).to start_with(string)
      end

      it "must append a '\\0' byte at the end" do
        expect(subject.string).to eq("#{string}\0")
      end
    end

    context "when the CString is not empty" do
      let(:initial_string) { "ABC" }

      subject { described_class.new(initial_string) }

      it "must append the String to the end of the #string" do
        expect(subject.string).to start_with("#{initial_string}#{string}")
      end

      it "must also append a '\\0' byte at the end" do
        expect(subject.string).to end_with("#{string}\0")
      end

      context "but the CString contains multiple '\\0' bytes" do
        let(:initial_string) { "ABC\0XXXXXXXX" }

        it "must insert the String at the first '\\0' byte and overwrite the subsequent bytes" do
          expect(subject.string).to eq("ABC#{string}\0XXX")
        end
      end
    end
  end

  describe "#+" do
    let(:initial_string) { "ABC" }

    subject { described_class.new(initial_string) }

    context "when given a String" do
      let(:other) { "hello" }

      it "must return a new #{described_class}" do
        expect(subject + other).to be_kind_of(described_class)
      end

      it "must concat the CString's contents with the other String" do
        expect((subject + other).string).to eq("#{subject}#{other}\0")
      end

      it "must not modify the original CString" do
        subject + other

        expect(subject.string).to eq("ABC\0")
      end
    end

    context "when given a CString" do
      let(:other) { described_class.new("hello") }

      it "must return a new #{described_class}" do
        expect(subject + other).to be_kind_of(described_class)
      end

      it "must concat the CString's contents with the other CString's contents" do
        expect((subject + other).string).to eq("#{subject}#{other.to_s}\0")
      end

      it "must not modify the original CString" do
        subject + other

        expect(subject.string).to eq("ABC\0")
      end
    end

    context "when given an Integer" do
      it "must return a ByteSlice" do
        expect(subject + 1).to be_kind_of(Ronin::Support::Binary::ByteSlice)
      end
    end
  end

  describe "#each_byte" do
    it "must yield each byte within the CString" do
      expect { |b|
        subject.each_byte(&b)
      }.to yield_successive_args(*string.bytes)
    end

    context "when the CString contains multiple '\\0' bytes" do
      let(:string) { "ABC\0XYZ\0" }

      it "must yield each byte before the first '\\0' byte" do
        expect { |b|
          subject.each_byte(&b)
        }.to yield_successive_args(0x41, 0x42, 0x43)
      end
    end
  end

  describe "#bytes" do
    it "must return the bytes within the CString" do
      expect(subject.bytes).to eq(string.bytes)
    end

    context "when the CString contains multiple '\\0' bytes" do
      let(:string) { "ABC\0XYZ\0" }

      it "must return the bytes before the first '\\0' byte" do
        expect(subject.bytes).to eq([0x41, 0x42, 0x43])
      end
    end
  end

  describe "#each_char" do
    it "must yield each character within the CString" do
      expect { |b|
        subject.each_char(&b)
      }.to yield_successive_args(*string.chars)
    end

    context "when the CString contains multiple '\\0' bytes" do
      let(:string) { "ABC\0XYZ\0" }

      it "must yield each character before the first '\\0' byte" do
        expect { |b|
          subject.each_char(&b)
        }.to yield_successive_args('A', 'B', 'C')
      end
    end
  end

  describe "#chars" do
    it "must return the characters within the CString" do
      expect(subject.chars).to eq(string.chars)
    end

    context "when the CString contains multiple '\\0' bytes" do
      let(:string) { "ABC\0XYZ\0" }

      it "must return the characters before the first '\\0' byte" do
        expect(subject.chars).to eq(%w[A B C ])
      end
    end
  end

  describe "#index" do
    let(:string) { "hello hello" }

    subject { described_class.new(string) }

    it "must find the index of the first occurrance of the substring within the CString" do
      expect(subject.index("lo")).to eq(3)
    end

    context "when the substring cannot be found within the CString" do
      it "must return nil" do
        expect(subject.index("XXX")).to be(nil)
      end
    end

    context "when the CString contains multiple '\\0' bytes" do
      let(:string) { "hello\0world\0" }

      it "must stop searching once the first '\\0' byte is encountered" do
        expect(subject.index("world")).to be(nil)
      end
    end
  end

  describe "#length" do
    it "must return the number of characters within the CString" do
      expect(subject.length).to eq(string.length)
    end

    context "when the CString contains multiple '\\0' bytes" do
      let(:string) { "hello\0world\0" }

      it "must return the number of characters before the first '\\0' byte" do
        expect(subject.length).to eq(string.index("\0"))
      end
    end
  end

  describe "#to_s" do
    it "must return the String within CString" do
      expect(subject.to_s).to eq(string)
    end

    context "when the CString contains multiple '\\0' bytes" do
      let(:string) { "hello\0world\0" }

      it "must return the String before the first '\\0' byte" do
        expect(subject.to_s).to eq(string[0,string.index("\0")])
      end
    end
  end
end
