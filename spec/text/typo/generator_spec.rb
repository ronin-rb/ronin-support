require 'spec_helper'
require 'ronin/support/text/typo/generator'

describe Ronin::Support::Text::Typo::Generator do
  let(:word) { 'anenome' }

  let(:rules) do
    [
      [/n/,   'm'],
      [/m/,   'n'],
      [/e$/, 'ie']
    ]
  end

  subject { described_class.new(rules) }

  describe "#initialize" do
    it "must set #rules" do
      expect(subject.rules).to eq(rules)
    end
  end

  describe ".[]" do
    subject { described_class[*rules] }

    it "must return a new #{described_class}" do
      expect(subject).to be_kind_of(described_class)
    end

    it "must set #rules using the given arguments" do
      expect(subject.rules).to eq(rules)
    end
  end

  describe "#+" do
    let(:other_rules) do
      [
        [/y$/, 'ey']
      ]
    end

    let(:other) { described_class.new(other_rules) }

    subject { super() + other }

    it "must return a new #{described_class}" do
      expect(subject).to be_kind_of(described_class)
    end

    it "must combine the rules of the generator with the other generator" do
      expect(subject.rules).to eq(rules + other_rules)
    end
  end

  let(:typos) do
    %w[
      amenome
      anemome
      anenone
      anenomie
    ]
  end

  describe "#substitute" do
    it "must return a random typo substitution of the given word" do
      expect(typos).to include(subject.substitute(word))
    end

    it "must not change the original given String" do
      subject.substitute(word)

      expect(word).to eq("anenome")
    end

    context "when no typo substitution can be made" do
      let(:word) { "xxx" }

      it do
        expect {
          subject.substitute(word)
        }.to raise_error(Ronin::Support::Text::Typo::NoTypoPossible,"no possible typo substitution found in word: #{word.inspect}")
      end
    end
  end

  describe "#each_substitution" do
    context "when given a block" do
      it "must yield every possible typo substitution" do
        expect { |b|
          subject.each_substitution(word,&b)
        }.to yield_successive_args(*typos)
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
    end
  end

  describe "#to_a" do
    it "must return the #rules" do
      expect(subject.to_a).to eq(subject.rules)
    end
  end
end
