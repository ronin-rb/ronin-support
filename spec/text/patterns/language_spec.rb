require 'spec_helper'
require 'ronin/support/text/patterns/language'

describe Ronin::Support::Text::Patterns do
  describe "WORD" do
    subject { described_class::WORD }

    it "must not match a single letter" do
      expect('A').to_not match(subject)
    end

    it "must not match a punctuation character" do
      expect('.').to_not match(subject)
    end

    it "must not match a single letter end with a punctuation character" do
      expect('A.').to_not match(subject)
    end

    it "must match two lower-case letters" do
      expect('ab').to match(subject)
    end

    it "must match two upper-case letters" do
      expect('AB').to match(subject)
    end

    it "must match a lower-case letter and a upper-case letter" do
      expect('aB').to match(subject)
    end

    it "must match a upper-case letter and a lower-case letter" do
      expect('Ab').to match(subject)
    end

    it "must match more than two lower-case letters" do
      expect('abcdefg').to match(subject)
    end

    it "must match more than two upper-case letters" do
      expect('ABCDEFG').to match(subject)
    end

    it "must match more than two lower-case and upper-case letters" do
      expect('AbCdEfG').to match(subject)
    end

    ["'", '-', '.'].each do |separator|
      it "must match two lower-case letters separated by a '#{separator}'" do
        expect("a#{separator}b").to match(subject)
      end

      it "must match two upper-case letters separated by a '#{separator}'" do
        expect("A#{separator}B").to match(subject)
      end

      it "must match a lower-case letter and a upper-case letter separated by a '#{separator}'" do
        expect("a#{separator}B").to match(subject)
      end

      it "must match a upper-case letter and a lower-case letter separated by a '#{separator}'" do
        expect("A#{separator}b").to match(subject)
      end

      it "must match more than two lower-case letters and a '#{separator}' character" do
        expect("abcd#{separator}efg").to match(subject)
      end

      it "must match more than two upper-case letters and a '#{separator}' character" do
        expect("ABCD#{separator}EFG").to match(subject)
      end

      it "must match more than two lower-case, upper-case letters, and a '#{separator}' character" do
        expect("AbCd#{separator}EfG").to match(subject)
      end
    end
  end
end
