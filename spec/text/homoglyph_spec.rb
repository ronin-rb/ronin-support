require 'spec_helper'
require 'ronin/support/text/homoglyph'

describe Ronin::Support::Text::Homoglyph do
  describe ".table" do
    context "when given no arguments" do
      it "must return #{described_class}::DEFAULT" do
        expect(subject.table).to be(described_class::DEFAULT)
      end
    end

    context "when given the :ascii: argument" do
      it "must return #{described_class}::ASCII" do
        expect(subject.table(:ascii)).to be(described_class::ASCII)
      end
    end

    context "when given the :greek argument" do
      it "must return #{described_class}::GREEK" do
        expect(subject.table(:greek)).to be(described_class::GREEK)
      end
    end

    context "when given the :cyrillic keyword argument" do
      it "must return #{described_class}::CYRILLIC" do
        expect(subject.table(:cyrillic)).to be(described_class::CYRILLIC)
      end
    end

    context "when given the :punctuation keyword argument" do
      it "must return #{described_class}::PUNCTUATION" do
        expect(subject.table(:punctuation)).to be(described_class::PUNCTUATION)
      end
    end

    context "when given the :latin_numbers keyword argument" do
      it "must return #{described_class}::LATIN_NUNBERS" do
        expect(subject.table(:latin_numbers)).to be(described_class::LATIN_NUMBERS)
      end
    end

    context "when given the :full_width keyword argument" do
      it "must return #{described_class}::FULL_WIDTH" do
        expect(subject.table(:full_width)).to be(described_class::FULL_WIDTH)
      end
    end

    context "when given an unknown argument" do
      let(:char_set) { :foo }

      it do
        expect {
          subject.table(char_set)
        }.to raise_error(ArgumentError,"unknown homoglyph character set (#{char_set.inspect}), must be :ascii, :greek, :cyrillic, :punctuation, :latin_numbers, :full_width")
      end
    end
  end

  let(:word) { 'CEO' }
  let(:homoglyphs) do
    %w[
      ϹEO
      СEO
      ⅭEO
      ＣEO
      CΕO
      CЕO
      CＥO
      CEΟ
      CEО
      CEＯ
    ]
  end

  describe ".substitute" do
    it "must return a random homoglyph substitution using the default table of homoglyphs" do
      expect(homoglyphs).to include(subject.substitute(word))
    end

    context "when given the char_set: keyword argument" do
      let(:char_set)   { :greek }
      let(:homoglyphs) { described_class::GREEK.each_substitution(word).to_a }

      it "must return a random homoglyph substitution using the given character set's table" do
        expect(homoglyphs).to include(subject.substitute(word, char_set: char_set))
      end

      context "when there is no homoglyphic substitution possible" do
        let(:word) { '   ' }

        it do
          expect {
            subject.substitute(word, char_set: char_set)
          }.to raise_error(Ronin::Support::Text::Homoglyph::NotViable,"no homoglyph replaceable characters found in String (#{word.inspect})")
        end
      end
    end

    context "when there is no homoglyphic substitution possible" do
      let(:word) { '   ' }

      it do
        expect {
          subject.substitute(word)
        }.to raise_error(Ronin::Support::Text::Homoglyph::NotViable,"no homoglyph replaceable characters found in String (#{word.inspect})")
      end
    end
  end

  describe ".each_substitution" do
    context "when given a block" do
      it "must yield all homoglyph substitutions using the default table" do
        expect { |b|
          subject.each_substitution(word,&b)
        }.to yield_successive_args(*homoglyphs)
      end

      context "when there is no homoglyphic substitution possible" do
        let(:word) { '   ' }

        it do
          expect { |b|
            subject.each_substitution(word,&b)
          }.to_not yield_control
        end
      end

      context "when given the char_set: keyword argument" do
        let(:char_set)   { :greek }
        let(:homoglyphs) { described_class::GREEK.each_substitution(word).to_a }

        it "must yield all homoglyph substitutions using the given character set's table" do
          expect { |b|
            subject.each_substitution(word, char_set: char_set, &b)
          }.to yield_successive_args(*homoglyphs)
        end

        context "when there is no homoglyphic substitution possible" do
          let(:word) { '   ' }

          it do
            expect { |b|
              subject.each_substitution(word, char_set: char_set, &b)
            }.to_not yield_control
          end
        end
      end
    end

    context "when not given a block" do
      it "must return an Enumerator for #each_substitution" do
        expect(subject.each_substitution(word).to_a).to eq(homoglyphs)
      end

      context "when there is no homoglyphic substitution possible" do
        let(:word) { '   ' }

        it "must return an Enumerator for #each_substitution" do
          expect(subject.each_substitution(word).to_a).to eq([])
        end
      end

      context "when given the char_set: keyword argument" do
        let(:char_set)   { :greek }
        let(:homoglyphs) { described_class::GREEK.each_substitution(word).to_a }

        it "must return an Enumerator for #each_substitution" do
          expect(subject.each_substitution(word, char_set: char_set).to_a).to eq(homoglyphs)
        end

        context "when there is no homoglyphic substitution possible" do
          let(:word) { '   ' }

          it "must return an Enumerator for #each_substitution" do
            expect(subject.each_substitution(word, char_set: char_set).to_a).to eq([])
          end
        end
      end
    end
  end
end
