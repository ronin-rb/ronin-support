require 'spec_helper'
require 'ronin/support/encoding/powershell/core_ext/string'

describe String do
  subject { "hello world" }

  it { expect(subject).to respond_to(:powershell_escape) }
  it { expect(subject).to respond_to(:psh_escape) }

  it { expect(subject).to respond_to(:powershell_unescape) }
  it { expect(subject).to respond_to(:psh_unescape) }

  describe "#powershell_escape" do
    context "when the String does not contain special characters" do
      subject { "abc" }

      it "must return the String" do
        expect(subject.powershell_escape).to eq(subject)
      end
    end

    context "when the String contains a '#' character" do
      subject { "hello#world" }

      let(:escaped_powershell_string) { "hello`#world" }

      it "must grave-accent escape the '#' character" do
        expect(subject.powershell_escape).to eq(escaped_powershell_string)
      end
    end

    context "when the String contains a '\\'' character" do
      subject { "hello'world" }

      let(:escaped_powershell_string) { "hello`'world" }

      it "must grave-accent escape the '`'' character" do
        expect(subject.powershell_escape).to eq(escaped_powershell_string)
      end
    end

    context "when the String contains a '\"' character" do
      subject { "hello\"world" }

      let(:escaped_powershell_string) { "hello`\"world" }

      it "must grave-accent escape the '\"' character" do
        expect(subject.powershell_escape).to eq(escaped_powershell_string)
      end
    end

    context "when the String contains grave-accented escaped characters" do
      subject { "\0\a\b\t\n\v\f\r\\" }

      let(:escaped_powershell_string) { "`0`a`b`t`n`v`f`r\\\\" }

      it "must escape the special characters with a grave-accent ('`')" do
        expect(subject.powershell_escape).to eq(escaped_powershell_string)
      end
    end

    context "when the String contains non-printable characters" do
      subject { "hello\xffworld".force_encoding(Encoding::ASCII_8BIT) }

      let(:escaped_powershell_string) { "hello$([char]0xff)world" }

      it "must convert the non-printable characters into '$([char]0xXX)' interpolated strings" do
        expect(subject.powershell_escape).to eq(escaped_powershell_string)
      end
    end

    context "when the String contains unicode characters" do
      subject { "hello\u1001world" }

      let(:escaped_powershell_string) { "hello$([char]0x1001)world" }

      it "must convert the unicode characters into '$([char]0XX...)' interpolated strings" do
        expect(subject.powershell_escape).to eq(escaped_powershell_string)
      end
    end

    context "when the String contains invalid byte sequences" do
      subject { "hello\xfe\xff" }

      let(:escaped_powershell_string) { "hello$([char]0xfe)$([char]0xff)" }

      it "must escape each byte in the String" do
        expect(subject.powershell_escape).to eq(escaped_powershell_string)
      end
    end
  end

  describe "#powershell_unescape" do
    context "when the String contains interpolated hexadecimal characters" do
      subject { "$([char]0x68)$([char]0x65)$([char]0x6c)$([char]0x6c)$([char]0x6f)$([char]0x20)$([char]0x77)$([char]0x6f)$([char]0x72)$([char]0x6c)$([char]0x64)" }

      let(:unescaped) { "hello world" }

      it "must unescape the hexadecimal characters" do
        expect(subject.powershell_unescape).to eq(unescaped)
      end
    end

    context "when the String contains interpolated unicode characters" do
      subject { "$([char]0x00D8)$([char]0x2070E)" }

      let(:unescaped) { "Ø𠜎" }

      it "must unescape the hexadecimal characters" do
        expect(subject.powershell_unescape).to eq(unescaped)
      end
    end

    context "when the String contains grave-accent escaped unicode characters" do
      subject { "`u{00D8}`u{2070E}" }

      let(:unescaped) { "Ø𠜎" }

      it "must unescape the hexadecimal characters" do
        expect(subject.powershell_unescape).to eq(unescaped)
      end
    end

    context "when the String contains grave-accent escaped special characters" do
      subject { "hello`0world`n" }

      let(:unescaped) { "hello\0world\n" }

      it "must unescape the grave-accent escaped special characters" do
        expect(subject.powershell_unescape).to eq(unescaped)
      end
    end

    context "when the String does not contain escaped characters" do
      subject { "hello world" }

      it "must return the String" do
        expect(subject.powershell_unescape).to eq(subject)
      end
    end
  end

  describe "#powershell_encode" do
    subject { "ABC" }

    let(:powershell_encoded) { "$([char]0x41)$([char]0x42)$([char]0x43)" }

    it "must PowerShell encode each character in the string" do
      expect(subject.powershell_encode).to eq(powershell_encoded)
    end

    context "when the String contains invalid byte sequences" do
      subject { "ABC\xfe\xff" }

      let(:powershell_encoded) do
        "$([char]0x41)$([char]0x42)$([char]0x43)$([char]0xfe)$([char]0xff)"
      end

      it "must encode each byte in the String" do
        expect(subject.powershell_encode).to eq(powershell_encoded)
      end
    end
  end

  describe "#powershell_string" do
    subject { "hello\nworld" }

    let(:powershell_string) { "\"hello`nworld\"" }

    it "must return a double quoted PowerShell string" do
      expect(subject.powershell_string).to eq(powershell_string)
    end
  end

  describe "#powershell_unquote" do
    context "when the String is double-quoted" do
      subject { "\"hello`nworld\"" }

      let(:unescaped) { "hello\nworld" }

      it "must remove double-quotes and unescape the PowerShell string" do
        expect(subject.powershell_unquote).to eq(unescaped)
      end
    end

    context "when the String is single-quoted" do
      subject { "'hello''world'" }

      let(:unescaped) { "hello'world" }

      it "must remove single-quotes and unescape any double single-quotes" do
        expect(subject.powershell_unquote).to eq(unescaped)
      end
    end

    context "when the String is not quoted" do
      subject { "hello world" }

      it "must return the same String" do
        expect(subject.powershell_unquote).to be(subject)
      end
    end
  end
end
