require 'spec_helper'
require 'ronin/support/encoding/core_ext/string'

describe String do
  subject { "hello" }

  it "must provide String#encode_chars" do
    expect(subject).to respond_to(:encode_chars)
  end

  it "must provide String#encode_bytes" do
    expect(subject).to respond_to(:encode_bytes)
  end

  it "must provide String#escape" do
    expect(subject).to respond_to(:escape)
  end

  it "must provide String#unescape" do
    expect(subject).to respond_to(:unescape)
  end

  describe "#encode_bytes" do
    it "must format each byte in the String" do
      expect(subject.encode_bytes { |b|
        sprintf("%%%x",b)
      }).to eq("%68%65%6c%6c%6f")
    end

    it "must format specific bytes in a String" do
      expect(subject.encode_bytes(include: [104, 108]) { |b|
        b - 32
      }).to eq('HeLLo')
    end

    it "must not format specific bytes in a String" do
      expect(subject.encode_bytes(exclude: [101, 111]) { |b|
        b - 32
      }).to eq('HeLLo')
    end

    it "must format ranges of bytes in a String" do
      expect(subject.encode_bytes(include: (104..108)) { |b|
        b - 32
      }).to eq('HeLLo')
    end

    it "must not format ranges of bytes in a String" do
      expect(subject.encode_bytes(exclude: (104..108)) { |b|
        b - 32
      }).to eq('hEllO')
    end
  end

  describe "#encode_chars" do
    it "must format each character in the String" do
      expect(subject.encode_chars { |c|
        "#{c}."
      }).to eq("h.e.l.l.o.")
    end

    it "must format specific chars in a String" do
      expect(subject.encode_chars(include: ['h', 'l']) { |c|
        c.upcase
      }).to eq('HeLLo')
    end

    it "must not format specific chars in a String" do
      expect(subject.encode_chars(exclude: ['h', 'l']) { |c|
        c.upcase
      }).to eq('hEllO')
    end
  end

  describe "#unescape" do
    it "must not unescape a normal String" do
      expect("hello".unescape).to eq("hello")
    end

    context "when the String contains escaped hexadecimal characters" do
      subject { "\\x68\\x65\\x6c\\x6c\\x6f\\x4e" }

      let(:unescaped) { "hello\x4e" }

      it "must unescape a hex String" do
        expect(subject.unescape).to eq(unescaped)
      end
    end

    context "when the String contains escaped unicode characters" do
      subject { "\\u00D8\\u2070E" }

      let(:unescaped) { "Ø𠜎" }

      it "must unescape the hexadecimal characters" do
        expect(subject.unescape).to eq(unescaped)
      end
    end

    context "when the String contains single character escaped octal characters" do
      subject { "\\0\\1\\2\\3\\4\\5\\6\\7" }

      let(:unescaped) { "\0\1\2\3\4\5\6\7" }

      it "must unescape the octal characters" do
        expect(subject.unescape).to eq(unescaped)
      end
    end

    context "when the String contains two character escaped octal characters" do
      subject { "\\10\\11\\12\\13\\14\\15\\16\\17\\20" }

      let(:unescaped) { "\10\11\12\13\14\15\16\17\20" }

      it "must unescape the octal characters" do
        expect(subject.unescape).to eq(unescaped)
      end
    end

    context "when the String contains escaped octal characters" do
      subject { "\\150\\145\\154\\154\\157\\040\\167\\157\\162\\154\\144" }

      let(:unescaped) { "hello world" }

      it "must unescape the octal characters" do
        expect(subject.unescape).to eq(unescaped)
      end
    end

    context "when the String contains escaped special characters" do
      subject { "hello\\0world\\n" }

      let(:unescaped) { "hello\0world\n" }

      it "must unescape C special characters" do
        expect(subject.unescape).to eq(unescaped)
      end
    end

    context "when the String contains escaped regular characters" do
      subject { "hell\\o" }

      let(:unescaped) { "hello" }

      it "must unescape normal characters" do
        expect(subject.unescape).to eq(unescaped)
      end
    end
  end

  describe "#unquote" do
    context "when the String is double-quoted" do
      subject { "\"hello\\nworld\"" }

      let(:unescaped) { "hello\nworld" }

      it "must remove double-quotes and unescape the string" do
        expect(subject.unquote).to eq(unescaped)
      end
    end

    context "when the String is single-quoted" do
      subject { "'hello\\'world'" }

      let(:unescaped) { "hello'world" }

      it "must remove single-quotes and unescape any backslash single-quotes" do
        expect(subject.unquote).to eq(unescaped)
      end
    end

    context "when the String is not quoted" do
      subject { "hello world" }

      it "must return the same String" do
        expect(subject.unquote).to be(subject)
      end
    end
  end
end
