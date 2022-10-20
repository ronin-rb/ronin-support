require 'spec_helper'
require 'ronin/support/text/homoglyph/core_ext/string'

describe String do
  subject { 'CEO' }

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

  describe "#homoglyph" do
    it "must return a random homoglyph substitution using the default table of homoglyphs" do
      expect(homoglyphs).to include(subject.homoglyph)
    end

    context "when given the char_set: keyword argument" do
      let(:char_set)   { :greek }
      let(:homoglyphs) do
        Ronin::Support::Text::Homoglyph::GREEK.each_substitution(subject).to_a
      end

      it "must return a random homoglyph substitution using the given character set's table" do
        expect(homoglyphs).to include(subject.homoglyph(char_set: char_set))
      end

      context "when there is no homoglyphic substitution possible" do
        subject { '   ' }

        it do
          expect {
            subject.homoglyph(char_set: char_set)
          }.to raise_error(Ronin::Support::Text::Homoglyph::NotViable,"no homoglyph replaceable characters found in String (#{subject.inspect})")
        end
      end
    end

    context "when there is no homoglyphic substitution possible" do
      subject { '   ' }

      it do
        expect {
          subject.homoglyph
        }.to raise_error(Ronin::Support::Text::Homoglyph::NotViable,"no homoglyph replaceable characters found in String (#{subject.inspect})")
      end
    end
  end

  describe "#each_homoglyph" do
    context "when given a block" do
      it "must yield all homoglyph substitutions using the default table" do
        expect { |b|
          subject.each_homoglyph(&b)
        }.to yield_successive_args(*homoglyphs)
      end

      context "when there is no homoglyphic substitution possible" do
        subject { '   ' }

        it do
          expect { |b|
            subject.each_homoglyph(&b)
          }.to_not yield_control
        end
      end

      context "when given the char_set: keyword argument" do
        let(:char_set)   { :greek }
        let(:homoglyphs) do
          Ronin::Support::Text::Homoglyph::GREEK.each_substitution(subject).to_a
        end

        it "must yield all homoglyph substitutions using the given character set's table" do
          expect { |b|
            subject.each_homoglyph(char_set: char_set, &b)
          }.to yield_successive_args(*homoglyphs)
        end

        context "when there is no homoglyphic substitution possible" do
          subject { '   ' }

          it do
            expect { |b|
              subject.each_homoglyph(char_set: char_set, &b)
            }.to_not yield_control
          end
        end
      end
    end

    context "when not given a block" do
      it "must return an Enumerator for #each_homoglyph" do
        expect(subject.each_homoglyph.to_a).to eq(homoglyphs)
      end

      context "when there is no homoglyphic substitution possible" do
        subject { '   ' }

        it "must return an Enumerator for #each_homoglyph" do
          expect(subject.each_homoglyph.to_a).to eq([])
        end
      end

      context "when given the char_set: keyword argument" do
        let(:char_set)   { :greek }
        let(:homoglyphs) do
          Ronin::Support::Text::Homoglyph::GREEK.each_substitution(subject).to_a
        end

        it "must return an Enumerator for #each_homoglyph" do
          expect(subject.each_homoglyph(char_set: char_set).to_a).to eq(homoglyphs)
        end

        context "when there is no homoglyphic substitution possible" do
          subject { '   ' }

          it "must return an Enumerator for #each_homoglyph" do
            expect(subject.each_homoglyph(char_set: char_set).to_a).to eq([])
          end
        end
      end
    end
  end

  describe "#homoglyphs" do
    it "must return an Array for #each_homoglyph" do
      expect(subject.homoglyphs).to eq(homoglyphs)
    end

    context "when there is no homoglyphic substitution possible" do
      subject { '   ' }

      it "must return an Array for #each_homoglyph" do
        expect(subject.homoglyphs).to eq([])
      end
    end

    context "when given the char_set: keyword argument" do
      let(:char_set)   { :greek }
      let(:homoglyphs) do
        Ronin::Support::Text::Homoglyph::GREEK.each_substitution(subject).to_a
      end

      it "must return an Array for #each_homoglyph" do
        expect(subject.homoglyphs(char_set: char_set)).to eq(homoglyphs)
      end

      context "when there is no homoglyphic substitution possible" do
        subject { '   ' }

        it "must return an Array for #each_homoglyph" do
          expect(subject.homoglyphs(char_set: char_set)).to eq([])
        end
      end
    end
  end
end
