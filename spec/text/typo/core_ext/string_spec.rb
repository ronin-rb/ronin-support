require 'spec_helper'
require 'ronin/support/text/typo/core_ext/string'

describe String do
  subject { "consciousness" }

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

  describe "#typo" do
    it "must return the word but containing a single typo" do
      expect(typos).to include(subject.typo)
    end

    it "must not change the original given String" do
      subject.typo

      expect(subject).to eq("consciousness")
    end

    it "must return a new String each time" do
      expect(subject.typo).to_not be(subject.typo)
    end

    context "when given the `omit_chars: true` keyword argument" do
      let(:typos) do
        Ronin::Support::Text::Typo::OMIT_CHARS.each_substitution(subject).to_a
      end

      it "must only return an omitted character typo" do
        expect(typos).to include(subject.typo(omit_chars: true))
      end
    end

    context "when given the `repeat_chars: true` keyword argument" do
      let(:typos) do
        Ronin::Support::Text::Typo::REPEAT_CHARS.each_substitution(subject).to_a
      end

      it "must only return a repeated character typo" do
        expect(typos).to include(subject.typo(repeat_chars: true))
      end
    end

    context "when given the `swap_chars: true` keyword argument" do
      let(:typos) do
        Ronin::Support::Text::Typo::SWAP_CHARS.each_substitution(subject).to_a
      end

      it "must only return a swapped character typo" do
        expect(typos).to include(subject.typo(swap_chars: true))
      end
    end

    context "when given the `swap_symbols: true` keyword argument" do
      subject { 'foo-bar' }

      let(:typos) do
        Ronin::Support::Text::Typo::SWAP_SYMBOLS.each_substitution(subject).to_a
      end

      it "must only return a swapped symbol typo" do
        expect(typos).to include(subject.typo(swap_symbols: true))
      end
    end

    context "when given the `change_suffix: true` keyword argument" do
      let(:typos) do
        Ronin::Support::Text::Typo::CHANGE_SUFFIX.each_substitution(subject).to_a
      end

      it "must only return a changed suffix typo" do
        expect(typos).to include(subject.typo(change_suffix: true))
      end
    end

    context "when no substitions can be made to the given word" do
      subject { 'xxx' }

      it do
        expect {
          subject.typo
        }.to raise_error(Ronin::Support::Text::Typo::NoTypoPossible,"no possible typo substitution found in word: #{subject.inspect}")
      end
    end
  end

  describe ".each_typo" do
    context "when given a block" do
      it "must yield every possible typo substitution" do
        expect { |b|
          subject.each_typo(&b)
        }.to yield_successive_args(*typos)
      end

      context "when given the `omit_chars: true` keyword argument" do
        let(:typos) do
          Ronin::Support::Text::Typo::OMIT_CHARS.each_substitution(subject).to_a
        end

        it "must only return an omitted character typo" do
          expect { |b|
            subject.each_typo(omit_chars: true, &b)
          }.to yield_successive_args(*typos)
        end
      end

      context "when given the `repeat_chars: true` keyword argument" do
        let(:typos) do
          Ronin::Support::Text::Typo::REPEAT_CHARS.each_substitution(subject).to_a
        end

        it "must only return a repeated character typo" do
          expect { |b|
            subject.each_typo(repeat_chars: true, &b)
          }.to yield_successive_args(*typos)
        end
      end

      context "when given the `swap_chars: true` keyword argument" do
        let(:typos) do
          Ronin::Support::Text::Typo::SWAP_CHARS.each_substitution(subject).to_a
        end

        it "must only return a swapped character typo" do
          expect { |b|
            subject.each_typo(swap_chars: true, &b)
          }.to yield_successive_args(*typos)
        end
      end

      context "when given the `swap_symbols: true` keyword argument" do
        let(:word) { 'foo-bar' }
        let(:typos) do
          Ronin::Support::Text::Typo::SWAP_SYMBOLS.each_substitution(subject).to_a
        end

        it "must only return a swapped symbol typo" do
          expect { |b|
            subject.each_typo(swap_symbols: true, &b)
          }.to yield_successive_args(*typos)
        end
      end

      context "when given the `change_suffix: true` keyword argument" do
        let(:typos) do
          Ronin::Support::Text::Typo::CHANGE_SUFFIX.each_substitution(subject).to_a
        end

        it "must only return a changed suffix typo" do
          expect { |b|
            subject.each_typo(change_suffix: true, &b)
          }.to yield_successive_args(*typos)
        end
      end

      context "when no typo substitution can be made" do
        subject { "xxx" }

        it do
          expect { |b|
            subject.each_typo(&b)
          }.to_not yield_control
        end
      end
    end

    context "when no block is given" do
      it "must return an Enumerator for #each_substitution" do
        expect(subject.each_typo.to_a).to eq(typos)
      end

      context "when given the `omit_chars: true` keyword argument" do
        let(:typos) do
          Ronin::Support::Text::Typo::OMIT_CHARS.each_substitution(subject).to_a
        end

        it "must only return an omitted character typo" do
          expect(
            subject.each_typo(omit_chars: true).to_a
          ).to eq(typos)
        end
      end

      context "when given the `repeat_chars: true` keyword argument" do
        let(:typos) do
          Ronin::Support::Text::Typo::REPEAT_CHARS.each_substitution(subject).to_a
        end

        it "must only return a repeated character typo" do
          expect(
            subject.each_typo(repeat_chars: true).to_a
          ).to eq(typos)
        end
      end

      context "when given the `swap_chars: true` keyword argument" do
        let(:typos) do
          Ronin::Support::Text::Typo::SWAP_CHARS.each_substitution(subject).to_a
        end

        it "must only return a swapped character typo" do
          expect(
            subject.each_typo(swap_chars: true).to_a
          ).to eq(typos)
        end
      end

      context "when given the `swap_symbols: true` keyword argument" do
        subject { 'foo-bar' }

        let(:typos) do
          Ronin::Support::Text::Typo::swap_symbols.each_substitution(subject).to_a
        end

        it "must only return a swapped symbol typo" do
          expect(
            subject.each_typo(swap_symbols: true).to_a
          ).to eq(typos)
        end
      end

      context "when given the `change_suffix: true` keyword argument" do
        let(:typos) do
          Ronin::Support::Text::Typo::CHANGE_SUFFIX.each_substitution(subject).to_a
        end

        it "must only return a changed suffix typo" do
          expect(
            subject.each_typo(change_suffix: true).to_a
          ).to eq(typos)
        end
      end
    end
  end

  describe "#typos" do
    it "must return an Array for #each_substitution" do
      expect(subject.typos).to eq(typos)
    end

    context "when given the `omit_chars: true` keyword argument" do
      let(:typos) do
        Ronin::Support::Text::Typo::OMIT_CHARS.each_substitution(subject).to_a
      end

      it "must only return an omitted character typo" do
        expect(
          subject.typos(omit_chars: true)
        ).to eq(typos)
      end
    end

    context "when given the `repeat_chars: true` keyword argument" do
      let(:typos) do
        Ronin::Support::Text::Typo::REPEAT_CHARS.each_substitution(subject).to_a
      end

      it "must only return a repeated character typo" do
        expect(
          subject.typos(repeat_chars: true)
        ).to eq(typos)
      end
    end

    context "when given the `swap_chars: true` keyword argument" do
      let(:typos) do
        Ronin::Support::Text::Typo::SWAP_CHARS.each_substitution(subject).to_a
      end

      it "must only return a swapped character typo" do
        expect(
          subject.typos(swap_chars: true)
        ).to eq(typos)
      end
    end

    context "when given the `swap_symbols: true` keyword argument" do
      subject { 'foo-bar' }

      let(:typos) do
        Ronin::Support::Text::Typo::swap_symbols.each_substitution(subject).to_a
      end

      it "must only return a swapped symbol typo" do
        expect(
          subject.typos(swap_symbols: true)
        ).to eq(typos)
      end
    end

    context "when given the `change_suffix: true` keyword argument" do
      let(:typos) do
        Ronin::Support::Text::Typo::CHANGE_SUFFIX.each_substitution(subject).to_a
      end

      it "must only return a changed suffix typo" do
        expect(
          subject.typos(change_suffix: true)
        ).to eq(typos)
      end
    end
  end
end
