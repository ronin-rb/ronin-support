require 'spec_helper'
require 'ronin/support/network/public_suffix/suffix_set'
require 'ronin/support/network/public_suffix/list'

describe Ronin::Support::Network::PublicSuffix::SuffixSet do
  let(:fixtures_dir) { File.join(__dir__,'fixtures') }
  let(:list_file)    { File.join(fixtures_dir,'public_suffix_list.dat') }
  let(:suffixes) do
    Ronin::Support::Network::PublicSuffix::List.parse(list_file).to_a
  end

  subject { described_class.new(suffixes) }

  describe "#initialize" do
    context "when given no arguments" do
      subject { described_class.new }

      it "must initialize #suffixes to []" do
        expect(subject.suffixes).to eq([])
      end
    end

    context "when given an Enumerator::Lazy" do
      let(:suffixes) { super().lazy }

      subject { described_class.new(suffixes) }

      it "must set #suffixes" do
        expect(subject.suffixes).to eq(suffixes)
      end
    end
  end

  describe "#<<" do
    let(:sufix1) { suffixes[0] }
    let(:sufix2) { suffixes[1] }

    subject { described_class.new }

    it "must append the sufix to #suffixes" do
      subject << sufix1
      subject << sufix2

      expect(subject.suffixes).to eq([sufix1, sufix2])
    end

    it "must return self" do
      expect(subject << sufix1).to be(subject)
    end
  end

  describe "#each" do
    context "when given a block" do
      it "must yield each sufix in the sufix set" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(*suffixes)
      end
    end

    context "when not given a block" do
      it "must return an Enumerator for #each" do
        expect(subject.each.to_a).to eq(suffixes)
      end
    end
  end

  describe "#icann" do
    subject { super().icann }

    it "must return a #{described_class}" do
      expect(subject).to be_kind_of(described_class)
    end

    it "must return the ICANN suffixes" do
      expect(subject.suffixes).to be_kind_of(Enumerator::Lazy)
      expect(subject.suffixes.to_a).to_not be_empty
      expect(subject.suffixes.to_a).to all(be_icann)
    end
  end

  describe "#private" do
    subject { super().private }

    it "must return a #{described_class}" do
      expect(subject).to be_kind_of(described_class)
    end

    it "must return the private suffixes" do
      expect(subject.suffixes).to be_kind_of(Enumerator::Lazy)
      expect(subject.suffixes.to_a).to_not be_empty
      expect(subject.suffixes.to_a).to all(be_private)
    end
  end

  describe "#wildcards" do
    subject { super().wildcards }

    it "must return a #{described_class}" do
      expect(subject).to be_kind_of(described_class)
    end

    it "must return the wildcard suffixes" do
      expect(subject.suffixes).to be_kind_of(Enumerator::Lazy)
      expect(subject.suffixes.to_a).to_not be_empty
      expect(subject.suffixes.to_a).to all(be_wildcard)
    end
  end

  describe "#non_wildcards" do
    subject { super().non_wildcards }

    it "must return a #{described_class}" do
      expect(subject).to be_kind_of(described_class)
    end

    it "must return the non-wildcard suffixes" do
      expect(subject.suffixes).to be_kind_of(Enumerator::Lazy)
      expect(subject.suffixes.to_a).to_not be_empty
      expect(subject.suffixes.to_a).to all(be_non_wildcard)
    end
  end

  describe "#length" do
    it "must return the number of suffixes" do
      expect(subject.length).to eq(suffixes.length)
    end
  end

  describe "#to_a" do
    context "when suffixes is an Array" do
      subject { super().to_a }

      it "must return an Array of Ronin::Support::Network::ASN::Record objects" do
        expect(subject).to be_kind_of(Array)
        expect(subject).to all(be_kind_of(Ronin::Support::Network::PublicSuffix::Suffix))
      end
    end

    context "when suffixes is an Enumerator::Lazy object" do
      subject do
        described_class.new(
          super().icann
        ).to_a
      end

      it "must convert suffixes to an Array" do
        expect(subject).to be_kind_of(Array)
        expect(subject).to all(be_kind_of(Ronin::Support::Network::PublicSuffix::Suffix))
      end
    end
  end
end
