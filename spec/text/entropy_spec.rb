require 'spec_helper'
require 'ronin/support/text/entropy'

describe Ronin::Support::Text::Entropy do
  describe ".calculate" do
    context "when given an empty String" do
      it "must return 0.0" do
        expect(subject.calculate('')).to eq(0.0)
      end
    end

    context "when given a single character String" do
      it "must return 0.0" do
        expect(subject.calculate('a')).to eq(0.0)
      end
    end

    context "when given a two character String" do
      context "and each character is different" do
        it "must return 1.0" do
          expect(subject.calculate('ab')).to eq(1.0)
        end
      end

      context "but both characters are the same" do
        it "must return 0.0" do
          expect(subject.calculate('aa')).to eq(0.0)
        end
      end
    end

    context "when given a three character String" do
      context "and each character is different" do
        it "must return ~1.58" do
          expect(subject.calculate('abc')).to be_within(0.01).of(1.58)
        end
      end

      context "but two characters are the same" do
        it "must return ~0.91" do
          expect(subject.calculate('aab')).to be_within(0.01).of(0.91)
        end
      end

      context "but all characters are the same" do
        it "must return 0.0" do
          expect(subject.calculate('aaa')).to eq(0.0)
        end
      end
    end

    context "when given a 8 character String" do
      context "but all characters are different" do
        it "must return 3.0" do
          expect(subject.calculate('abcdefgh')).to eq(3.0)
        end
      end

      context "but some of the characters are the same" do
        it "must return < 3.0" do
          expect(subject.calculate('aacdefgh')).to be < 3.0
        end
      end

      context "but all of the characters are the same" do
        it "must return 0.0" do
          expect(subject.calculate('aaaaaaaa')).to eq(0.0)
        end
      end
    end

    context "when given a 16 character String" do
      context "but all characters are different" do
        it "must return 4.0" do
          expect(subject.calculate('abcdefghijklmnop')).to eq(4.0)
        end
      end

      context "but some of the characters are the same" do
        it "must return < 4.0" do
          expect(subject.calculate('aacdefghijklmnop')).to be < 4.0
        end
      end

      context "but all of the characters are the same" do
        it "must return 0.0" do
          expect(subject.calculate('aaaaaaaaaaaaaaaa')).to eq(0.0)
        end
      end
    end

    context "when the base: keyword argument" do
      it "must calculate the entropy for the given base" do
        expect(subject.calculate('abc', base: 3)).to eq(1.0)
      end
    end
  end
end
