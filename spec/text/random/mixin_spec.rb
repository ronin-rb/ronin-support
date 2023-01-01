require 'spec_helper'
require 'ronin/support/text/random/mixin'

describe Ronin::Support::Text::Random::Mixin do
  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  describe ".numeric" do
    context "when given no arguments" do
      it "must return a String containing one numeric digit" do
        expect(subject.random_numeric).to match(/\A\d\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only numeric characters" do
        expect(subject.random_numeric(length)).to match(/\A\d{#{length}}\z/)
      end
    end
  end

  describe ".digits" do
    context "when given no arguments" do
      it "must return a String containing one numeric digit" do
        expect(subject.random_digits).to match(/\A\d\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only numeric characters" do
        expect(subject.random_digits(length)).to match(/\A\d{#{length}}\z/)
      end
    end
  end

  describe ".octal" do
    context "when given no arguments" do
      it "must return a String containing one octal digit" do
        expect(subject.random_octal).to match(/\A[0-7]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only octal characters" do
        expect(subject.random_octal(length)).to match(/\A[0-7]{#{length}}\z/)
      end
    end
  end

  describe ".uppercase_hex" do
    context "when given no arguments" do
      it "must return a String containing one uppercase hexadecimal digit" do
        expect(subject.random_uppercase_hex).to match(/\A[A-F0-9]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only uppercase hexadecimal characters" do
        expect(subject.random_uppercase_hex(length)).to match(/\A[A-F0-9]{#{length}}\z/)
      end
    end
  end

  describe ".upper_hex" do
    context "when given no arguments" do
      it "must return a String containing one uppercase hexadecimal digit" do
        expect(subject.random_upper_hex).to match(/\A[A-F0-9]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only uppercase hexadecimal characters" do
        expect(subject.random_upper_hex(length)).to match(/\A[A-F0-9]{#{length}}\z/)
      end
    end
  end

  describe ".lowercase_hex" do
    context "when given no arguments" do
      it "must return a String containing one lowercase hexadecimal digit" do
        expect(subject.random_lowercase_hex).to match(/\A[a-f0-9]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only lowercase hexadecimal characters" do
        expect(subject.random_lowercase_hex(length)).to match(/\A[a-f0-9]{#{length}}\z/)
      end
    end
  end

  describe ".lower_hex" do
    context "when given no arguments" do
      it "must return a String containing one lowercase hexadecimal digit" do
        expect(subject.random_lower_hex).to match(/\A[a-f0-9]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only lowercase hexadecimal characters" do
        expect(subject.random_lower_hex(length)).to match(/\A[a-f0-9]{#{length}}\z/)
      end
    end
  end

  describe ".hex" do
    context "when given no arguments" do
      it "must return a String containing one hexadecimal digit" do
        expect(subject.random_hex).to match(/\A[A-Fa-f0-9]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only hexadecimal characters" do
        expect(subject.random_hex(length)).to match(/\A[A-Fa-f0-9]{#{length}}\z/)
      end
    end
  end

  describe ".uppercase_alpha" do
    context "when given no arguments" do
      it "must return a String containing one uppercase alpha digit" do
        expect(subject.random_uppercase_alpha).to match(/\A[A-Z]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only uppercase alpha characters" do
        expect(subject.random_uppercase_alpha(length)).to match(/\A[A-Z]{#{length}}\z/)
      end
    end
  end

  describe ".upper_alpha" do
    context "when given no arguments" do
      it "must return a String containing one uppercase alpha digit" do
        expect(subject.random_upper_alpha).to match(/\A[A-Z]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only uppercase alpha characters" do
        expect(subject.random_upper_alpha(length)).to match(/\A[A-Z]{#{length}}\z/)
      end
    end
  end

  describe ".lowercase_alpha" do
    context "when given no arguments" do
      it "must return a String containing one lowercase alpha digit" do
        expect(subject.random_lowercase_alpha).to match(/\A[a-z]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only lowercase alpha characters" do
        expect(subject.random_lowercase_alpha(length)).to match(/\A[a-z]{#{length}}\z/)
      end
    end
  end

  describe ".lower_alpha" do
    context "when given no arguments" do
      it "must return a String containing one lowercase alpha digit" do
        expect(subject.random_lower_alpha).to match(/\A[a-z]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only lowercase alpha characters" do
        expect(subject.random_lower_alpha(length)).to match(/\A[a-z]{#{length}}\z/)
      end
    end
  end

  describe ".alpha" do
    context "when given no arguments" do
      it "must return a String containing one alpha digit" do
        expect(subject.random_alpha).to match(/\A[A-Za-z]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only alpha characters" do
        expect(subject.random_alpha(length)).to match(/\A[A-Za-z]{#{length}}\z/)
      end
    end
  end

  describe ".alpha_numeric" do
    context "when given no arguments" do
      it "must return a String containing one alpha numeric character" do
        expect(subject.random_alpha_numeric).to match(/\A[A-Za-z0-9]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a String of the desired length containing only alpha numeric characters" do
        expect(subject.random_alpha_numeric(length)).to match(/\A[A-Za-z0-9]{#{length}}\z/)
      end
    end
  end

  describe ".punctuation" do
    context "when given no arguments" do
      it "must return a string containing one punctuation character" do
        expect(subject.random_punctuation).to match(/\A[[:punct:]]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a string of the desired length containing only punctuation characters" do
        expect(subject.random_punctuation(length)).to match(/\A[[:punct:]]{#{length}}\z/)
      end
    end
  end

  describe ".symbols" do
    context "when given no arguments" do
      it "must return a string containing one symbol character" do
        expect(subject.random_symbols).to match(/\A['"`,;:~\-\(\)\[\]\{\}\.\?!@\#\$%\^&\*_\+=\|\\<>\/]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a string of the desired length containing only symbol characters" do
        expect(subject.random_symbols(length)).to match(/\A['"`,;:~\-\(\)\[\]\{\}\.\?!@\#\$%\^&\*_\+=\|\\<>\/]{#{length}}\z/)
      end
    end
  end

  describe ".whitespace" do
    context "when given no arguments" do
      it "must return a string containing one whitespace character" do
        expect(subject.random_whitespace).to match(/\A\s\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a string of the desired length containing only whitespace characters" do
        expect(subject.random_whitespace(length)).to match(/\A\s{#{length}}\z/)
      end
    end
  end

  describe ".space" do
    context "when given no arguments" do
      it "must return a string containing one whitespace character" do
        expect(subject.random_space).to match(/\A\s\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a string of the desired length containing only whitespace characters" do
        expect(subject.random_space(length)).to match(/\A\s{#{length}}\z/)
      end
    end
  end

  describe ".visible" do
    context "when given no arguments" do
      it "must return a string containing one visible character" do
        expect(subject.random_visible).to match(/\A\p{Graph}\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a string of the desired length containing only visible characters" do
        expect(subject.random_visible(length)).to match(/\A\p{Graph}{#{length}}\z/)
      end
    end
  end

  describe ".printable" do
    context "when given no arguments" do
      it "must return a string containing one printable character" do
        expect(subject.random_printable).to match(/\A[[:print:]]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a string of the desired length containing only printable characters" do
        expect(subject.random_printable(length)).to match(/\A[[:print:]]{#{length}}\z/)
      end
    end
  end

  describe ".control" do
    context "when given no arguments" do
      it "must return a string containing one control character" do
        expect(subject.random_control).to match(/\A[[:cntrl:]]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a string of the desired length containing only control characters" do
        expect(subject.random_control(length)).to match(/\A[[:cntrl:]]{#{length}}\z/)
      end
    end
  end

  describe ".signed_ascii" do
    context "when given no arguments" do
      it "must return a string containing one signed ASCII character" do
        expect(subject.random_signed_ascii).to match(/\A[\x00-\x7F]\z/)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a string of the desired length containing only signed ASCII characters" do
        expect(subject.random_signed_ascii(length)).to match(/\A[\x00-\x7F]{#{length}}\z/)
      end
    end
  end

  describe ".ascii" do
    context "when given no arguments" do
      it "must return a string containing one ASCII character" do
        expect(subject.random_ascii.length).to eq(1)
      end
    end

    context "when given a length argument" do
      let(:length) { 10 }

      it "must return a string of the desired length containing only ASCII characters" do
        expect(subject.random_ascii(length).length).to eq(length)
      end
    end
  end
end
