require 'spec_helper'
require 'ronin/support/text/random'

describe Ronin::Support::Text::Random do
  let(:string) { "hello" }

  describe ".swapcase" do
    context "when given an empty String" do
      it "must return the empty String" do
        expect(subject.swapcase('')).to eq('')
      end
    end

    let(:n) { 100 }

    context "when given a single letter String" do
      let(:string) { 'a' }

      it "must swap the case of the single letter" do
        n.times do
          expect(subject.swapcase(string)).to eq(string.upcase)
        end
      end
    end

    context "when gvien a two letter String" do
      let(:string) { 'ab' }

      it "must swap the case of at least one letter, but not both" do
        n.times do
          expect(subject.swapcase(string)).to eq('Ab').or(eq('aB'))
        end
      end
    end

    context "when given a multi-letter String" do
      let(:string) { 'abcd' }
      let(:expected_strings) do
        %w[
          Abcd
          aBcd
          abCd
          abcD
          ABcd
          AbCd
          AbcD
          aBCd
          aBcD
          abCD
          ABCd
          ABcD
          AbCD
          aBCD
        ]
      end

      it "must swapcase at least one letter, but not all of them" do
        n.times do
          expect(expected_strings).to include(subject.swapcase(string))
        end
      end
    end

    context "when the String contains unicode-letters" do
      let(:string) { "αβγδ" }
      let(:expected_strings) do
        %w[
          Αβγδ
          αΒγδ
          αβΓδ
          αβγΔ
          ΑΒγδ
          ΑβΓδ
          ΑβγΔ
          αΒΓδ
          αΒγΔ
          αβΓΔ
          ΑΒΓδ
          ΑΒγΔ
          ΑβΓΔ
          αΒΓΔ
        ]
      end

      it "must swapcase at least one unicode-letter, but not all of them" do
        n.times do
          expect(expected_strings).to include(subject.swapcase(string))
        end
      end
    end

    context "when the String contains non-letter characters" do
      let(:string) { 'a b-c' }
      let(:expected_strings) do
        [
          'A b-c',
          'a B-c',
          'a b-C',
          'A B-c',
          'A b-C',
          'a B-C'
        ]
      end

      it "must ignore the non-letter characters" do
        n.times do
          expect(expected_strings).to include(subject.swapcase(string))
        end
      end
    end

    context "when the String only contains non-letter characters" do
      let(:string) { %{1234567890`~!@#$%^&*()-_=+[]{}\\|;:'",.<>/?} }

      it "must return the String unchanged" do
        expect(subject.swapcase(string)).to eq(string)
      end
    end
  end

  describe ".numeric" do
    context "when given no arguments" do
      it "must return a String containing one numeric digit" do
        expect(subject.numeric).to match(/\A\d\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only numeric characters" do
        expect(subject.numeric(length)).to match(/\A\d{#{length}}\z/)
      end
    end
  end

  describe ".digits" do
    context "when given no arguments" do
      it "must return a String containing one numeric digit" do
        expect(subject.digits).to match(/\A\d\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only numeric characters" do
        expect(subject.digits(length)).to match(/\A\d{#{length}}\z/)
      end
    end
  end

  describe ".octal" do
    context "when given no arguments" do
      it "must return a String containing one octal digit" do
        expect(subject.octal).to match(/\A[0-7]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only octal characters" do
        expect(subject.octal(length)).to match(/\A[0-7]{#{length}}\z/)
      end
    end
  end

  describe ".uppercase_hex" do
    context "when given no arguments" do
      it "must return a String containing one uppercase hexadecimal digit" do
        expect(subject.uppercase_hex).to match(/\A[A-F0-9]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only uppercase hexadecimal characters" do
        expect(subject.uppercase_hex(length)).to match(/\A[A-F0-9]{#{length}}\z/)
      end
    end
  end

  describe ".upper_hex" do
    context "when given no arguments" do
      it "must return a String containing one uppercase hexadecimal digit" do
        expect(subject.upper_hex).to match(/\A[A-F0-9]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only uppercase hexadecimal characters" do
        expect(subject.upper_hex(length)).to match(/\A[A-F0-9]{#{length}}\z/)
      end
    end
  end

  describe ".lowercase_hex" do
    context "when given no arguments" do
      it "must return a String containing one lowercase hexadecimal digit" do
        expect(subject.lowercase_hex).to match(/\A[a-f0-9]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only lowercase hexadecimal characters" do
        expect(subject.lowercase_hex(length)).to match(/\A[a-f0-9]{#{length}}\z/)
      end
    end
  end

  describe ".lower_hex" do
    context "when given no arguments" do
      it "must return a String containing one lowercase hexadecimal digit" do
        expect(subject.lower_hex).to match(/\A[a-f0-9]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only lowercase hexadecimal characters" do
        expect(subject.lower_hex(length)).to match(/\A[a-f0-9]{#{length}}\z/)
      end
    end
  end

  describe ".hex" do
    context "when given no arguments" do
      it "must return a String containing one hexadecimal digit" do
        expect(subject.hex).to match(/\A[A-Fa-f0-9]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only hexadecimal characters" do
        expect(subject.hex(length)).to match(/\A[A-Fa-f0-9]{#{length}}\z/)
      end
    end
  end

  describe ".uppercase_alpha" do
    context "when given no arguments" do
      it "must return a String containing one uppercase alpha digit" do
        expect(subject.uppercase_alpha).to match(/\A[A-Z]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only uppercase alpha characters" do
        expect(subject.uppercase_alpha(length)).to match(/\A[A-Z]{#{length}}\z/)
      end
    end
  end

  describe ".upper_alpha" do
    context "when given no arguments" do
      it "must return a String containing one uppercase alpha digit" do
        expect(subject.upper_alpha).to match(/\A[A-Z]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only uppercase alpha characters" do
        expect(subject.upper_alpha(length)).to match(/\A[A-Z]{#{length}}\z/)
      end
    end
  end

  describe ".lowercase_alpha" do
    context "when given no arguments" do
      it "must return a String containing one lowercase alpha digit" do
        expect(subject.lowercase_alpha).to match(/\A[a-z]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only lowercase alpha characters" do
        expect(subject.lowercase_alpha(length)).to match(/\A[a-z]{#{length}}\z/)
      end
    end
  end

  describe ".lower_alpha" do
    context "when given no arguments" do
      it "must return a String containing one lowercase alpha digit" do
        expect(subject.lower_alpha).to match(/\A[a-z]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only lowercase alpha characters" do
        expect(subject.lower_alpha(length)).to match(/\A[a-z]{#{length}}\z/)
      end
    end
  end

  describe ".alpha" do
    context "when given no arguments" do
      it "must return a String containing one alpha digit" do
        expect(subject.alpha).to match(/\A[A-Za-z]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only alpha characters" do
        expect(subject.alpha(length)).to match(/\A[A-Za-z]{#{length}}\z/)
      end
    end
  end

  describe ".alpha_numeric" do
    context "when given no arguments" do
      it "must return a String containing one alpha numeric character" do
        expect(subject.alpha_numeric).to match(/\A[A-Za-z0-9]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only alpha numeric characters" do
        expect(subject.alpha_numeric(length)).to match(/\A[A-Za-z0-9]{#{length}}\z/)
      end
    end
  end

  describe ".punctuation" do
    context "when given no arguments" do
      it "must return a string containing one punctuation character" do
        expect(subject.punctuation).to match(/\A[[:punct:]]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a string of the desired length containing only punctuation characters" do
        expect(subject.punctuation(length)).to match(/\A[[:punct:]]{#{length}}\z/)
      end
    end
  end

  describe ".symbols" do
    context "when given no arguments" do
      it "must return a string containing one symbol character" do
        expect(subject.symbols).to match(%r{\A['"`,;:~\-\(\)\[\]\{\}\.\?!@\#\$%\^&\*_\+=\|\\<>/]\z})
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a string of the desired length containing only symbol characters" do
        expect(subject.symbols(length)).to match(%r{\A['"`,;:~\-\(\)\[\]\{\}\.\?!@\#\$%\^&\*_\+=\|\\<>/]{#{length}}\z})
      end
    end
  end

  describe ".whitespace" do
    context "when given no arguments" do
      it "must return a string containing one whitespace character" do
        expect(subject.whitespace).to match(/\A\s\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a string of the desired length containing only whitespace characters" do
        expect(subject.whitespace(length)).to match(/\A\s{#{length}}\z/)
      end
    end
  end

  describe ".space" do
    context "when given no arguments" do
      it "must return a string containing one whitespace character" do
        expect(subject.space).to match(/\A\s\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a string of the desired length containing only whitespace characters" do
        expect(subject.space(length)).to match(/\A\s{#{length}}\z/)
      end
    end
  end

  describe ".visible" do
    context "when given no arguments" do
      it "must return a string containing one visible character" do
        expect(subject.visible).to match(/\A\p{Graph}\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a string of the desired length containing only visible characters" do
        expect(subject.visible(length)).to match(/\A\p{Graph}{#{length}}\z/)
      end
    end
  end

  describe ".printable" do
    context "when given no arguments" do
      it "must return a string containing one printable character" do
        expect(subject.printable).to match(/\A[[:print:]]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a string of the desired length containing only printable characters" do
        expect(subject.printable(length)).to match(/\A[[:print:]]{#{length}}\z/)
      end
    end
  end

  describe ".control" do
    context "when given no arguments" do
      it "must return a string containing one control character" do
        expect(subject.control).to match(/\A[[:cntrl:]]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a string of the desired length containing only control characters" do
        expect(subject.control(length)).to match(/\A[[:cntrl:]]{#{length}}\z/)
      end
    end
  end

  describe ".signed_ascii" do
    context "when given no arguments" do
      it "must return a string containing one signed ASCII character" do
        expect(subject.signed_ascii).to match(/\A[\x00-\x7F]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a string of the desired length containing only signed ASCII characters" do
        expect(subject.signed_ascii(length)).to match(/\A[\x00-\x7F]{#{length}}\z/)
      end
    end
  end

  describe ".ascii" do
    context "when given no arguments" do
      it "must return a string containing one ASCII character" do
        expect(subject.ascii.length).to eq(1)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a string of the desired length containing only ASCII characters" do
        expect(subject.ascii(length).length).to eq(length)
      end
    end
  end
end
