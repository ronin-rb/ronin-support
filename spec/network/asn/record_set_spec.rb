require 'spec_helper'
require 'ronin/support/network/asn/record_set'
require 'ronin/support/network/asn/list'

describe Ronin::Support::Network::ASN::RecordSet do
  let(:fixtures_dir) { File.join(__dir__,'fixtures')      }
  let(:list_file)    { File.join(fixtures_dir,'list.tsv') }
  let(:records) do
    Ronin::Support::Network::ASN::List.parse(list_file).to_a
  end

  subject { described_class.new(records) }

  describe "#initialize" do
    context "when given no arguments" do
      subject { described_class.new }

      it "must initialize #records to []" do
        expect(subject.records).to eq([])
      end
    end

    context "when given an Enumerator::Lazy" do
      let(:records) { super().lazy }

      subject { described_class.new(records) }

      it "must set #records" do
        expect(subject.records).to eq(records)
      end
    end
  end

  describe "#<<" do
    let(:record1) { records[0] }
    let(:record2) { records[1] }

    subject { described_class.new }

    it "must append the record to #records" do
      subject << record1
      subject << record2

      expect(subject.records).to eq([record1, record2])
    end

    it "must return self" do
      expect(subject << record1).to be(subject)
    end
  end

  describe "#each" do
    context "when given a block" do
      it "must yield each record in the record set" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(*records)
      end
    end

    context "when not given a block" do
      it "must return an Enumerator for #each" do
        expect(subject.each.to_a).to eq(records)
      end
    end
  end

  describe "#numbers" do
    subject { super().numbers }

    it "must return a Set of all record numbers" do
      expect(subject).to be_kind_of(Set)
      expect(subject).to eq(records.map(&:number).to_set)
    end
  end

  describe "#number" do
    let(:number) { 38803 }

    subject { super().number(number) }

    it "must return a #{described_class}" do
      expect(subject).to be_kind_of(described_class)
    end

    it "must initialize the new #{described_class} with a Enumerator::Lazy for records with the matching number" do
      expect(subject.records).to be_kind_of(Enumerator::Lazy)
      expect(subject.records.to_a).to eq(records.select { |record|
        record.number == number
      })
    end
  end

  describe "#countries" do
    subject { super().countries }

    it "must return a Set of all record country_codes" do
      expect(subject).to be_kind_of(Set)
      expect(subject).to eq(records.map(&:country_code).to_set)
    end
  end

  describe "#country" do
    let(:country) { 'US' }

    subject { super().country(country) }

    it "must return a #{described_class}" do
      expect(subject).to be_kind_of(described_class)
    end

    it "must initialize the new #{described_class} with a Enumerator::Lazy for records with the matching country_code" do
      expect(subject.records).to be_kind_of(Enumerator::Lazy)
      expect(subject.records.to_a).to eq(records.select { |record|
        record.country_code == country_code
      })
    end
  end

  describe "#ranges" do
    subject { super().ranges }

    it "must return an Array of all record ranges" do
      expect(subject).to eq(records.map(&:ranges))
    end
  end

  describe "#ip" do
    context "when one of the record's range includes the IP address" do
      let(:ip) { '1.1.1.1' }

      subject { super().ip(ip) }

      it "must return the record who's range includes the IP address" do
        expect(subject).to be_kind_of(Ronin::Support::Network::ASN::Record)
        expect(subject.range).to include(ip)
      end
    end

    context "when no record's range includes the IP address" do
      let(:ip) { '255.255.255.255' }

      subject { super().ip(ip) }

      it "must return nil" do
        expect(subject).to be(nil)
      end
    end
  end

  describe "#include?" do
    context "when one of the record's range includes the IP address" do
      let(:ip) { '1.1.1.1' }

      it "must return true" do
        expect(subject.include?(ip)).to be(true)
      end
    end

    context "when no record's range includes the IP address" do
      let(:ip) { '255.255.255.255' }

      it "must return false" do
        expect(subject.include?(ip)).to be(false)
      end
    end
  end

  describe "#names" do
    subject { super().names }

    it "must return a Set of all record names" do
      expect(subject).to be_kind_of(Set)
      expect(subject).to eq(records.map(&:names).to_set)
    end
  end

  describe "#name" do
    let(:name) { 'CLOUDFLARENET' }

    subject { super().name(name) }

    it "must return a #{described_class}" do
      expect(subject).to be_kind_of(described_class)
    end

    it "must initialize the new #{described_class} with a Enumerator::Lazy for records with the matching name" do
      expect(subject.records).to be_kind_of(Enumerator::Lazy)
      expect(subject.records.to_a).to eq(records.select { |record|
        record.name == name
      })
    end
  end

  describe "#length" do
    it "must return the number of records" do
      expect(subject.length).to eq(records.length)
    end
  end

  describe "#to_a" do
    context "when records is an Array" do
      subject { super().to_a }

      it "must return an Array of Ronin::Support::Network::ASN::Record objects" do
        expect(subject).to be_kind_of(Array)
        expect(subject).to all(be_kind_of(Ronin::Support::Network::ASN::Record))
      end
    end

    context "when records is an Enumerator::Lazy object" do
      subject do
        described_class.new(
          super().name('CLOUDFLARENET')
        )
      end

      it "must convert records to an Array" do
        expect(subject).to be_kind_of(Array)
        expect(subject).to all(be_kind_of(Ronin::Support::Network::ASN::Record))
      end
    end
  end
end
