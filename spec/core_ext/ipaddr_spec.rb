require 'spec_helper'
require 'ronin/support/core_ext/ipaddr'

describe IPAddr do
  describe "#each" do
    context "when the IPAddr does not have a network mask" do
      let(:address) { '10.1.1.2' }

      subject { described_class.new(address) }

      it "must only iterate over the one IP address for the IPAddr" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(address)
      end

      context "when no block is given" do
        it "must return an Enumerator when no block is given" do
          expect(subject.each.to_a).to eq([address])
        end
      end
    end

    context "when the IPAddr does have a network mask" do
      let(:address) { '10.1.1.2' }
      let(:netmask) { 24 }

      subject { described_class.new("#{address}/#{netmask}") }

      let(:ip_addresses) do
        (0..255).map { |d| "10.1.1.#{d}" }
      end

      it "should iterate over all IP addresses contained within the IP range" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(*ip_addresses)
      end

      context "when no block is given" do
        it "must return an Enumerator when no block is given" do
          expect(subject.each.to_a).to eq(ip_addresses)
        end
      end
    end
  end
end
