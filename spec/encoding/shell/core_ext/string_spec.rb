require 'spec_helper'
require 'ronin/support/encoding/shell/core_ext/string'

describe String do
  subject { "hello world" }

  it { expect(subject).to respond_to(:shell_escape)   }
  it { expect(subject).to respond_to(:shell_unescape) }

  describe "#shell_escape" do
    context "when the String does not contain special characters" do
      subject { "abc" }

      it "must return the String" do
        expect(subject.shell_escape).to eq(subject)
      end
    end

    context "when the String contains a '\"' character" do
      subject { "hello\"world" }

      let(:escaped_shell_string) { "hello\\\"world" }

      it "must back-slash escape the '\"' character" do
        expect(subject.shell_escape).to eq(escaped_shell_string)
      end
    end

    context "when the String contains a '#' character" do
      subject { "hello#world" }

      let(:escaped_shell_string) { "hello\\#world" }

      it "must back-slash escape the '#' character" do
        expect(subject.shell_escape).to eq(escaped_shell_string)
      end
    end

    context "when the String contains back-slashed escaped characters" do
      subject { "\0\a\b\t\n\v\f\r\e\\" }

      let(:escaped_shell_string) { "\\0\\a\\b\\t\\n\\v\\f\\r\\e\\\\" }

      it "must escape the special characters with an extra back-slash" do
        expect(subject.shell_escape).to eq(escaped_shell_string)
      end
    end

    context "when the String contains non-printable characters" do
      subject { "hello\xffworld".force_encoding(Encoding::ASCII_8BIT) }

      let(:escaped_shell_string) { "hello\\xffworld" }

      it "must escape the non-printable characters into \\xXX strings" do
        expect(subject.shell_escape).to eq(escaped_shell_string)
      end
    end

    context "when the String contains unicode characters" do
      subject { "hello\u1001world" }

      let(:escaped_shell_string) { "hello\\u1001world" }

      it "must escape the unicode characters into \\uXX... strings" do
        expect(subject.shell_escape).to eq(escaped_shell_string)
      end
    end
  end

  describe "#shell_unescape" do
    context "when the String contains escaped hexadecimal characters" do
      subject { "\\x68\\x65\\x6c\\x6c\\x6f\\x20\\x77\\x6f\\x72\\x6c\\x64" }

      let(:unescaped) { "hello world" }

      it "must unescape the hexadecimal characters" do
        expect(subject.shell_unescape).to eq(unescaped)
      end
    end

    context "when the String contains escaped unicode characters" do
      subject { "\\u00D8\\u2070E" }

      let(:unescaped) { "Ø𠜎" }

      it "must unescape the hexadecimal characters" do
        expect(subject.shell_unescape).to eq(unescaped)
      end
    end

    context "when the String contains escaped special characters" do
      subject { "\\0\\a\\b\\e\\t\\n\\v\\f\\r\\\'\\\"" }

      let(:unescaped) { "\0\a\b\e\t\n\v\f\r\'\"" }

      it "must unescape escaped special characters" do
        expect(subject.shell_unescape).to eq(unescaped)
      end
    end

    context "when the String does not contain escaped characters" do
      subject { "hello world" }

      it "must return the String" do
        expect(subject.shell_unescape).to eq(subject)
      end
    end
  end

  describe "#shell_encode" do
    subject { "ABC" }

    let(:shell_encoded) { "\\x41\\x42\\x43" }

    it "must shell encode each character in the string" do
      expect(subject.shell_encode).to eq(shell_encoded)
    end
  end

  describe "#shell_string" do
    context "when the string only contains printable characters" do
      subject { "hello world" }

      let(:shell_string) { '"hello world"' }

      it "must return a double quoted shell string" do
        expect(subject.shell_string).to eq(shell_string)
      end
    end

    context "when the string contains non-printable characters" do
      subject { "hello\nworld" }

      let(:shell_string) { "$'hello\\nworld'" }

      it "must return a double quoted shell string" do
        expect(subject.shell_string).to eq(shell_string)
      end
    end
  end

  describe "#shell_unquote" do
    context "when the String is double-quoted" do
      subject { "\"hello\\\"world\\\"\"" }

      let(:unescaped) { "hello\"world\"" }

      it "must remove double-quotes and unescape any escaped double-quotes" do
        expect(subject.shell_unquote).to eq(unescaped)
      end
    end

    context "when the String is single-quoted" do
      subject { "'hello\\'world'" }

      let(:unescaped) { "hello'world" }

      it "must remove single-quotes and unescape any escaped single-quotes" do
        expect(subject.shell_unquote).to eq(unescaped)
      end
    end

    context "when the String is $'...' quoted" do
      subject { "$'hello\\nworld'" }

      let(:unescaped) { "hello\nworld" }

      it "must remove $'...' and unescape the shell string" do
        expect(subject.shell_unquote).to eq(unescaped)
      end
    end

    context "when the String is not quoted" do
      subject { "hello world" }

      it "must return the same String" do
        expect(subject.shell_unquote).to be(subject)
      end
    end
  end
end
