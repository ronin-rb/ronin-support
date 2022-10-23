require 'spec_helper'
require 'ronin/support/encoding/shell'

describe Ronin::Support::Encoding::Shell do
  describe ".encode_byte" do
    context "when called on an Integer between 0x00 and 0xff" do
      let(:byte) { 0x41 }

      it "must encode the Integer as a shell hex character" do
        expect(subject.encode_byte(byte)).to eq("\\x41")
      end
    end

    context "when called on an Integer is greater than 0xff" do
      let(:byte) { 0xFFFF }

      it "must return the lowercase \\uXXXX hex escaped String" do
        expect(subject.encode_byte(byte)).to eq("\\uffff")
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

  describe ".escape_byte" do
    Ronin::Support::Encoding::Shell::ESCAPE_BYTES.each do |byte,escaped_char|
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

      it "must return the lowercase \\xXX hex escaped String" do
        expect(subject.escape_byte(byte)).to eq("\\xff")
      end
    end

    context "when called on an Integer is greater than 0xff" do
      let(:byte) { 0xFFFF }

      it "must return the lowercase \\uXXXX hex escaped String" do
        expect(subject.escape_byte(byte)).to eq("\\uffff")
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

  describe ".escape" do
    context "when the String does not contain special characters" do
      let(:data) { "abc" }

      it "must return the String" do
        expect(subject.escape(data)).to eq(data)
      end
    end

    context "when the String contains a '\"' character" do
      let(:data)                 { "hello\"world"   }
      let(:escaped_shell_string) { "hello\\\"world" }

      it "must back-slash escape the '\"' character" do
        expect(subject.escape(data)).to eq(escaped_shell_string)
      end
    end

    context "when the String contains a '#' character" do
      let(:data)                 { "hello#world"   }
      let(:escaped_shell_string) { "hello\\#world" }

      it "must back-slash escape the '#' character" do
        expect(subject.escape(data)).to eq(escaped_shell_string)
      end
    end

    context "when the String contains back-slashed escaped characters" do
      let(:data)                 { "\0\a\b\t\n\v\f\r\e\\"            }
      let(:escaped_shell_string) { "\\0\\a\\b\\t\\n\\v\\f\\r\\e\\\\" }

      it "must escape the special characters with an extra back-slash" do
        expect(subject.escape(data)).to eq(escaped_shell_string)
      end
    end

    context "when the String contains non-printable characters" do
      let(:data)                 { "hello\x01world"  }
      let(:escaped_shell_string) { "hello\\x01world" }

      it "must escape the non-printable characters into \\xXX strings" do
        expect(subject.escape(data)).to eq(escaped_shell_string)
      end
    end

    context "when the String contains unicode characters" do
      let(:data)                 { "hello\u1001world"  }
      let(:escaped_shell_string) { "hello\\u1001world" }

      it "must escape the unicode characters into \\uXX... strings" do
        expect(subject.escape(data)).to eq(escaped_shell_string)
      end
    end

    context "when the String contains invalid byte sequences" do
      let(:data)                 { "hello\xfe\xff"   }
      let(:escaped_shell_string) { "hello\\xfe\\xff" }

      it "must escape each byte in the String" do
        expect(subject.escape(data)).to eq(escaped_shell_string)
      end
    end
  end

  describe ".unescape" do
    context "when the String contains escaped hexadecimal characters" do
      let(:data) do
        "\\x68\\x65\\x6c\\x6c\\x6f\\x20\\x77\\x6f\\x72\\x6c\\x64"
      end
      let(:unescaped) { "hello world" }

      it "must unescape the hexadecimal characters" do
        expect(subject.unescape(data)).to eq(unescaped)
      end
    end

    context "when the String contains escaped unicode characters" do
      let(:data)      { "\\u00D8\\u2070E" }
      let(:unescaped) { "Ø𠜎" }

      it "must unescape the hexadecimal characters" do
        expect(subject.unescape(data)).to eq(unescaped)
      end
    end

    context "when the String contains escaped special characters" do
      let(:data)      { "\\0\\a\\b\\e\\t\\n\\v\\f\\r\\\'\\\"" }
      let(:unescaped) { "\0\a\b\e\t\n\v\f\r\'\"" }

      it "must unescape escaped special characters" do
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
    let(:data)          { "ABC" }
    let(:shell_encoded) { "\\x41\\x42\\x43" }

    it "must shell encode each character in the string" do
      expect(subject.encode(data)).to eq(shell_encoded)
    end

    context "when the String contains invalid byte sequences" do
      let(:data)          { "ABC\xfe\xff"               }
      let(:shell_encoded) { "\\x41\\x42\\x43\\xfe\\xff" }

      it "must encode each byte in the String" do
        expect(subject.encode(data)).to eq(shell_encoded)
      end
    end
  end

  describe ".quote" do
    context "when the string only contains printable characters" do
      let(:data)         { "hello world"   }
      let(:shell_string) { '"hello world"' }

      it "must return a double quoted shell string" do
        expect(subject.quote(data)).to eq(shell_string)
      end
    end

    context "when the string contains non-printable characters" do
      let(:data)         { "hello\nworld"     }
      let(:shell_string) { "$'hello\\nworld'" }

      it "must return a double quoted shell string" do
        expect(subject.quote(data)).to eq(shell_string)
      end
    end
  end

  describe ".unquote" do
    context "when the String is double-quoted" do
      let(:data)      { "\"hello\\\"world\\\"\"" }
      let(:unescaped) { "hello\"world\""         }

      it "must remove double-quotes and unescape any escaped double-quotes" do
        expect(subject.unquote(data)).to eq(unescaped)
      end
    end

    context "when the String is single-quoted" do
      let(:data)      { "'hello\\'world'" }
      let(:unescaped) { "hello'world"     }

      it "must remove single-quotes and unescape any escaped single-quotes" do
        expect(subject.unquote(data)).to eq(unescaped)
      end
    end

    context "when the String is $'...' quoted" do
      let(:data)      { "$'hello\\nworld'" }
      let(:unescaped) { "hello\nworld"     }

      it "must remove $'...' and unescape the shell string" do
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
