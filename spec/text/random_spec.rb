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
end
