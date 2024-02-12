require 'spec_helper'
require 'ronin/support/network/ip_range'

describe Ronin::Support::Network::IPRange do
  let(:cidr) { '10.1.1.2/24' }
  let(:glob) { "10.1.1.*"    }

  describe "#initialize" do
    context "when initialized with a CIDR IP range" do
      subject { described_class.new(cidr) }

      it "must set #string to the CIDR IP range" do
        expect(subject.string).to eq(cidr)
      end
    end

    context "when initialized with a IP glob range" do
      subject { described_class.new(glob) }

      it "must set #string" do
        expect(subject.string).to eq(glob)
      end
    end

    context "when the IP range string is neither a CIDR range or a IP-glob range" do
      let(:string) { 'foo' }

      it do
        expect {
          described_class.new(string)
        }.to raise_error(ArgumentError,"invalid IP range: #{string.inspect}")
      end
    end
  end

  describe ".parse" do
    context "when initialized with a CIDR IP range" do
      subject { described_class.parse(cidr) }

      it "must return a #{described_class}" do
        expect(subject).to be_kind_of(described_class)
      end

      it "must set #string" do
        expect(subject.string).to eq(cidr)
      end
    end

    context "when initialized with a IP glob range" do
      subject { described_class.parse(glob) }

      it "must return a #{described_class}" do
        expect(subject).to be_kind_of(described_class)
      end

      it "must set #string" do
        expect(subject.string).to eq(glob)
      end
    end
  end

  describe ".each" do
    subject { described_class }

    context "when given a CIDR IP range" do
      context "when initialized with a class-D IP address" do
        let(:cidr) { '10.1.1.2' }

        it "must only iterate over one IP address for an address" do
          expect { |b|
            subject.each(cidr,&b)
          }.to yield_with_args(cidr)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(described_class.each(cidr).to_a).to eq([cidr])
          end
        end
      end

      context "when initialized with a class-C IP address range" do
        let(:cidr) { '10.1.1.2/24' }
        let(:addresses) do
          (0..255).map { |d| "10.1.1.#{d}" }
        end

        it "must iterate over every IP address within the IP range" do
          yielded_addresses = []

          subject.each(cidr) do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
        end

        context "when no block is given" do
          it "must return an Enumerator" do
            expect(described_class.each(cidr).to_a).to eq(addresses)
          end
        end
      end
    end

    context "when given a IP glob range" do
      context "and when the IP address range contains '*'" do
        context "and when the IP address is a v4 address" do
          let(:glob) { "10.1.1.*" }
          let(:addresses) do
            (0..255).map { |d| "10.1.1.#{d}" }
          end

          it "must expand '*' globs to 1-254" do
            yielded_addresses = []

            subject.each(glob) do |address|
              yielded_addresses << address
            end

            expect(yielded_addresses).to eq(addresses)
          end

          context "but no block is given" do
            it "must return an Enumerator" do
              expect(subject.each(glob).to_a).to eq(addresses)
            end
          end
        end

        context "and when the IP address is a v6 address" do
          let(:glob) { "fe80::abc:*" }
          let(:addresses) do
            (0..0xffff).map { |d| "fe80::abc:%x" % d }
          end

          it "must expand '*' globs to 01-fe" do
            yielded_addresses = []

            subject.each(glob) do |address|
              yielded_addresses << address
            end

            expect(yielded_addresses).to eq(addresses)
          end

          context "but no block is given" do
            it "must return an Enumerator" do
              expect(subject.each(glob).to_a).to eq(addresses)
            end
          end
        end
      end
    end

    context "when the IP address range contains 'i-j'" do
      context "and when the IP address is a v4 address" do
        let(:glob) { "10.1.1.10-20" }
        let(:addresses) do
          (10..20).map { |d| "10.1.1.#{d}" }
        end

        it "must expend 'i-j' ranges" do
          yielded_addresses = []

          subject.each(glob) do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each(glob).to_a).to eq(addresses)
          end
        end
      end

      context "and when the IP address is a v6 address" do
        let(:glob) { "fe80::abc:a-14" }
        let(:addresses) do
          (0x0a..0x14).map { |d| "fe80::abc:%x" % d }
        end

        it "must expand 'i-j' ranges" do
          yielded_addresses = []

          subject.each(glob) do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each(glob).to_a).to eq(addresses)
          end
        end
      end
    end

    context "when the IP address range contains 'i,j,k'" do
      context "and when the IP address is a v4 address" do
        let(:glob) { "10.1.1.1,2,4" }
        let(:addresses) do
          [1,2,4].map { |d| "10.1.1.#{d}" }
        end

        it "must expand 'i,j,k' ranges" do
          yielded_addresses = []

          subject.each(glob) do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each(glob).to_a).to eq(addresses)
          end
        end
      end

      context "and when the IP address is a v6 address" do
        let(:glob) { "fe80::abc:1,2,4" }
        let(:addresses) do
          [0x01, 0x02, 0x04].map { |d| "fe80::abc:%x" % d }
        end

        it "must expand 'i,j,k' ranges" do
          yielded_addresses = []

          subject.each(glob) do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each(glob).to_a).to eq(addresses)
          end
        end
      end
    end

    context "when the IP address range contains 'i,j-k'" do
      context "and when the IP address is a v4 address" do
        let(:glob) { "10.1.1.1,3-4" }
        let(:addresses) do
          [1, *(3..4)].map { |d| "10.1.1.#{d}" }
        end

        it "must expand combination 'i,j-k' ranges" do
          yielded_addresses = []

          subject.each(glob) do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each(glob).to_a).to eq(addresses)
          end
        end
      end

      context "and when the IP address is a v6 address" do
        let(:glob) { "fe80::abc:1,3-4" }
        let(:addresses) do
          [1, *(3..4)].map { |d| "fe80::abc:%x" % d }
        end

        it "must expand 'i,j-k' ranges" do
          yielded_addresses = []

          subject.each(glob) do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each(glob).to_a).to eq(addresses)
          end
        end
      end
    end
  end

  describe "#include?" do
    let(:in_range_ip)     { '10.1.1.2' }
    let(:not_in_range_ip) { '1.1.1.2' }

    context "when initialized with a CIDR IP range" do
      subject { described_class.new(cidr) }

      context "when given a String" do
        it "must determine if the given String exists within the IP CIDR range" do
          expect(subject.include?(in_range_ip)).to be(true)
          expect(subject.include?(not_in_range_ip)).to be(false)
        end
      end

      context "when given an IPAddr object" do
        let(:in_range_ip)     { IPAddr.new(super()) }
        let(:not_in_range_ip) { IPAddr.new(super()) }

        it "must convert the IPAddr object into a String" do
          expect(subject.include?(in_range_ip)).to be(true)
          expect(subject.include?(not_in_range_ip)).to be(false)
        end
      end
    end

    context "when initialized with a IP glob range" do
      subject { described_class.new(glob) }

      context "when given a String" do
        it "must determine if the given String exists within the IP glob range" do
          expect(subject.include?(in_range_ip)).to be(true)
          expect(subject.include?(not_in_range_ip)).to be(false)
        end
      end

      context "when given an IPAddr object" do
        let(:in_range_ip)     { IPAddr.new(super()) }
        let(:not_in_range_ip) { IPAddr.new(super()) }

        it "must convert the IPAddr object into a String" do
          expect(subject.include?(in_range_ip)).to be(true)
          expect(subject.include?(not_in_range_ip)).to be(false)
        end
      end
    end
  end

  describe "#==" do
    context "when initialized with a CIDR range" do
      let(:cidr) { '10.1.1.1/16' }

      subject { described_class.new(cidr) }

      context "when the other IP range is also initialized with a CIDR range" do
        context "and it has the same range as the CIDR range" do
          let(:other) { described_class.new(cidr) }

          it "must return true" do
            expect(subject == other).to be(true)
          end
        end

        context "but it has a different range compared to the CIDR range" do
          let(:other_cidr) { '1.1.1.1/24' }
          let(:other)      { described_class.new(other_cidr) }

          it "must return false" do
            expect(subject == other).to be(false)
          end
        end
      end

      context "when the other IP range is an IP glob range" do
        context "and it has the same range as the CIDR range" do
          let(:other_glob) { '10.1.*.*' }
          let(:other)      { described_class.new(other_glob) }

          it "must return false" do
            expect(subject == other).to be(false)
          end
        end

        context "but it has a different range from the CIDR range" do
          let(:other_glob) { '1.1.1.*' }
          let(:other)      { described_class.new(other_glob) }

          it "must return false" do
            expect(subject == other).to be(false)
          end
        end
      end
    end

    context "when initialized with an IP glob range" do
      let(:glob) { '10.1.1.*' }

      subject { described_class.new(glob) }

      context "when the other IP range is an IP glob range" do
        context "and it has the same range as the IP glob range" do
          let(:other) { described_class.new(glob) }

          it "must return true" do
            expect(subject == other).to be(true)
          end
        end

        context "but it has a different range from the CIDR range" do
          let(:other_glob) { '1.1.1.*' }
          let(:other)      { described_class.new(other_glob) }

          it "must return false" do
            expect(subject == other).to be(false)
          end
        end
      end

      context "when the other IP range is a CIDR range" do
        context "and it has the same range as the CIDR range" do
          let(:other_cidr) { '10.1.1.1/24' }
          let(:other)      { described_class.new(other_cidr) }

          it "must return false" do
            expect(subject == other).to be(false)
          end
        end

        context "but it has a different range compared to the CIDR range" do
          let(:other_cidr) { '1.1.1.1/24' }
          let(:other)      { described_class.new(other_cidr) }

          it "must return false" do
            expect(subject == other).to be(false)
          end
        end
      end
    end
  end

  describe "#===" do
    context "when initialized with a CIDR range" do
      let(:cidr) { '10.1.1.1/24' }

      subject { described_class.new(cidr) }

      context "when given Ronin::Support::Network::CIDR" do
        context "and the other CIDR range overlaps with the CIDR range" do
          let(:other_cidr) { '10.1.1.1/25' }
          let(:other)      { described_class.new(other_cidr) }

          it "must return true" do
            expect(subject === other).to be(true)
          end
        end

        context "and the other CIDR range does not overlap with the CIDR range" do
          let(:other_cidr) { '1.1.1.1/24' }
          let(:other)      { described_class.new(other_cidr) }

          it "must return false" do
            expect(subject === other).to be(false)
          end
        end
      end

      context "when given Ronin::Support::Network::Glob" do
        context "and the other IP glob range overlaps with the CIDR range" do
          let(:other_glob) { '10.1.1.1-254' }
          let(:other)      { described_class.new(other_glob) }

          it "must return true" do
            expect(subject === other).to be(true)
          end
        end

        context "and the other IP glob range does not overlap with the CIDR range" do
          let(:other_glob) { '1.1.1.1-254' }
          let(:other)      { described_class.new(other_glob) }

          it "must return false" do
            expect(subject === other).to be(false)
          end
        end
      end

      context "when given an Enumerable object" do
        let(:other) do
          (0..255).map { |i| "10.1.1.%d" % i }
        end

        context "and every IP in the Enumerable object is included in the CIDR range" do
          it "must return true" do
            expect(subject === other).to be(true)
          end
        end

        context "but one of the IPs in the Enumerable object is not included in the CIDR range" do
          let(:other) { super() + ['10.1.2.1'] }

          it "must return false" do
            expect(subject === other).to be(false)
          end
        end
      end
    end

    context "when initialized with an IP glob range" do
      let(:glob) { '10.1.1.*' }

      subject { described_class.new(glob) }

      context "when given Ronin::Support::Network::Glob" do
        context "and the other IP glob range overlaps with the IP glob range" do
          let(:other_glob) { '10.1.1.1-254' }
          let(:other)      { described_class.new(other_glob) }

          it "must return true" do
            expect(subject === other).to be(true)
          end
        end

        context "and the other IP glob range does not overlap with the IP glob range" do
          let(:other_glob) { '1.1.1.1-254' }
          let(:other)      { described_class.new(other_glob) }

          it "must return false" do
            expect(subject === other).to be(false)
          end
        end
      end

      context "when given Ronin::Support::Network::CIDR" do
        context "and the other CIDR range overlaps with the IP glob range" do
          let(:other_cidr)  { '10.1.1.1/25' }
          let(:other)       { described_class.new(other_cidr) }

          it "must return true" do
            expect(subject === other).to be(true)
          end
        end

        context "and the other CIDR range does not overlap with the IP glob range" do
          let(:other_cidr) { '1.1.1.1/24' }
          let(:other)      { described_class.new(other_cidr) }

          it "must return false" do
            expect(subject === other).to be(false)
          end
        end
      end

      context "when given an Enumerable object" do
        let(:other) do
          (0..255).map { |i| "10.1.1.%d" % i }
        end

        context "and every IP in the Enumerable object is included in the IP glob range" do
          it "must return true" do
            expect(subject === other).to be(true)
          end
        end

        context "but one of the IPs in the Enumerable object is not included in the IP glob range" do
          let(:other) { super() + ['10.1.2.1'] }

          it "must return false" do
            expect(subject === other).to be(false)
          end
        end
      end
    end
  end

  describe "#each" do
    context "when initialized with a CIDR IP range" do
      context "and when initialized with a class-D IP address" do
        let(:cidr) { '10.1.1.2' }
        subject { described_class.new(cidr) }

        it "must only iterate over one IP address for an address" do
          expect { |b|
            subject.each(&b)
          }.to yield_with_args(cidr)
        end

        context "but no block is given" do
          it "must return an Enumerator" do
            expect(subject.each.to_a).to eq([cidr])
          end
        end
      end

      context "and when initialized with a class-C IP address range" do
        let(:cidr) { '10.1.1.2/24' }
        let(:addresses) do
          (0..255).map { |d| "10.1.1.#{d}" }
        end

        subject { described_class.new(cidr) }

        it "must iterate over every IP address within the IP range" do
          yielded_addresses = []

          subject.each do |address|
            yielded_addresses << address
          end

          expect(yielded_addresses).to eq(addresses)
        end

        context "when no block is given" do
          it "must return an Enumerator" do
            expect(subject.each.to_a).to eq(addresses)
          end
        end
      end
    end

    context "when initialized with a IP glob range" do
      subject { described_class.new(glob) }

      context "and when the IP address range contains '*'" do
        context "and when the IP address is a v4 address" do
          let(:glob) { "10.1.1.*" }
          let(:addresses) do
            (0..255).map { |d| "10.1.1.#{d}" }
          end

          it "must expand '*' globs to 1-254" do
            yielded_addresses = []

            subject.each do |address|
              yielded_addresses << address
            end

            expect(yielded_addresses).to eq(addresses)
          end

          context "but no block is given" do
            it "must return an Enumerator" do
              expect(subject.each.to_a).to eq(addresses)
            end
          end
        end

        context "and when the IP address is a v6 address" do
          let(:glob) { "fe80::abc:*" }
          let(:addresses) do
            (0..0xffff).map { |d| "fe80::abc:%x" % d }
          end

          it "must expand '*' globs to 01-fe" do
            yielded_addresses = []

            subject.each do |address|
              yielded_addresses << address
            end

            expect(yielded_addresses).to eq(addresses)
          end

          context "but no block is given" do
            it "must return an Enumerator" do
              expect(subject.each.to_a).to eq(addresses)
            end
          end
        end
      end

      context "when the IP address range contains 'i-j'" do
        context "and when the IP address is a v4 address" do
          let(:glob) { "10.1.1.10-20" }
          let(:addresses) do
            (10..20).map { |d| "10.1.1.#{d}" }
          end

          it "must expend 'i-j' ranges" do
            yielded_addresses = []

            subject.each do |address|
              yielded_addresses << address
            end

            expect(yielded_addresses).to eq(addresses)
          end

          context "but no block is given" do
            it "must return an Enumerator" do
              expect(subject.each.to_a).to eq(addresses)
            end
          end
        end

        context "and when the IP address is a v6 address" do
          let(:glob) { "fe80::abc:a-14" }
          let(:addresses) do
            (0x0a..0x14).map { |d| "fe80::abc:%x" % d }
          end

          it "must expand 'i-j' ranges" do
            yielded_addresses = []

            subject.each do |address|
              yielded_addresses << address
            end

            expect(yielded_addresses).to eq(addresses)
          end

          context "but no block is given" do
            it "must return an Enumerator" do
              expect(subject.each.to_a).to eq(addresses)
            end
          end
        end
      end

      context "when the IP address range contains 'i,j,k'" do
        context "and when the IP address is a v4 address" do
          let(:glob) { "10.1.1.1,2,4" }
          let(:addresses) do
            [1,2,4].map { |d| "10.1.1.#{d}" }
          end

          it "must expand 'i,j,k' ranges" do
            yielded_addresses = []

            subject.each do |address|
              yielded_addresses << address
            end

            expect(yielded_addresses).to eq(addresses)
          end

          context "but no block is given" do
            it "must return an Enumerator" do
              expect(subject.each.to_a).to eq(addresses)
            end
          end
        end

        context "and when the IP address is a v6 address" do
          let(:glob) { "fe80::abc:1,2,4" }
          let(:addresses) do
            [0x01, 0x02, 0x04].map { |d| "fe80::abc:%x" % d }
          end

          it "must expand 'i,j,k' ranges" do
            yielded_addresses = []

            subject.each do |address|
              yielded_addresses << address
            end

            expect(yielded_addresses).to eq(addresses)
          end

          context "but no block is given" do
            it "must return an Enumerator" do
              expect(subject.each.to_a).to eq(addresses)
            end
          end
        end
      end

      context "when the IP address range contains 'i,j-k'" do
        context "and when the IP address is a v4 address" do
          let(:glob) { "10.1.1.1,3-4" }
          let(:addresses) do
            [1, *(3..4)].map { |d| "10.1.1.#{d}" }
          end

          it "must expand combination 'i,j-k' ranges" do
            yielded_addresses = []

            subject.each do |address|
              yielded_addresses << address
            end

            expect(yielded_addresses).to eq(addresses)
          end

          context "but no block is given" do
            it "must return an Enumerator" do
              expect(subject.each.to_a).to eq(addresses)
            end
          end
        end

        context "and when the IP address is a v6 address" do
          let(:glob) { "fe80::abc:1,3-4" }
          let(:addresses) do
            [1, *(3..4)].map { |d| "fe80::abc:%x" % d }
          end

          it "must expand 'i,j-k' ranges" do
            yielded_addresses = []

            subject.each do |address|
              yielded_addresses << address
            end

            expect(yielded_addresses).to eq(addresses)
          end

          context "but no block is given" do
            it "must return an Enumerator" do
              expect(subject.each.to_a).to eq(addresses)
            end
          end
        end
      end
    end
  end

  describe "#first" do
    context "when initialized with a CIDR IP range" do
      subject { described_class.new(cidr) }

      it "must return the first IP address in the CIDR range" do
        expect(subject.first).to eq('10.1.1.0')
      end
    end

    context "when initialized with a IP glob range" do
      subject { described_class.new(glob) }

      it "must return the first IP address in the IP glob range" do
        expect(subject.first).to eq('10.1.1.0')
      end
    end
  end

  describe "#last" do
    context "when initialized with a CIDR IP range" do
      subject { described_class.new(cidr) }

      it "must return the last IP address in the CIDR range" do
        expect(subject.last).to eq('10.1.1.255')
      end
    end

    context "when initialized with a IP glob range" do
      subject { described_class.new(glob) }

      it "must return the last IP address in the IP glob range" do
        expect(subject.last).to eq('10.1.1.255')
      end
    end
  end

  describe "#size" do
    context "when initialized with a CIDR IP range" do
      subject { described_class.new(cidr) }

      it "must return the number of IPs in the CIDR range" do
        expect(subject.size).to eq(256)
      end
    end

    context "when initialized with a IP glob range" do
      subject { described_class.new(glob) }

      it "must return the number of IPs in the IP glob range" do
        expect(subject.size).to eq(256)
      end
    end

    context "when initialized with an IP address" do
      let(:address) { '10.1.1.1' }

      subject { described_class.new(address) }

      it "must return 1" do
        expect(subject.size).to eq(1)
      end
    end
  end

  describe "#to_s" do
    context "when initialized with a CIDR IP range" do
      subject { described_class.new(cidr) }

      it "must return the original string" do
        expect(subject.to_s).to eq(cidr)
      end
    end

    context "when initialized with a IP glob range" do
      subject { described_class.new(glob) }

      it "must return the original string" do
        expect(subject.to_s).to eq(glob)
      end
    end
  end

  describe "#inspect" do
    context "when initialized with a CIDR IP range" do
      subject { described_class.new(cidr) }

      it "must include the class name and original CIDR string" do
        expect(subject.inspect).to eq("#<#{described_class}: #{cidr}>")
      end
    end

    context "when initialized with a IP glob range" do
      subject { described_class.new(glob) }

      it "must include the class name and original string" do
        expect(subject.inspect).to eq("#<#{described_class}: #{glob}>")
      end
    end
  end
end
