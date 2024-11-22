require 'spec_helper'
require 'ronin/support/encoding/java/core_ext/string'

describe String do
  subject { "hello world" }

  it { expect(subject).to respond_to(:java_escape)   }
  it { expect(subject).to respond_to(:java_unescape) }
  it { expect(subject).to respond_to(:java_encode)   }
  it { expect(subject).to respond_to(:java_decode)   }
  it { expect(subject).to respond_to(:java_string)   }
  it { expect(subject).to respond_to(:java_unquote)  }

  describe ".java_escape" do
    context "when the given String does not contain special characters" do
      subject { "abc" }

      it "must return the given String" do
        expect(subject.java_escape).to eq(subject)
      end
    end

    context "when the given String contains back-slashed escaped characters" do
      subject { "\0\b\t\n\v\f\r\\\"" }

      let(:escaped_string) { "\\0\\b\\t\\n\\v\\f\\r\\\\\\\"" }

      it "must escape the special characters with an extra back-slash" do
        expect(subject.java_escape).to eq(escaped_string)
      end
    end

    context "when the given String contains non-printable characters" do
      subject { "hello\xffworld".force_encoding(Encoding::ASCII_8BIT) }

      let(:escaped_string) { "hello\\u00FFworld" }

      it "must escape non-printable characters" do
        expect(subject.java_escape).to eq(escaped_string)
      end
    end

    context "when the given String contains unicode characters" do
      subject { "hello\u1001world" }

      let(:escaped_string) { "hello\\u1001world" }

      it "must escape the unicode characters as '\\uXXXX'" do
        expect(subject.java_escape).to eq(escaped_string)
      end
    end

    context "when the String contains invalid byte sequences" do
      subject { "hello\xfe\xff" }

      let(:escaped_string) { "hello\\u00FE\\u00FF" }

      it "must escape each byte in the String" do
        expect(subject.java_escape).to eq(escaped_string)
      end
    end
  end

  describe ".java_unescape" do
    context "when the given String contains escaped hexadecimal characters" do
      subject { "\\u0068\\u0065\\u006C\\u006C\\u006F\\u0020\\u0077\\u006F\\u0072\\u006C\\u0064" }

      let(:unescaped) { "hello world" }

      it "must unescape the hexadecimal characters" do
        expect(subject.java_unescape).to eq(unescaped)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.java_unescape.encoding).to be(Encoding::UTF_8)
      end
    end

    context "when the given String contains escaped unicode characters" do
      subject { "\\u00D8" }

      let(:unescaped) { "Ø" }

      it "must unescape the '\\uXXXX' unicode characters" do
        expect(subject.java_unescape).to eq(unescaped)
      end
    end

    context "when the given String contains single character escaped octal characters" do
      subject { "\\0\\1\\2\\3\\4\\5\\6\\7" }

      let(:unescaped) { "\0\1\2\3\4\5\6\7" }

      it "must unescape the octal characters" do
        expect(subject.java_unescape).to eq(unescaped)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.java_unescape.encoding).to be(Encoding::UTF_8)
      end
    end

    context "when the given String contains two character escaped octal characters" do
      subject { "\\10\\11\\12\\13\\14\\15\\16\\17\\20" }

      let(:unescaped) { "\10\11\12\13\14\15\16\17\20" }

      it "must unescape the octal characters" do
        expect(subject.java_unescape).to eq(unescaped)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.java_unescape.encoding).to be(Encoding::UTF_8)
      end
    end

    context "when the given String contains three character escaped octal characters" do
      subject { "\\150\\145\\154\\154\\157\\040\\167\\157\\162\\154\\144" }

      let(:unescaped) { "hello world" }

      it "must unescape the octal characters" do
        expect(subject.java_unescape).to eq(unescaped)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.java_unescape.encoding).to be(Encoding::UTF_8)
      end
    end

    context "when the given String contains escaped special characters" do
      subject { "hello\\0world\\n" }

      let(:unescaped) { "hello\0world\n" }

      it "must unescape Python special characters" do
        expect(subject.java_unescape).to eq(unescaped)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.java_unescape.encoding).to be(Encoding::UTF_8)
      end
    end

    context "when the given String does not contain escaped characters" do
      subject { "hello world" }

      it "must return the given String" do
        expect(subject.java_unescape).to eq(subject)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.java_unescape.encoding).to be(Encoding::UTF_8)
      end
    end
  end

  describe ".java_encode" do
    subject { "ABC" }

    let(:encoded) { '\u0041\u0042\u0043' }

    it "must Python encode each character in the String" do
      expect(subject.java_encode).to eq(encoded)
    end

    context "when the String contains invalid byte sequences" do
      subject { "ABC\xfe\xff" }

      let(:encoded) { '\u0041\u0042\u0043\u00FE\u00FF' }

      it "must encode each byte in the String" do
        expect(subject.java_encode).to eq(encoded)
      end
    end
  end

  describe ".java_string" do
    subject { "hello\nworld" }

    let(:quoted) { '"hello\nworld"' }

    it "must return a double quoted Python String" do
      expect(subject.java_string).to eq(quoted)
    end
  end

  describe ".java_unquote" do
    context "when the given String is double-quoted" do
      subject { "\"hello\\nworld\"" }

      let(:unescaped) { "hello\nworld" }

      it "must remove double-quotes and unescape the Python String" do
        expect(subject.java_unquote).to eq(unescaped)
      end
    end

    context "when the given String is not quoted" do
      subject { "hello world" }

      it "must return the same String" do
        expect(subject.java_unquote).to be(subject)
      end
    end
  end
end
