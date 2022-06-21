require 'spec_helper'
require 'ronin/support/format/text/core_ext/string'

describe String do
  subject { "hello" }

  it "must provide String#format_chars" do
    expect(subject).to respond_to(:format_chars)
  end

  it "must provide String#format_bytes" do
    expect(subject).to respond_to(:format_bytes)
  end

  it "must provide String#random_case" do
    expect(subject).to respond_to(:random_case)
  end

  it "must provide String#insert_before" do
    expect(subject).to respond_to(:insert_before)
  end

  it "must provide String#insert_after" do
    expect(subject).to respond_to(:insert_after)
  end

  it "must provide String#escape" do
    expect(subject).to respond_to(:escape)
  end

  it "must provide String#unescape" do
    expect(subject).to respond_to(:unescape)
  end

  describe "#format_bytes" do
    it "must format each byte in the String" do
      expect(subject.format_bytes { |b|
        sprintf("%%%x",b)
      }).to eq("%68%65%6c%6c%6f")
    end

    it "must format specific bytes in a String" do
      expect(subject.format_bytes(include: [104, 108]) { |b|
        b - 32
      }).to eq('HeLLo')
    end

    it "must not format specific bytes in a String" do
      expect(subject.format_bytes(exclude: [101, 111]) { |b|
        b - 32
      }).to eq('HeLLo')
    end

    it "must format ranges of bytes in a String" do
      expect(subject.format_bytes(include: (104..108)) { |b|
        b - 32
      }).to eq('HeLLo')
    end

    it "must not format ranges of bytes in a String" do
      expect(subject.format_bytes(exclude: (104..108)) { |b|
        b - 32
      }).to eq('hEllO')
    end
  end

  describe "#format_chars" do
    it "must format each character in the String" do
      expect(subject.format_chars { |c|
        "#{c}."
      }).to eq("h.e.l.l.o.")
    end

    it "must format specific chars in a String" do
      expect(subject.format_chars(include: ['h', 'l']) { |c|
        c.upcase
      }).to eq('HeLLo')
    end

    it "must not format specific chars in a String" do
      expect(subject.format_chars(exclude: ['h', 'l']) { |c|
        c.upcase
      }).to eq('hEllO')
    end
  end

  describe "#random_case" do
    it "must capitalize each character when :probability is 1.0" do
      new_string = subject.random_case(probability: 1.0)

      expect(subject.upcase).to eq(new_string)
    end

    it "must not capitalize any characters when :probability is 0.0" do
      new_string = subject.random_case(probability: 0.0)

      expect(subject).to eq(new_string)
    end
  end

  describe "#insert_before" do
    it "must inject data before a matched String" do
      expect(subject.insert_before('ll','x')).to eq("hexllo")
    end

    it "must inject data before a matched Regexp" do
      expect(subject.insert_before(/l+/,'x')).to eq("hexllo")
    end

    it "must not inject data if no matches are found" do
      expect(subject.insert_before(/x/,'x')).to eq(subject)
    end
  end

  describe "#insert_after" do
    it "must inject data after a matched String" do
      expect(subject.insert_after('ll','x')).to eq("hellxo")
    end

    it "must inject data after a matched Regexp" do
      expect(subject.insert_after(/l+/,'x')).to eq("hellxo")
    end

    it "must not inject data if no matches are found" do
      expect(subject.insert_after(/x/,'x')).to eq(subject)
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
end
