require 'spec_helper'
require 'ronin/support/encoding/perl/core_ext/string'

describe String do
  subject { "hello world" }

  describe "#perl_escape" do
    context "when the given String does not contain special characters" do
      subject { "abc" }

      it "must return the given String" do
        expect(subject.perl_escape).to eq(subject)
      end
    end

    context "when the given String contains back-slashed escaped characters" do
      subject { "\a\b\e\t\n\f\r\\\"$" }

      let(:escaped_string) { "\\a\\b\\e\\t\\n\\f\\r\\\\\\\"\\$" }

      it "must escape the special characters with an extra back-slash" do
        expect(subject.perl_escape).to eq(escaped_string)
      end
    end

    context "when the given String contains non-printable characters" do
      subject do
        "hello\xffworld".force_encoding(Encoding::ASCII_8BIT)
      end

      let(:escaped_string) { "hello\\xFFworld" }

      it "must escape non-printable characters with an extra back-slash" do
        expect(subject.perl_escape).to eq(escaped_string)
      end
    end

    context "when the given String contains unicode characters" do
      subject { "hello\u1001world" }

      let(:escaped_string) { "hello\\x{1001}world" }

      it "must escape the unicode characters with a \\u" do
        expect(subject.perl_escape).to eq(escaped_string)
      end
    end

    context "when the String contains invalid byte sequences" do
      subject { "hello\xfe\xff" }

      let(:escaped_string) { "hello\\xFE\\xFF" }

      it "must escape each byte in the String" do
        expect(subject.perl_escape).to eq(escaped_string)
      end
    end
  end

  describe ".perl_unescape" do
    context "when the given String contains escaped hexadecimal characters" do
      subject do
        "\\x68\\x65\\x6c\\x6c\\x6f\\x20\\x77\\x6f\\x72\\x6c\\x64"
      end

      let(:unescaped) { "hello world" }

      it "must unescape the hexadecimal characters" do
        expect(subject.perl_unescape).to eq(unescaped)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.perl_unescape.encoding).to be(Encoding::UTF_8)
      end

      context "when the given String contains empty '\\x' hexadecimal escapes" do
        subject { "hello\\xworld" }

        let(:unescaped) { "helloworld" }

        it "must ignore empty '\\x' hexadecimal escapes" do
          expect(subject.perl_unescape).to eq(unescaped)
        end
      end
    end

    context "when the given String contains escaped unicode characters" do
      subject { "\\x{00D8}\\N{U+2070E}" }

      let(:unescaped) { "Ø𠜎" }

      it "must unescape the hexadecimal characters" do
        expect(subject.perl_unescape).to eq(unescaped)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.perl_unescape.encoding).to be(Encoding::UTF_8)
      end

      context "and when there are spaces within the '\\x{ ... }'" do
        subject { "\\x{ 00D8 }\\N{U+2070E}" }

        it "must skip the spaces within the '\\x{...}'" do
          expect(subject.perl_unescape).to eq(unescaped)
        end
      end
    end

    context "when the given String contains escaped Unicode Named Characters" do
      let(:named_char) { "\\N{GREEK CAPITAL LETTER SIGMA}" }

      subject { "hello #{named_char} world" }

      it do
        expect {
          subject.perl_unescape
        }.to raise_error(NotImplementedError,"decoding Perl Unicode Named Characters (#{named_char.inspect}) is currently not supported: #{subject.inspect}")
      end
    end

    context "when the given String contains single character escaped octal characters" do
      subject { "\\0\\1\\2\\3\\4\\5\\6\\7" }

      let(:unescaped) { "\0\1\2\3\4\5\6\7" }

      it "must unescape the octal characters" do
        expect(subject.perl_unescape).to eq(unescaped)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.perl_unescape.encoding).to be(Encoding::UTF_8)
      end
    end

    context "when the given String contains two character escaped octal characters" do
      subject { "\\10\\11\\12\\13\\14\\15\\16\\17\\20" }

      let(:unescaped) { "\10\11\12\13\14\15\16\17\20" }

      it "must unescape the octal characters" do
        expect(subject.perl_unescape).to eq(unescaped)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.perl_unescape.encoding).to be(Encoding::UTF_8)
      end
    end

    context "when the given String contains three character escaped octal characters" do
      subject do
        "\\150\\145\\154\\154\\157\\040\\167\\157\\162\\154\\144"
      end

      let(:unescaped) { "hello world" }

      it "must unescape the octal characters" do
        expect(subject.perl_unescape).to eq(unescaped)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.perl_unescape.encoding).to be(Encoding::UTF_8)
      end
    end

    context "when the given String contains '\\o{...}' three character escaped octal characters" do
      subject do
        "\\o{150}\\o{145}\\o{154}\\o{154}\\o{157}\\o{040}\\o{167}\\o{157}\\o{162}\\o{154}\\o{144}"
      end

      let(:unescaped) { "hello world" }

      it "must unescape the octal characters" do
        expect(subject.perl_unescape).to eq(unescaped)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.perl_unescape.encoding).to be(Encoding::UTF_8)
      end

      context "and when there are spaces within the '\\o{ ... }'" do
        subject do
          "\\o{ 150 }\\o{ 145 }\\o{ 154 }\\o{ 154 }\\o{ 157 }\\o{ 040 }\\o{ 167 }\\o{ 157 }\\o{ 162 }\\o{ 154 }\\o{ 144 }"
        end

        it "must skip the spaces within the '\\o{...}'" do
          expect(subject.perl_unescape).to eq(unescaped)
        end
      end
    end

    context "when the given String contains escaped special characters" do
      subject { "hello\\0world\\n" }

      let(:unescaped) { "hello\0world\n" }

      it "must unescape Perl special characters" do
        expect(subject.perl_unescape).to eq(unescaped)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.perl_unescape.encoding).to be(Encoding::UTF_8)
      end

      context "but the escaped character is not a known escaped character" do
        subject { "hello\\world" }

        let(:unescaped) { "helloworld" }

        it "must return the character following the backslash escape" do
          expect(subject.perl_unescape).to eq(unescaped)
        end
      end
    end

    context "when the given String does not contain escaped characters" do
      subject { "hello world" }

      it "must return the given String" do
        expect(subject.perl_unescape).to eq(subject)
      end

      it "must set the String encoding to Encoding::UTF_8" do
        expect(subject.perl_unescape.encoding).to be(Encoding::UTF_8)
      end
    end
  end

  describe "#perl_encode" do
    subject { "ABC" }

    let(:encoded) { '\x41\x42\x43' }

    it "must Perl encode each character in the string" do
      expect(subject.perl_encode).to eq(encoded)
    end

    context "when the String contains invalid byte sequences" do
      subject { "ABC\xfe\xff" }

      let(:encoded) { '\x41\x42\x43\xFE\xFF' }

      it "must encode each byte in the String" do
        expect(subject.perl_encode).to eq(encoded)
      end
    end
  end

  describe "#perl_string" do
    subject { "hello\nworld" }

    let(:quoted) { '"hello\nworld"' }

    it "must return a double quoted Perl string" do
      expect(subject.perl_string).to eq(quoted)
    end
  end

  describe "#perl_unquote" do
    context "when the given String is double-quoted" do
      subject { "\"hello\\nworld\"" }

      let(:unescaped) { "hello\nworld" }

      it "must remove double-quotes and unescape the Perl string" do
        expect(subject.perl_unquote).to eq(unescaped)
      end
    end

    context "when the given String is 'qq{ ... }' quoted" do
      subject { "qq{hello\\nworld}" }

      let(:unescaped) { "hello\nworld" }

      it "must remove 'qq{ ... }' quotes and unescape the Perl string" do
        expect(subject.perl_unquote).to eq(unescaped)
      end
    end

    context "when the given String is a single-quoted character" do
      subject { "'A'" }

      let(:unescaped) { "A" }

      it "must remove single-quotes and return the character" do
        expect(subject.perl_unquote).to eq(unescaped)
      end

      context "but the character is a backslash escaped \\ character" do
        subject { "'\\\\'" }

        let(:unescaped) { "\\" }

        it "must remove single-quotes and return the unescaped character" do
          expect(subject.perl_unquote).to eq(unescaped)
        end
      end

      context "but the character is a backslash escaped ' character" do
        subject { "'\\''" }

        let(:unescaped) { "'" }

        it "must remove single-quotes and return the unescaped character" do
          expect(subject.perl_unquote).to eq(unescaped)
        end
      end
    end

    context "when the given String is a 'q{ ... }' quoted" do
      subject { "q{hello\\'world}" }

      let(:unescaped) { "hello\\'world" }

      it "must return the String without the 'q{ ... }' quoting" do
        expect(subject.perl_unquote).to eq(unescaped)
      end
    end

    context "when the given String is not quoted" do
      subject { "hello world" }

      it "must return the same String" do
        expect(subject.perl_unquote).to be(subject)
      end
    end
  end
end
