require 'spec_helper'
require 'ronin/support/network/ip'

describe Ronin::Support::Network::IP do
  let(:address)          { '93.184.216.34' }
  let(:bad_address)      { '0.0.0.0' }
  let(:reverse_address)  { '142.251.33.110' }
  let(:reverse_hostname) { 'sea30s10-in-f14.1e100.net' }

  subject { described_class.new(address) }

  describe "#initialize" do
    it "must set #address" do
      expect(subject.address).to eq(address)
    end
  end

  describe ".extract" do
    subject { described_class }

    context "IPv4" do
      context "when the String contains a single IPv4 address" do
        let(:address) { '127.0.0.1' }
        let(:string ) { address     }

        it "must extract a single IPv4 address" do
          expect(subject.extract(string,:ipv4)).to eq([address])
        end

        context "and when a block is given" do
          it "must yield the IPv4 addresses" do
            expect { |b|
              subject.extract(string,:ipv4,&b)
            }.to yield_successive_args(address)
          end
        end
      end

      context "when the String contains multiple IPv4 addresses" do
        let(:addresses) { %w[127.0.0.1 192.168.0.1] }
        let(:string )   { addresses.join(' ')       }

        it "must extract multiple IPv4 addresses" do
          expect(subject.extract(string,:ipv4)).to eq(addresses)
        end

        context "and when a block is given" do
          it "must yield the IPv4 addresses" do
            expect { |b|
              subject.extract(string,:ipv4,&b)
            }.to yield_successive_args(*addresses)
          end
        end
      end

      context "when the String contains other text" do
        let(:address) { '127.0.0.1'       }
        let(:string)  { "foo (#{address}) bar" }

        it "must extract IPv4 addresses from the String" do
          expect(subject.extract(string,:ipv4)).to eq([address])
        end

        context "and when a block is given" do
          it "must yield the IPv4 addresses" do
            expect { |b|
              subject.extract(string,:ipv4,&b)
            }.to yield_successive_args(address)
          end
        end
      end

      context "when the IP address starts with an additional '.'" do
        let(:address) { '127.0.0.1'   }
        let(:string)  { ".#{address}" }

        it "must ignore leading periods" do
          expect(subject.extract(string,:ipv4)).to eq([address])
        end

        context "and when a block is given" do
          it "must yield the IPv4 addresses" do
            expect { |b|
              subject.extract(string,:ipv4,&b)
            }.to yield_successive_args(address)
          end
        end
      end

      context "when the IP address ends with an additional '.'" do
        let(:address) { '127.0.0.1'   }
        let(:string)  { "#{address}." }

        it "must ignore tailing periods" do
          expect(subject.extract(string,:ipv4)).to eq([address])
        end

        context "and when a block is given" do
          it "must yield the IPv4 addresses" do
            expect { |b|
              subject.extract(string,:ipv4,&b)
            }.to yield_successive_args(address)
          end
        end
      end

      context "when the IP address contains a space" do
        let(:string) { "127.0.0. 1" }

        it "must ignore less than 3 octet IPv4 addresses" do
          expect(subject.extract(string,:ipv4)).to be_empty
        end

        context "and when a block is given" do
          it "must yield the IPv4 addresses" do
            expect { |b|
              subject.extract(string,:ipv4,&b)
            }.to_not yield_control
          end
        end
      end

      context "when the IP address octets contain more than three digits" do
        let(:string) { "127.1111.0.1" }

        it "must ignore IPv4 addresses with more than 3 diget octets" do
          expect(subject.extract(string,:ipv4)).to be_empty
        end

        context "and when a block is given" do
          it "must yield the IPv4 addresses" do
            expect { |b|
              subject.extract(string,:ipv4,&b)
            }.to_not yield_control
          end
        end
      end
    end

    context "IPv6" do
      context "when the String contains a single IPv6 address" do
        let(:address) { 'fe80:0000:0000:0000:0204:61ff:fe9d:f156' }
        let(:string ) { address     }

        it "must extract a single IPv4 address" do
          expect(subject.extract(string,:ipv6)).to eq([address])
        end

        context "and when a block is given" do
          it "must yield the IPv6 addresses" do
            expect { |b|
              subject.extract(string,:ipv6,&b)
            }.to yield_successive_args(address)
          end
        end
      end

      context "when the String contains multiple IPv6 addresses" do
        let(:addresses) { %w[::1 fe80:0000:0000:0000:0204:61ff:fe9d:f156] }
        let(:string )   { addresses.join(' ') }

        it "must extract multiple IPv6 addresses" do
          expect(subject.extract(string,:ipv6)).to eq(addresses)
        end

        context "and when a block is given" do
          it "must yield the IPv6 addresses" do
            expect { |b|
              subject.extract(string,:ipv6,&b)
            }.to yield_successive_args(*addresses)
          end
        end
      end

      context "when the String contains other text" do
        let(:address) { 'fe80::0204:61ff:fe9d:f156' }
        let(:string)  { "foo (#{address}) bar" }

        it "must extract IPv6 addresses from the String" do
          expect(subject.extract(string,:ipv6)).to eq([address])
        end

        context "and when a block is given" do
          it "must yield the IPv6 addresses" do
            expect { |b|
              subject.extract(string,:ipv6,&b)
            }.to yield_successive_args(address)
          end
        end
      end

      context "when the IPv6 address has a trailing IPv4 suffix" do
        let(:address) { '::ffff:192.0.2.128' }
        let(:string)  { "#{address} 1.1.1.1" }

        it "must extract IPv6 addresses with trailing IPv4 suffixes" do
          expect(subject.extract(string,:ipv6)).to eq([address])
        end

        context "and when a block is given" do
          it "must yield the IPv6 addresses with IPv4 suffixes" do
            expect { |b|
              subject.extract(string,:ipv6,&b)
            }.to yield_successive_args(address)
          end
        end
      end

      context "when the IPv6 address is abbreviated" do
        let(:address) { 'fe80::abc:123' }
        let(:string)  { "ipv6: #{address}" }

        it "must extract abbreviated IPv6 addresses" do
          expect(subject.extract(string,:ipv6)).to eq([address])
        end

        context "and when the IPv6 address starts with '::' " do
          let(:address) { '::f0:0d' }
          let(:string)  { "ipv6: #{address}" }

          it "must extract abbreviated IPv6 addresses" do
            expect(subject.extract(string,:ipv6)).to eq([address])
          end

          context "and when a block is given" do
            it "must yield the abbreviated IPv6 addresses" do
              expect { |b|
                subject.extract(string,:ipv6,&b)
              }.to yield_successive_args(address)
            end
          end
        end

        context "and when a block is given" do
          it "must yield the abbreviated IPv6 addresses" do
            expect { |b|
              subject.extract(string,:ipv6,&b)
            }.to yield_successive_args(address)
          end
        end
      end
    end

    context "when the String contains both IPv4 and IPv6 addresses" do
      let(:ipv4_address) { '127.0.0.1' }
      let(:ipv6_address) { 'fe80::0204:61ff:fe9d:f156' }
      let(:string) { "ipv4: #{ipv4_address}, ipv6: #{ipv6_address}" }

      it "must extract both IPv4 and IPv6 addresses" do
        expect(subject.extract(string)).to eq([ipv4_address, ipv6_address])
      end

      context "and when a block is given" do
        it "must yield both IPv4 and IPv6 addresses" do
          expect { |b|
            subject.extract(string,&b)
          }.to yield_successive_args(ipv4_address, ipv6_address)
        end
      end
    end

    context "when the String contains neither IPv4 or IPv6 addresses" do
      let(:string) { 'one: two.three.' }

      it "must ignore non-IP addresses" do
        expect(subject.extract(string)).to be_empty
      end

      context "and when a block is given" do
        it "must not yield anything" do
          expect { |b|
            subject.extract(string,&b)
          }.to_not yield_control
        end
      end
    end
  end

  describe "#get_name"  do
    context "integration", :network do
      let(:address) { reverse_address }

      it "must lookup the address for a hostname" do
        expect(subject.get_name).to eq(reverse_hostname)
      end

      context "when the IP address has no host names associated with it" do
        let(:address) { bad_address }

        it "must return nil" do
          expect(subject.get_name).to be(nil)
        end
      end

      context "when given the nameservers: keyword argument" do
        let(:nameserver) { '8.8.8.8' }

        it "may lookup host-name via other nameservers" do
          expect(subject.get_name(nameservers: [nameserver])).to eq(reverse_hostname)
        end
      end

      context "when given the nameserver: keyword argument" do
        let(:nameserver) { '8.8.8.8' }

        it "may lookup host-name via other nameserver" do
          expect(subject.get_name(nameserver: nameserver)).to eq(reverse_hostname)
        end
      end
    end
  end

  describe "#get_names"  do
    context "integration", :network do
      let(:address) { reverse_address }

      it "must lookup all addresses for a hostname" do
        expect(subject.get_names).to include(reverse_hostname)
      end

      context "when the IP address has no host names associated with it" do
        let(:address) { bad_address }

        it "must return an empty Array" do
          expect(subject.get_names).to eq([])
        end
      end

      context "when given the nameservers: keyword argument" do
        let(:nameserver) { '8.8.8.8' }

        it "may lookup host-names via other nameservers" do
          expect(subject.get_names(nameservers: [nameserver])).to eq([reverse_hostname])
        end
      end

      context "when given the nameserver: keyword argument" do
        let(:nameserver) { '8.8.8.8' }

        it "may lookup host-names via other nameserver" do
          expect(subject.get_names(nameserver: nameserver)).to eq([reverse_hostname])
        end
      end
    end
  end

  describe "#get_host"  do
    context "integration", :network do
      let(:address) { reverse_address }

      it "must lookup the address for a hostname" do
        host = subject.get_host

        expect(host).to be_kind_of(Ronin::Support::Network::Host)
        expect(host.name).to eq(reverse_hostname)
      end

      context "when the IP address has no host names associated with it" do
        let(:address) { bad_address }

        it "must return nil" do
          expect(subject.get_host).to be(nil)
        end
      end

      context "when given the nameservers: keyword argument" do
        let(:nameserver) { '8.8.8.8' }

        it "may lookup host-name via other nameservers" do
          host = subject.get_host(nameservers: [nameserver])

          expect(host).to be_kind_of(Ronin::Support::Network::Host)
          expect(host.name).to eq(reverse_hostname)
        end
      end

      context "when given the nameserver: keyword argument" do
        let(:nameserver) { '8.8.8.8' }

        it "may lookup host-name via other nameserver" do
          host = subject.get_host(nameserver: nameserver)

          expect(host).to be_kind_of(Ronin::Support::Network::Host)
          expect(host.name).to eq(reverse_hostname)
        end
      end
    end
  end

  describe "#get_hosts"  do
    context "integration", :network do
      let(:address) { reverse_address }

      it "must lookup all addresses for a hostname" do
        hosts = subject.get_hosts

        expect(hosts).to_not be_empty
        expect(hosts).to all(be_kind_of(Ronin::Support::Network::Host))
        expect(hosts.map(&:name)).to include(reverse_hostname)
      end

      context "when the IP address has no host names associated with it" do
        let(:address) { bad_address }

        it "must return an empty Array" do
          expect(subject.get_hosts).to eq([])
        end
      end

      context "when given the nameservers: keyword argument" do
        let(:nameserver) { '8.8.8.8' }

        it "may lookup host-names via other nameservers" do
          hosts = subject.get_hosts(nameservers: [nameserver])

          expect(hosts).to_not be_empty
          expect(hosts).to all(be_kind_of(Ronin::Support::Network::Host))
          expect(hosts.map(&:name)).to eq([reverse_hostname])
        end
      end

      context "when given the nameserver: keyword argument" do
        let(:nameserver) { '8.8.8.8' }

        it "may lookup host-names via other nameserver" do
          hosts = subject.get_hosts(nameserver: nameserver)

          expect(hosts).to_not be_empty
          expect(hosts).to all(be_kind_of(Ronin::Support::Network::Host))
          expect(hosts.map(&:name)).to eq([reverse_hostname])
        end
      end
    end
  end

  describe "#hosts" do
    context "integration", :network do
      let(:address) { reverse_address }

      it "must return all host names associated with the IP address" do
        hosts = subject.hosts

        expect(hosts).to_not be_empty
        expect(hosts).to all(be_kind_of(Ronin::Support::Network::Host))
        expect(hosts.map(&:name)).to include(reverse_hostname)
      end

      it "must memoize the value" do
        expect(subject.hosts).to be(subject.hosts)
      end

      context "when the IP address has no host names associated with it" do
        let(:address) { bad_address }

        it "must return an empty Array" do
          expect(subject.hosts).to eq([])
        end
      end
    end
  end

  describe "#host" do
    context "integration", :network do
      let(:address) { reverse_address }

      it "must return the primary host name for the IP address" do
        host = subject.host

        expect(host).to be_kind_of(Ronin::Support::Network::Host)
        expect(host.name).to eq(reverse_hostname)
      end

      it "must memoize the value" do
        expect(subject.host).to be(subject.host)
      end

      context "when the IP address has no host names associated with it" do
        let(:address) { bad_address }

        it "must return nil" do
          expect(subject.host).to be(nil)
        end
      end
    end
  end

  describe "#get_ptr_record" do
    context "integration", :network do
      let(:address)  { '142.251.33.110' }
      let(:ptr_name) { 'sea30s10-in-f14.1e100.net' }

      it "must return the first Resolv::DNS::Resource::IN::PTR record for the IP" do
        pending "need to figure out why Resolv::DNS cannot query PTR records"

        ptr_record = subject.get_ptr_record

        expect(ptr_record).to be_kind_of(Resolv::DNS::Resource::IN::PTR)
        expect(ptr_record.address.to_s).to eq(ptr_name)
      end

      context "when the host name does not have any PTR records" do
        let(:address) { '127.0.0.1' }

        it "must return nil" do
          expect(subject.get_ptr_record).to be(nil)
        end
      end
    end
  end

  describe "#get_ptr_name" do
    context "integration", :network do
      let(:address)  { '142.251.33.110' }
      let(:ptr_name) { 'sea30s10-in-f14.1e100.net' }

      it "must return the first PTR name for the IP" do
        pending "need to figure out why Resolv::DNS cannot query PTR records"

        expect(subject.get_ptr_name).to eq(ptr_name)
      end

      context "when the host name does not have any PTR records" do
        let(:address) { '127.0.0.1' }

        it "must return nil" do
          expect(subject.get_ptr_name).to be(nil)
        end
      end
    end
  end

  describe "#get_ptr_records" do
    context "integration", :network do
      let(:address)  { '142.251.33.110' }
      let(:ptr_name) { 'sea30s10-in-f14.1e100.net' }

      it "must return all Resolv::DNS::Resource::IN::PTR records for the IP" do
        pending "need to figure out why Resolv::DNS cannot query PTR records"

        ptr_records = subject.get_ptr_records

        expect(ptr_records).to_not be_empty
        expect(ptr_records).to all(be_kind_of(Resolv::DNS::Resource::IN::PTR))
        expect(ptr_records.first.address.to_s).to eq(ptr_name)
      end

      context "when the host name does not have any PTR records" do
        let(:address) { '127.0.0.1' }

        it "must return an empty Array" do
          expect(subject.get_ptr_records).to eq([])
        end
      end
    end
  end

  describe "#get_ptr_names" do
    context "integration", :network do
      let(:address)  { '142.251.33.110' }
      let(:ptr_name) { 'sea30s10-in-f14.1e100.net' }

      it "must return all PTR names for the IP" do
        pending "need to figure out why Resolv::DNS cannot query PTR records"

        expect(subject.get_ptr_names).to eq([ptr_name])
      end

      context "when the host name does not have any PTR records" do
        let(:ip) { '127.0.0.1' }

        it "must return an empty Array" do
          expect(subject.get_ptr_names).to eq([])
        end
      end
    end
  end

  describe "#to_s" do
    it "must return the address String" do
      expect(subject.to_s).to eq(address)
    end
  end

  describe "#to_str" do
    it "must return the address String" do
      expect(subject.to_str).to eq(address)
    end
  end
end