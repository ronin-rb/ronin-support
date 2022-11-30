require 'spec_helper'
require 'ronin/support/text/core_ext/string'

describe String do
  subject { "hello" }

  it "must provide String#random_case" do
    expect(subject).to respond_to(:random_case)
  end

  describe "#random_case" do
    context "when given an empty String" do
      subject { "" }

      it "must return the empty String" do
        expect(subject.random_case).to eq(subject)
      end
    end

    let(:n) { 100 }

    context "when given a single letter String" do
      subject { 'a' }

      it "must swap the case of the single letter" do
        n.times do
          expect(subject.random_case).to eq(subject.upcase)
        end
      end
    end

    context "when gvien a two letter String" do
      subject { 'ab' }

      it "must swap the case of at least one letter, but not both" do
        n.times do
          expect(subject.random_case).to eq('Ab').or(eq('aB'))
        end
      end
    end

    context "when given a multi-letter String" do
      subject { 'abcd' }

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

      it "must random_case at least one letter, but not all of them" do
        n.times do
          expect(expected_strings).to include(subject.random_case)
        end
      end
    end

    context "when the String contains unicode-letters" do
      subject { "αβγδ" }

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

      it "must random_case at least one unicode-letter, but not all of them" do
        n.times do
          expect(expected_strings).to include(subject.random_case)
        end
      end
    end

    context "when the String contains non-letter characters" do
      subject { 'a b-c' }

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
          expect(expected_strings).to include(subject.random_case)
        end
      end
    end

    context "when the String only contains non-letter characters" do
      subject { %{1234567890`~!@#$%^&*()-_=+[]{}\\|;:'",.<>/?} }

      it "must return the String unchanged" do
        expect(subject.random_case).to eq(subject)
      end
    end
  end
end
