require 'spec_helper'
require 'ronin/support/text/typo'

describe Ronin::Support::Text::Typo do
  describe ".omit_chars" do
    it "must return #{described_class}::OMIT_CHARS" do
      expect(subject.omit_chars).to eq(described_class::OMIT_CHARS)
    end
  end

  describe ".repeat_chars" do
    it "must return #{described_class}::REPEAT_CHARS" do
      expect(subject.repeat_chars).to eq(described_class::REPEAT_CHARS)
    end
  end

  describe ".swap_chars" do
    it "must return #{described_class}::SWAP_CHARS" do
      expect(subject.swap_chars).to eq(described_class::SWAP_CHARS)
    end
  end

  describe ".swap_symbols" do
    it "must return #{described_class}::SWAP_SYMBOLS" do
      expect(subject.swap_symbols).to eq(described_class::SWAP_SYMBOLS)
    end
  end

  describe ".change_suffix" do
    it "must return #{described_class}::CHANGE_SUFFIX" do
      expect(subject.change_suffix).to eq(described_class::CHANGE_SUFFIX)
    end
  end

  describe ".generator" do
    context "when given no keyword arguments" do
      it "must return #{described_class}::DEFAULT" do
        expect(subject.generator).to be(described_class::DEFAULT)
      end
    end

    context "when given a single keyword argument" do
      subject { described_class.generator(omit_chars: true) }

      it "must return a new #{described_class}::Rules object" do
        expect(subject).to be_kind_of(described_class::Generator)
        expect(subject).to_not be(described_class.generator(omit_chars: true))
      end

      it "must contain the rules of the associated constant" do
        expect(subject.rules).to eq(described_class::OMIT_CHARS.rules)
      end
    end

    context "when given two keyword arguments" do
      subject do
        described_class.generator(omit_chars: true, swap_chars: true)
      end

      it "must concat the rules of both associated Rules conatants" do
        expect(subject.rules).to eq(
          described_class::OMIT_CHARS.rules + described_class::SWAP_CHARS.rules
        )
      end
    end
  end

  let(:word) { "consciousness" }
  let(:typos) do
    %w[
      consciusness
      consciosness
      conscuosness
      consciosness
      coonsciousness
      conscioousness
      conssciousness
      conscioussness
      consciousnesss
      consciuosness
      consciousnes
    ]
  end

  describe ".substitute" do
    it "must return the word but containing a single typo" do
      expect(typos).to include(subject.substitute(word))
    end

    it "must not change the original given String" do
      subject.substitute(word)

      expect(word).to eq("consciousness")
    end

    it "must return a new String each time" do
      expect(subject.substitute(word)).to_not be(subject.substitute(word))
    end

    context "when given the `omit_chars: true` keyword argument" do
      let(:typos) do
        described_class::OMIT_CHARS.each_substitution(word).to_a
      end

      it "must only return an omitted character typo" do
        expect(typos).to include(subject.substitute(word, omit_chars: true))
      end
    end

    context "when given the `repeat_chars: true` keyword argument" do
      let(:typos) do
        described_class::REPEAT_CHARS.each_substitution(word).to_a
      end

      it "must only return a repeated character typo" do
        expect(typos).to include(subject.substitute(word, repeat_chars: true))
      end
    end

    context "when given the `swap_chars: true` keyword argument" do
      let(:typos) do
        described_class::SWAP_CHARS.each_substitution(word).to_a
      end

      it "must only return a swapped character typo" do
        expect(typos).to include(subject.substitute(word, swap_chars: true))
      end
    end

    context "when given the `swap_symbols: true` keyword argument" do
      let(:word) { 'foo-bar' }
      let(:typos) do
        described_class::SWAP_SYMBOLS.each_substitution(word).to_a
      end

      it "must only return a swapped symbol typo" do
        expect(typos).to include(subject.substitute(word, swap_symbols: true))
      end
    end

    context "when given the `change_suffix: true` keyword argument" do
      let(:typos) do
        described_class::CHANGE_SUFFIX.each_substitution(word).to_a
      end

      it "must only return a changed suffix typo" do
        expect(typos).to include(subject.substitute(word, change_suffix: true))
      end
    end

    context "when no substitions can be made to the given word" do
      let(:word) { 'xxx' }

      it do
        expect {
          subject.substitute(word)
        }.to raise_error(Ronin::Support::Text::Typo::NoTypoPossible,"no possible typo substitution found in word: #{word.inspect}")
      end
    end
  end

  describe ".each_substitution" do
    context "when given a block" do
      it "must yield every possible typo substitution" do
        expect { |b|
          subject.each_substitution(word,&b)
        }.to yield_successive_args(*typos)
      end

      context "when given the `omit_chars: true` keyword argument" do
        let(:typos) do
          described_class::OMIT_CHARS.each_substitution(word).to_a
        end

        it "must only return an omitted character typo" do
          expect { |b|
            subject.each_substitution(word, omit_chars: true, &b)
          }.to yield_successive_args(*typos)
        end
      end

      context "when given the `repeat_chars: true` keyword argument" do
        let(:typos) do
          described_class::REPEAT_CHARS.each_substitution(word).to_a
        end

        it "must only return a repeated character typo" do
          expect { |b|
            subject.each_substitution(word, repeat_chars: true, &b)
          }.to yield_successive_args(*typos)
        end
      end

      context "when given the `swap_chars: true` keyword argument" do
        let(:typos) do
          described_class::SWAP_CHARS.each_substitution(word).to_a
        end

        it "must only return a swapped character typo" do
          expect { |b|
            subject.each_substitution(word, swap_chars: true, &b)
          }.to yield_successive_args(*typos)
        end
      end

      context "when given the `swap_symbols: true` keyword argument" do
        let(:word) { 'foo-bar' }
        let(:typos) do
          described_class::SWAP_SYMBOLS.each_substitution(word).to_a
        end

        it "must only return a swapped symbol typo" do
          expect { |b|
            subject.each_substitution(word, swap_symbols: true, &b)
          }.to yield_successive_args(*typos)
        end
      end

      context "when given the `change_suffix: true` keyword argument" do
        let(:typos) do
          described_class::CHANGE_SUFFIX.each_substitution(word).to_a
        end

        it "must only return a changed suffix typo" do
          expect { |b|
            subject.each_substitution(word, change_suffix: true, &b)
          }.to yield_successive_args(*typos)
        end
      end

      context "when no typo substitution can be made" do
        let(:word) { "xxx" }

        it do
          expect { |b|
            subject.each_substitution(word,&b)
          }.to_not yield_control
        end
      end
    end

    context "when no block is given" do
      it "must return an Enumerator for #each_substitution" do
        expect(subject.each_substitution(word).to_a).to eq(typos)
      end

      context "when given the `omit_chars: true` keyword argument" do
        let(:typos) do
          described_class::OMIT_CHARS.each_substitution(word).to_a
        end

        it "must only return an omitted character typo" do
          expect(
            subject.each_substitution(word, omit_chars: true).to_a
          ).to eq(typos)
        end
      end

      context "when given the `repeat_chars: true` keyword argument" do
        let(:typos) do
          described_class::REPEAT_CHARS.each_substitution(word).to_a
        end

        it "must only return a repeated character typo" do
          expect(
            subject.each_substitution(word, repeat_chars: true).to_a
          ).to eq(typos)
        end
      end

      context "when given the `swap_chars: true` keyword argument" do
        let(:typos) do
          described_class::SWAP_CHARS.each_substitution(word).to_a
        end

        it "must only return a swapped character typo" do
          expect(
            subject.each_substitution(word, swap_chars: true).to_a
          ).to eq(typos)
        end
      end

      context "when given the `swap_symbols: true` keyword argument" do
        let(:word) { 'foo-bar' }
        let(:typos) do
          described_class::SWAP_SYMBOLS.each_substitution(word).to_a
        end

        it "must only return a swapped symbol typo" do
          expect(
            subject.each_substitution(word, swap_symbols: true).to_a
          ).to eq(typos)
        end
      end

      context "when given the `change_suffix: true` keyword argument" do
        let(:typos) do
          described_class::CHANGE_SUFFIX.each_substitution(word).to_a
        end

        it "must only return a changed suffix typo" do
          expect(
            subject.each_substitution(word, change_suffix: true).to_a
          ).to eq(typos)
        end
      end
    end
  end
end
