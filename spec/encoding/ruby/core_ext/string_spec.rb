require 'spec_helper'
require 'ronin/support/encoding/ruby/core_ext/string'

describe String do
  subject { "hello world" }

  it { expect(subject).to respond_to(:ruby_escape)   }
  it { expect(subject).to respond_to(:ruby_unescape) }
  it { expect(subject).to respond_to(:ruby_encode)   }
  it { expect(subject).to respond_to(:ruby_decode)   }
  it { expect(subject).to respond_to(:ruby_string)   }
  it { expect(subject).to respond_to(:ruby_unquote)  }

  describe "#ruby_escape" do
    context "when the String does not contain special characters" do
      subject { "abc" }

      it "must return the String" do
        expect(subject.ruby_escape).to eq(subject)
      end
    end

    context "when the String contains back-slashed escaped characters" do
      subject { "\0\a\b\e\t\n\v\f\r\\\"" }

      let(:escaped_ruby_string) { "\\x00\\a\\b\\e\\t\\n\\v\\f\\r\\\\\\\"" }

      it "must escape the special characters with an extra back-slash" do
        expect(subject.ruby_escape).to eq(escaped_ruby_string)
      end
    end

    context "when the String contains non-printable characters" do
      subject { "hello\xffworld".force_encoding(Encoding::ASCII_8BIT) }

      let(:escaped_ruby_string) { "hello\\xFFworld" }

      it "must escape non-printable characters with an extra back-slash" do
        expect(subject.ruby_escape).to eq(escaped_ruby_string)
      end
    end

    context "when the String contains unicode characters" do
      subject { "hello\u1001world" }

      let(:escaped_ruby_string) { "hello\\u1001world" }

      it "must escape the unicode characters with a \\u" do
        expect(subject.ruby_escape).to eq(escaped_ruby_string)
      end
    end

    context "when the String contains invalid byte sequences" do
      subject { "hello\xfe\xff" }

      let(:escaped_string) { "hello\\xFE\\xFF" }

      it "must escape each byte in the String" do
        expect(subject.ruby_escape).to eq(escaped_string)
      end
    end
  end

  describe "#ruby_unescape" do
    context "when the String contains escaped hexadecimal characters" do
      subject { "\\x68\\x65\\x6c\\x6c\\x6f\\x20\\x77\\x6f\\x72\\x6c\\x64" }

      let(:unescaped) { "hello world" }

      it "must unescape the hexadecimal characters" do
        expect(subject.ruby_unescape).to eq(unescaped)
      end
    end

    context "when the String contains escaped unicode characters" do
      subject { "\\u00D8\\u{2070E}" }

      let(:unescaped) { "Ø𠜎" }

      it "must unescape the hexadecimal characters" do
        expect(subject.ruby_unescape).to eq(unescaped)
      end
    end

    context "when the String contains single character escaped octal characters" do
      subject { "\\0\\1\\2\\3\\4\\5\\6\\7" }

      let(:unescaped) { "\0\1\2\3\4\5\6\7" }

      it "must unescape the octal characters" do
        expect(subject.ruby_unescape).to eq(unescaped)
      end
    end

    context "when the String contains two character escaped octal characters" do
      subject { "\\10\\11\\12\\13\\14\\15\\16\\17\\20" }

      let(:unescaped) { "\10\11\12\13\14\15\16\17\20" }

      it "must unescape the octal characters" do
        expect(subject.ruby_unescape).to eq(unescaped)
      end
    end

    context "when the String contains three character escaped octal characters" do
      subject { "\\150\\145\\154\\154\\157\\040\\167\\157\\162\\154\\144" }

      let(:unescaped) { "hello world" }

      it "must unescape the octal characters" do
        expect(subject.ruby_unescape).to eq(unescaped)
      end
    end

    context "when the String contains escaped special characters" do
      subject { "hello\\0world\\n" }

      let(:unescaped) { "hello\0world\n" }

      it "must unescape Ruby special characters" do
        expect(subject.ruby_unescape).to eq(unescaped)
      end
    end

    context "when the String does not contain escaped characters" do
      subject { "hello world" }

      it "must return the String" do
        expect(subject.ruby_unescape).to eq(subject)
      end
    end
  end

  describe "#ruby_encode" do
    subject { "ABC" }

    let(:ruby_encoded) { '\x41\x42\x43' }

    it "must Ruby encode each character in the string" do
      expect(subject.ruby_encode).to eq(ruby_encoded)
    end

    context "when the String contains invalid byte sequences" do
      subject { "ABC\xfe\xff" }

      let(:encoded) { '\x41\x42\x43\xFE\xFF' }

      it "must encode each byte in the String" do
        expect(subject.ruby_encode).to eq(encoded)
      end
    end
  end

  describe "#ruby_string" do
    subject { "hello\nworld" }

    let(:ruby_string) { '"hello\nworld"' }

    it "must return a double quoted Ruby string" do
      expect(subject.ruby_string).to eq(ruby_string)
    end
  end

  describe "#ruby_unquote" do
    context "when the String is double-quoted" do
      subject { "\"hello\\nworld\"" }

      let(:unescaped) { "hello\nworld" }

      it "must remove double-quotes and unescape the Ruby string" do
        expect(subject.ruby_unquote).to eq(unescaped)
      end
    end

    context "when the String is a single-quoted character" do
      subject { "'A'" }

      let(:unescaped) { "A" }

      it "must remove single-quotes and return the character" do
        expect(subject.ruby_unquote).to eq(unescaped)
      end

      context "but the character is a backslash escaped \\ character" do
        subject { "'\\\\'" }

        let(:unescaped) { "\\" }

        it "must remove single-quotes and return the unescaped character" do
          expect(subject.ruby_unquote).to eq(unescaped)
        end
      end

      context "but the character is a backslash escaped ' character" do
        subject { "'\\''" }

        let(:unescaped) { "'" }

        it "must remove single-quotes and return the unescaped character" do
          expect(subject.ruby_unquote).to eq(unescaped)
        end
      end
    end

    context "when the String is not quoted" do
      subject { "hello world" }

      it "must return the same String" do
        expect(subject.ruby_unquote).to be(subject)
      end
    end
  end
end
