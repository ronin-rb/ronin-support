require 'spec_helper'
require 'ronin/support/encoding/python/core_ext/string'

describe String do
  subject { "hello world" }

  it { expect(subject).to respond_to(:python_escape)   }
  it { expect(subject).to respond_to(:python_unescape) }
  it { expect(subject).to respond_to(:python_encode)   }
  it { expect(subject).to respond_to(:python_decode)   }
  it { expect(subject).to respond_to(:python_string)   }
  it { expect(subject).to respond_to(:python_unquote)  }

  describe ".python_escape" do
    context "when the given String does not contain special characters" do
      subject { "abc" }

      it "must return the given String" do
        expect(subject.python_escape).to eq(subject)
      end
    end

    context "when the given String contains back-slashed escaped characters" do
      subject { "\0\a\b\t\n\v\f\r\\\"" }

      let(:escaped_string) { "\\x00\\a\\b\\t\\n\\v\\f\\r\\\\\\\"" }

      it "must escape the special characters with an extra back-slash" do
        expect(subject.python_escape).to eq(escaped_string)
      end
    end

    context "when the given String contains non-printable characters" do
      subject { "hello\xffworld".force_encoding(Encoding::ASCII_8BIT) }

      let(:escaped_string) { "hello\\xffworld" }

      it "must escape non-printable characters with an extra back-slash" do
        expect(subject.python_escape).to eq(escaped_string)
      end
    end

    context "when the given String contains unicode characters" do
      subject { "hello\u1001world" }

      let(:escaped_string) { "hello\\u1001world" }

      it "must escape the unicode characters with a \\u" do
        expect(subject.python_escape).to eq(escaped_string)
      end
    end

    context "when the String contains invalid byte sequences" do
      subject { "hello\xfe\xff" }

      let(:escaped_string) { "hello\\xfe\\xff" }

      it "must escape each byte in the String" do
        expect(subject.python_escape).to eq(escaped_string)
      end
    end
  end

  describe ".python_unescape" do
    context "when the given String contains escaped hexadecimal characters" do
      subject { "\\x68\\x65\\x6c\\x6c\\x6f\\x20\\x77\\x6f\\x72\\x6c\\x64" }

      let(:unescaped) { "hello world" }

      it "must unescape the hexadecimal characters" do
        expect(subject.python_unescape).to eq(unescaped)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.python_unescape.encoding).to be(Encoding::UTF_8)
      end
    end

    context "when the given String contains escaped unicode characters" do
      subject { "\\u00D8\\U0002070E" }

      let(:unescaped) { "Ø𠜎" }

      it "must unescape the hexadecimal characters" do
        expect(subject.python_unescape).to eq(unescaped)
      end
    end

    context "when the given String contains single character escaped octal characters" do
      subject { "\\0\\1\\2\\3\\4\\5\\6\\7" }

      let(:unescaped) { "\0\1\2\3\4\5\6\7" }

      it "must unescape the octal characters" do
        expect(subject.python_unescape).to eq(unescaped)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.python_unescape.encoding).to be(Encoding::UTF_8)
      end
    end

    context "when the given String contains two character escaped octal characters" do
      subject { "\\10\\11\\12\\13\\14\\15\\16\\17\\20" }

      let(:unescaped) { "\10\11\12\13\14\15\16\17\20" }

      it "must unescape the octal characters" do
        expect(subject.python_unescape).to eq(unescaped)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.python_unescape.encoding).to be(Encoding::UTF_8)
      end
    end

    context "when the given String contains three character escaped octal characters" do
      subject { "\\150\\145\\154\\154\\157\\040\\167\\157\\162\\154\\144" }

      let(:unescaped) { "hello world" }

      it "must unescape the octal characters" do
        expect(subject.python_unescape).to eq(unescaped)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.python_unescape.encoding).to be(Encoding::UTF_8)
      end
    end

    context "when the given String contains escaped special characters" do
      subject { "hello\\0world\\n" }

      let(:unescaped) { "hello\0world\n" }

      it "must unescape Python special characters" do
        expect(subject.python_unescape).to eq(unescaped)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.python_unescape.encoding).to be(Encoding::UTF_8)
      end
    end

    context "when the given String does not contain escaped characters" do
      subject { "hello world" }

      it "must return the given String" do
        expect(subject.python_unescape).to eq(subject)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.python_unescape.encoding).to be(Encoding::UTF_8)
      end
    end
  end

  describe ".python_encode" do
    subject { "ABC" }

    let(:encoded) { '\x41\x42\x43' }

    it "must Python encode each character in the string" do
      expect(subject.python_encode).to eq(encoded)
    end

    context "when the String contains invalid byte sequences" do
      subject { "ABC\xfe\xff" }

      let(:encoded) { '\x41\x42\x43\xfe\xff' }

      it "must encode each byte in the String" do
        expect(subject.python_encode).to eq(encoded)
      end
    end
  end

  describe ".python_string" do
    subject { "hello\nworld" }

    let(:quoted) { '"hello\nworld"' }

    it "must return a double quoted Python string" do
      expect(subject.python_string).to eq(quoted)
    end
  end

  describe ".python_unquote" do
    context "when the given String is double-quoted" do
      subject { "\"hello\\nworld\"" }

      let(:unescaped) { "hello\nworld" }

      it "must remove double-quotes and unescape the Python string" do
        expect(subject.python_unquote).to eq(unescaped)
      end
    end

    context "when the given String is a single-quoted character" do
      subject { "'A'" }

      let(:unescaped) { "A" }

      it "must remove single-quotes and return the character" do
        expect(subject.python_unquote).to eq(unescaped)
      end

      context "but the character is a backslash escaped \\ character" do
        subject { "'\\\\'" }

        let(:unescaped) { "\\" }

        it "must remove single-quotes and return the unescaped character" do
          expect(subject.python_unquote).to eq(unescaped)
        end
      end

      context "but the character is a backslash escaped ' character" do
        subject { "'\\''" }

        let(:unescaped) { "'" }

        it "must remove single-quotes and return the unescaped character" do
          expect(subject.python_unquote).to eq(unescaped)
        end
      end
    end

    context "when the given String is triple-quoted" do
      subject { "'''hello\\nworld'''" }

      let(:unescaped) { "hello\nworld" }

      it "must remove triple-quotes and unescape the Python string" do
        expect(subject.python_unquote).to eq(unescaped)
      end
    end

    context "when the given String starts with 'u'" do
      subject { "u'hello\\nworld'" }

      let(:unescaped) { "hello\nworld" }

      it "must remove 'u' and quotes, and unescape the Python string" do
        expect(subject.python_unquote).to eq(unescaped)
      end
    end

    context "when the given String starts with 'r'" do
      let(:raw_string) { "hello\\nworld" }

      subject { "r'#{raw_string}'" }

      it "must remove 'r' and single-quotes, but not unescape the Python string" do
        expect(subject.python_unquote).to eq(raw_string)
      end
    end

    context "when the given String is not quoted" do
      subject { "hello world" }

      it "must return the same String" do
        expect(subject.python_unquote).to be(subject)
      end
    end
  end
end
