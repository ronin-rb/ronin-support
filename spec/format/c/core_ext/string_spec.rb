require 'spec_helper'
require 'ronin/support/format/c/core_ext/string'

describe String do
  subject { "hello world" }

  it { expect(subject).to respond_to(:c_escape)   }
  it { expect(subject).to respond_to(:c_unescape) }
  it { expect(subject).to respond_to(:format_c)   }

  describe "#c_escape" do
    context "when the String does not contain special characters" do
      subject { "abc" }

      it "must return the String" do
        expect(subject.c_escape).to eq(subject)
      end
    end

    context "when the String contains back-slashed escaped characters" do
      subject { "\0\a\b\e\t\n\v\f\r\\\"" }

      let(:escaped_c_string) { "\\0\\a\\b\\e\\t\\n\\v\\f\\r\\\\\\\"" }

      it "must escape the special characters with an extra back-slash" do
        expect(subject.c_escape).to eq(escaped_c_string)
      end
    end

    context "when the String contains non-printable characters" do
      subject { "hello\xffworld".force_encoding(Encoding::ASCII_8BIT) }

      let(:escaped_c_string) { "hello\\xffworld" }

      it "must escape non-printable characters with an extra back-slash" do
        expect(subject.c_escape).to eq(escaped_c_string)
      end
    end

    context "when the String contains unicode characters" do
      subject { "hello\u1001world" }

      let(:escaped_c_string) { "hello\\u1001world" }

      it "must escape the unicode characters with a \\u" do
        expect(subject.c_escape).to eq(escaped_c_string)
      end
    end
  end

  describe "#c_unescape" do
    context "when the String contains escaped hexadecimal characters" do
      subject { "\\x68\\x65\\x6c\\x6c\\x6f\\x20\\x77\\x6f\\x72\\x6c\\x64" }

      let(:unescaped) { "hello world" }

      it "must unescape the hexadecimal characters" do
        expect(subject.c_unescape).to eq(unescaped)
      end
    end

    context "when the String contains escaped unicode characters" do
      subject { "\\u00D8\\u2070E" }

      let(:unescaped) { "Ø𠜎" }

      it "must unescape the hexadecimal characters" do
        expect(subject.c_unescape).to eq(unescaped)
      end
    end

    context "when the String contains escaped octal characters" do
      subject { "\\150\\145\\154\\154\\157\\040\\167\\157\\162\\154\\144" }

      let(:unescaped) { "hello world" }

      it "must unescape the octal characters" do
        expect(subject.c_unescape).to eq(unescaped)
      end
    end

    context "when the String contains escaped special characters" do
      subject { "hello\\0world\\n" }

      let(:unescaped) { "hello\0world\n" }

      it "must unescape C special characters" do
        expect(subject.c_unescape).to eq(unescaped)
      end
    end

    context "when the String does not contain escaped characters" do
      subject { "hello world" }

      it "must return the String" do
        expect(subject.c_unescape).to eq(subject)
      end
    end
  end

  describe "#format_c" do
    let(:c_formatted) { '\x68\x65\x6c\x6c\x6f\x20\x77\x6f\x72\x6c\x64' }

    it "must C escape all characters" do
      expect(subject.format_c).to eq(c_formatted)
    end
  end

  describe "#c_encode" do
    subject { "ABC" }

    let(:c_encoded) { '\x41\x42\x43' }

    it "must C encode each character in the string" do
      expect(subject.c_encode).to eq(c_encoded)
    end
  end

  describe "#c_string" do
    subject { "hello\nworld" }

    let(:c_string) { '"hello\nworld"' }

    it "must return a double quoted C string" do
      expect(subject.c_string).to eq(c_string)
    end
  end
end
