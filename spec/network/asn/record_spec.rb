require 'spec_helper'
require 'ronin/support/network/asn/record'
require 'ronin/support/network/ip_range/cidr'

describe Ronin::Support::Network::ASN::Record do
  let(:number)       { 3356 }
  let(:cidr)         { '4.0.0.0/9' }
  let(:range)        { Ronin::Support::Network::IPRange::CIDR.new(cidr) }
  let(:country_code) { 'US'     }
  let(:name)         { 'LEVEL3' }

  subject { described_class.new(number,range,country_code,name) }

  describe "#initialize" do
    it "must set #number" do
      expect(subject.number).to eq(number)
    end

    it "must set #range" do
      expect(subject.range).to eq(range)
    end

    it "must set #country_code" do
      expect(subject.country_code).to eq(country_code)
    end

    it "must set #name" do
      expect(subject.name).to eq(name)
    end
  end

  describe "#routed?" do
    context "when #number is not 0" do
      it "must return true" do
        expect(subject.routed?).to be(true)
      end
    end

    context "but when #number is 0" do
      let(:number)       { 0   }
      let(:country_code) { nil }
      let(:name)         { nil }

      it "must return false" do
        expect(subject.routed?).to be(false)
      end
    end
  end

  describe "#not_routed?" do
    context "when #number is 0" do
      let(:number)       { 0   }
      let(:country_code) { nil }
      let(:name)         { nil }

      it "must return true" do
        expect(subject.not_routed?).to be(true)
      end
    end

    context "but when #number is not 0" do
      it "must return false" do
        expect(subject.not_routed?).to be(false)
      end
    end
  end

  describe "#include?" do
    context "when the given IP address belongs to the range" do
      let(:ip) { '4.4.4.4' }

      it "must return true" do
        expect(subject.include?(ip)).to be(true)
      end
    end

    context "when the given IP address does not belong to the range" do
      let(:ip) { '1.1.1.1' }

      it "must return false" do
        expect(subject.include?(ip)).to be(false)
      end
    end
  end

  describe "#each" do
    let(:range) { Ronin::Support::Network::IPRange::CIDR.new('1.1.1.1/24') }

    context "whne given a block" do
      it "must enumerate over every IP address in the range" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(*range.each.to_a)
      end
    end

    context "when not given a block" do
      it "must return an Enumerator for the #each method" do
        expect(subject.each.to_a).to eq(range.each.to_a)
      end
    end
  end

  describe "#==" do
    context "when given another #{described_class} object" do
      let(:number)       { 3356 }
      let(:cidr)         { '4.0.0.0/9' }
      let(:range)        { Ronin::Support::Network::IPRange::CIDR.new(cidr) }
      let(:country_code) { 'US'     }
      let(:name)         { 'LEVEL3' }

      let(:other_number)       { number }
      let(:other_cidr)         { cidr }
      let(:other_range)        { Ronin::Support::Network::IPRange::CIDR.new(other_cidr) }
      let(:other_country_code) { country_code }
      let(:other_name)         { name }

      let(:other) do
        described_class.new(
          other_number,
          other_range,
          other_country_code,
          other_name
        )
      end

      context "but the #number attributes are different" do
        let(:other_number) { 1234 }

        it "must return false" do
          expect(subject == other).to be(false)
        end
      end

      context "but the #range attributes are different" do
        let(:other_cidr) { '1.0.0.0/24' }

        it "must return false" do
          expect(subject == other).to be(false)
        end
      end

      context "but the #country_code attributes are different" do
        let(:other_country_code) { 'JP' }

        it "must return false" do
          expect(subject == other).to be(false)
        end
      end

      context "but the #name attributes are different" do
        let(:other_name) { 'FOO' }

        it "must return false" do
          expect(subject == other).to be(false)
        end
      end

      context "and when all attributes are the same" do
        it "must return true" do
          expect(subject == other).to be(true)
        end
      end
    end

    context "when given an Object" do
      let(:other) { Object.new }

      it "must return false" do
        expect(subject == other).to eq(false)
      end
    end
  end
end
