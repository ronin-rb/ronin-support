require 'spec_helper'
require 'ronin/support/text/entropy/core_ext/string'

describe String do
  describe "#entropy" do
    context "when given an empty String" do
      subject { "" }

      it "must return 0.0" do
        expect(subject.entropy).to eq(0.0)
      end
    end

    context "when given a single character String" do
      subject { "a" }

      it "must return 0.0" do
        expect(subject.entropy).to eq(0.0)
      end
    end

    context "when given a two character String" do
      context "and each character is different" do
        subject { "ab" }

        it "must return 1.0" do
          expect(subject.entropy).to eq(1.0)
        end
      end

      context "but both characters are the same" do
        subject { "aa" }

        it "must return 0.0" do
          expect(subject.entropy).to eq(0.0)
        end
      end
    end

    context "when given a three character String" do
      context "and each character is different" do
        subject { "abc" }

        it "must return ~1.58" do
          expect(subject.entropy).to be_within(0.01).of(1.58)
        end
      end

      context "but two characters are the same" do
        subject { "aab" }

        it "must return ~0.91" do
          expect(subject.entropy).to be_within(0.01).of(0.91)
        end
      end

      context "but all characters are the same" do
        subject { "aaa" }

        it "must return 0.0" do
          expect(subject.entropy).to eq(0.0)
        end
      end
    end

    context "when given a 8 character String" do
      context "but all characters are different" do
        subject { "abcdefgh" }

        it "must return 3.0" do
          expect(subject.entropy).to eq(3.0)
        end
      end

      context "but some of the characters are the same" do
        subject { "aacdefgh" }

        it "must return < 3.0" do
          expect(subject.entropy).to be < 3.0
        end
      end

      context "but all of the characters are the same" do
        subject { "aaaaaaaa" }

        it "must return 0.0" do
          expect(subject.entropy).to eq(0.0)
        end
      end
    end

    context "when given a 16 character String" do
      context "but all characters are different" do
        subject { "abcdefghijklmnop" }

        it "must return 4.0" do
          expect(subject.entropy).to eq(4.0)
        end
      end

      context "but some of the characters are the same" do
        subject { "aacdefghijklmnop" }

        it "must return < 4.0" do
          expect(subject.entropy).to be < 4.0
        end
      end

      context "but all of the characters are the same" do
        subject { "aaaaaaaaaaaaaaaa" }

        it "must return 0.0" do
          expect(subject.entropy).to eq(0.0)
        end
      end
    end

    context "when the base: keyword argument" do
      subject { "abc" }

      it "must calculate the entropy for the given base" do
        expect(subject.entropy(base: 3)).to eq(1.0)
      end
    end
  end
end
