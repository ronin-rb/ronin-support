require 'spec_helper'
require 'ronin/support/encoding/powershell'

describe Ronin::Support::Encoding::PowerShell do
  describe ".escape_byte" do
    Ronin::Support::Encoding::PowerShell::ESCAPE_BYTES.each do |byte,escaped_char|
      context "when called on #{byte}" do
        let(:byte) { byte }

        it "must return #{escaped_char.inspect}" do
          expect(subject.escape_byte(byte)).to eq(escaped_char)
        end
      end
    end

    context "when called on an Integer between 0x20 and 0x7e" do
      let(:byte) { 0x41 }

      it "must return the ASCII character for the byte" do
        expect(subject.escape_byte(byte)).to eq(byte.chr)
      end
    end

    context "when called on an Integer that does not map to an ASCII char" do
      let(:byte) { 0xFF }

      it "must return the lowercase $([char]0xXX) hex escaped character" do
        expect(subject.escape_byte(byte)).to eq("$([char]0xff)")
      end
    end

    context "when called on an Integer is greater than 0xff" do
      let(:byte) { 0xFFFF }

      it "must return the lowercase $([char]0xXXXX) hex escaped character" do
        expect(subject.escape_byte(byte)).to eq("$([char]0xffff)")
      end
    end

    context "when called on a negative Integer" do
      let(:byte) { -1 }

      it do
        expect {
          subject.escape_byte(byte)
        }.to raise_error(RangeError,"#{byte.inspect} out of char range")
      end
    end
  end

  describe ".encode_byte" do
    context "when called on an Integer between 0x00 and 0xff" do
      let(:byte) { 0x41 }

      it "must return the lowercase $([char]0xXX) hex escaped character" do
        expect(subject.encode_byte(byte)).to eq("$([char]0x41)")
      end
    end

    context "when called on an Integer is greater than 0xff" do
      let(:byte) { 0xFFFF }

      it "must return the lowercase $([char]0xXXXX) hex escaped String" do
        expect(subject.encode_byte(byte)).to eq("$([char]0xffff)")
      end
    end

    context "when called on a negative Integer" do
      let(:byte) { -1 }

      it do
        expect {
          subject.encode_byte(byte)
        }.to raise_error(RangeError,"#{byte.inspect} out of char range")
      end
    end
  end

  describe ".escape" do
    context "when the String does not contain special characters" do
      let(:data) { "abc" }

      it "must return the String" do
        expect(subject.escape(data)).to eq(data)
      end
    end

    context "when the String contains a '#' character" do
      let(:data) { "hello#world" }

      let(:escaped_powershell_string) { "hello`#world" }

      it "must grave-accent escape the '#' character" do
        expect(subject.escape(data)).to eq(escaped_powershell_string)
      end
    end

    context "when the String contains a '\\'' character" do
      let(:data) { "hello'world" }

      let(:escaped_powershell_string) { "hello`'world" }

      it "must grave-accent escape the '`'' character" do
        expect(subject.escape(data)).to eq(escaped_powershell_string)
      end
    end

    context "when the String contains a '\"' character" do
      let(:data) { "hello\"world" }

      let(:escaped_powershell_string) { "hello`\"world" }

      it "must grave-accent escape the '\"' character" do
        expect(subject.escape(data)).to eq(escaped_powershell_string)
      end
    end

    context "when the String contains grave-accented escaped characters" do
      let(:data) { "\0\a\b\t\n\v\f\r\\" }

      let(:escaped_powershell_string) { "`0`a`b`t`n`v`f`r\\\\" }

      it "must escape the special characters with a grave-accent ('`')" do
        expect(subject.escape(data)).to eq(escaped_powershell_string)
      end
    end

    context "when the String contains non-printable characters" do
      let(:data) { "hello\xffworld".force_encoding(Encoding::ASCII_8BIT) }

      let(:escaped_powershell_string) { "hello$([char]0xff)world" }

      it "must convert the non-printable characters into '$([char]0xXX)' interpolated strings" do
        expect(subject.escape(data)).to eq(escaped_powershell_string)
      end
    end

    context "when the String contains unicode characters" do
      let(:data) { "hello\u1001world" }

      let(:escaped_powershell_string) { "hello$([char]0x1001)world" }

      it "must convert the unicode characters into '$([char]0XX...)' interpolated strings" do
        expect(subject.escape(data)).to eq(escaped_powershell_string)
      end
    end
  end

  describe ".unescape" do
    context "when the String contains interpolated hexadecimal characters" do
      let(:data) do
        "$([char]0x68)$([char]0x65)$([char]0x6c)$([char]0x6c)$([char]0x6f)$([char]0x20)$([char]0x77)$([char]0x6f)$([char]0x72)$([char]0x6c)$([char]0x64)"
      end

      let(:unescaped) { "hello world" }

      it "must unescape the hexadecimal characters" do
        expect(subject.unescape(data)).to eq(unescaped)
      end
    end

    context "when the String contains interpolated unicode characters" do
      let(:data)      { "$([char]0x00D8)$([char]0x2070E)" }
      let(:unescaped) { "Ø𠜎" }

      it "must unescape the hexadecimal characters" do
        expect(subject.unescape(data)).to eq(unescaped)
      end
    end

    context "when the String contains grave-accent escaped unicode characters" do
      let(:data)      { "`u{00D8}`u{2070E}" }
      let(:unescaped) { "Ø𠜎" }

      it "must unescape the hexadecimal characters" do
        expect(subject.unescape(data)).to eq(unescaped)
      end
    end

    context "when the String contains grave-accent escaped special characters" do
      let(:data)      { "hello`0world`n" }
      let(:unescaped) { "hello\0world\n" }

      it "must unescape the grave-accent escaped special characters" do
        expect(subject.unescape(data)).to eq(unescaped)
      end
    end

    context "when the String does not contain escaped characters" do
      let(:data) { "hello world" }

      it "must return the String" do
        expect(subject.unescape(data)).to eq(data)
      end
    end
  end

  describe ".encode" do
    let(:data)               { "ABC" }
    let(:powershell_encoded) { "$([char]0x41)$([char]0x42)$([char]0x43)" }

    it "must PowerShell encode each character in the string" do
      expect(subject.encode(data)).to eq(powershell_encoded)
    end
  end

  describe ".quote" do
    let(:data)              { "hello\nworld" }
    let(:powershell_string) { "\"hello`nworld\"" }

    it "must return a double quoted PowerShell string" do
      expect(subject.quote(data)).to eq(powershell_string)
    end
  end

  describe ".unquote" do
    context "when the String is double-quoted" do
      let(:data)      { "\"hello`nworld\"" }
      let(:unescaped) { "hello\nworld" }

      it "must remove double-quotes and unescape the PowerShell string" do
        expect(subject.unquote(data)).to eq(unescaped)
      end
    end

    context "when the String is single-quoted" do
      let(:data)      { "'hello''world'" }
      let(:unescaped) { "hello'world" }

      it "must remove single-quotes and unescape any double single-quotes" do
        expect(subject.unquote(data)).to eq(unescaped)
      end
    end

    context "when the String is not quoted" do
      let(:data) { "hello world" }

      it "must return the same String" do
        expect(subject.unquote(data)).to be(data)
      end
    end
  end
end
