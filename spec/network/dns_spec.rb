require 'spec_helper'
require 'ronin/support/network/dns'

describe Ronin::Support::Network::DNS do
  describe ".nameservers" do
    it "must default to the system's resolv.conf nameserver(s)" do
      expect(subject.nameservers).to eq(
        described_class::Resolver.default_nameservers
      )
    end
  end

  describe ".nameservers=" do
    let(:original_nameservers) { subject.nameservers }

    let(:new_nameservers) { %w[42.42.42.42] }

    it "must override the system's default nameservers" do
      subject.nameservers = new_nameservers

      expect(subject.nameservers).to eq(new_nameservers)
    end

    after { subject.nameservers = original_nameservers }
  end

  describe ".nameserver=" do
    let(:original_nameservers) { subject.nameservers }

    let(:new_nameserver) { '42.42.42.42' }

    it "must override the system's default nameservers to the new nameserver" do
      subject.nameserver = new_nameserver

      expect(subject.nameservers).to eq([new_nameserver])
    end

    after { subject.nameservers = original_nameservers }
  end

  describe ".resolver" do
    it "should return #{described_class::Resolver}" do
      expect(subject.resolver).to be_kind_of(described_class::Resolver)
    end

    context "when no arguments are given" do
      it "should default to using DNS.nameserver" do
        resolver = subject.resolver

        expect(resolver.nameservers).to eq(subject.nameservers)
      end
    end

    context "when given the nameservers: keyword argument" do
      let(:nameservers) { %w[42.42.42.42] }

      it "must return a #{described_class::Resolver} object with the given nameservers" do
        resolver = subject.resolver(nameservers: nameservers)

        expect(resolver).to be_kind_of(described_class::Resolver)
        expect(resolver.nameservers).to eq(nameservers)
      end
    end

    context "when given the nameservers: keyword argument" do
      let(:nameserver) { '42.42.42.42' }

      it "must return a #{described_class::Resolver} object with the given nameserver" do
        resolver = subject.resolver(nameserver: nameserver)

        expect(resolver).to be_kind_of(described_class::Resolver)
        expect(resolver.nameservers).to eq([nameserver])
      end
    end
  end

  let(:nameservers)      { %w[8.8.8.8] }
  let(:hostname)         { 'example.com' }
  let(:bad_hostname)     { 'foo.bar' }
  let(:address)          { '93.184.216.34' }
  let(:bad_address)      { '0.0.0.0' }
  let(:reverse_address)  { '142.251.33.110' }
  let(:reverse_hostname) { 'sea30s10-in-f14.1e100.net' }

  describe ".get_address" do
    context "integration", :network do
      it "must lookup the address for a hostname" do
        expect(subject.get_address(hostname)).to eq(address)
      end

      context "when the host nmae has no IP addresses" do
        it "must return nil for unknown hostnames" do
          expect(subject.get_address(bad_hostname)).to be(nil)
        end
      end
    end
  end

  describe ".lookup" do
    context "integration", :network do
      it "must lookup the address for a hostname" do
        expect(subject.lookup(hostname)).to eq(address)
      end

      context "when the host nmae has no IP addresses" do
        it "must return nil for unknown hostnames" do
          expect(subject.lookup(bad_hostname)).to be(nil)
        end
      end
    end
  end

  describe ".get_addresses"  do
    context "integration", :network do
      it "must lookup all addresses for a hostname" do
        expect(subject.get_addresses(hostname)).to include(address)
      end

      context "when the host nmae has no IP addresses" do
        it "must return an empty Array" do
          expect(subject.get_addresses(bad_hostname)).to eq([])
        end
      end
    end
  end

  describe ".get_name"  do
    context "integration", :network do
      it "should lookup the address for a hostname" do
        expect(subject.get_name(reverse_address)).to eq(reverse_hostname)
      end

      context "when the IP address has no host names associated with it" do
        it "must return nil" do
          expect(subject.get_name(bad_address)).to be(nil)
        end
      end
    end
  end

  describe ".reverse_lookup"  do
    context "integration", :network do
      it "should lookup the address for a hostname" do
        expect(subject.reverse_lookup(reverse_address)).to eq(reverse_hostname)
      end

      context "when the IP address has no host names associated with it" do
        it "must return nil" do
          expect(subject.reverse_lookup(bad_address)).to be(nil)
        end
      end
    end
  end

  describe ".get_names"  do
    context "integration", :network do
      it "should lookup all addresses for a hostname" do
        expect(subject.get_names(reverse_address)).to include(reverse_hostname)
      end

      context "when the IP address has no host names associated with it" do
        it "should return an empty Array" do
          expect(subject.get_names(bad_address)).to eq([])
        end
      end
    end
  end

  describe ".get_record" do
    context "integration", :network do
      let(:record_type) { Resolv::DNS::Resource::IN::TXT }

      it "must return the first DNS record for the host name and record type" do
        record = subject.get_record(hostname,record_type)

        expect(record).to be_kind_of(record_type)
        expect(record.strings).to eq(["v=spf1 -all"]).or(eq(
          ["yxvy9m4blrswgrsz8ndjh467n2y7mgl2"]
        ))
      end

      context "when the host name does not exist" do
        it "must return nil" do
          expect(subject.get_record(bad_hostname,record_type)).to be(nil)
        end
      end

      context "when the host name has no matching records" do
        let(:record_type) { Resolv::DNS::Resource::IN::CNAME }

        it "must return nil" do
          expect(subject.get_record(hostname,record_type)).to be(nil)
        end
      end
    end
  end

  describe ".get_records" do
    context "integration", :network do
      let(:record_type) { Resolv::DNS::Resource::IN::TXT }

      it "must return all DNS record of the given type for the host name" do
        records = subject.get_records(hostname,record_type)

        expect(records).to_not be_empty
        expect(records).to all(be_kind_of(record_type))
        expect(records.first.strings).to eq(["v=spf1 -all"]).or(eq(
          ["yxvy9m4blrswgrsz8ndjh467n2y7mgl2"]
        ))
      end

      context "when the host name does not exist" do
        it "must return an empty Array" do
          expect(subject.get_records(bad_hostname,record_type)).to eq([])
        end
      end

      context "when the host name has no matching records" do
        let(:record_type) { Resolv::DNS::Resource::IN::CNAME }

        it "must return an empty Array" do
          expect(subject.get_records(hostname,record_type)).to eq([])
        end
      end
    end
  end

  describe ".get_cname_record" do
    context "integration", :network do
      let(:domain)   { 'twitter.com'   }
      let(:hostname) { "www.#{domain}" }

      it "must return the Resolv::DNS::Resource::IN::CNAME record" do
        cname_record = subject.get_cname_record(hostname)

        expect(cname_record).to be_kind_of(Resolv::DNS::Resource::IN::CNAME)
        expect(cname_record.name.to_s).to eq(domain)
      end

      context "when the host name does not have a CNAME record" do
        let(:hostname) { domain }

        it "must return nil" do
          expect(subject.get_cname_record(hostname)).to be(nil)
        end
      end
    end
  end

  describe ".get_cname" do
    context "integration", :network do
      let(:domain)   { 'twitter.com'   }
      let(:hostname) { "www.#{domain}" }

      it "must return the CNAME string" do
        expect(subject.get_cname(hostname)).to eq(domain)
      end

      context "when the host name does not have a CNAME record" do
        let(:hostname) { domain }

        it "must return nil" do
          expect(subject.get_cname_record(hostname)).to be(nil)
        end
      end
    end
  end

  describe ".get_hinfo_record" do
    context "integration", :network do
      let(:hostname) { "hinfo-example.lookup.dog" }

      it "must return the Resolv::DNS::Resource::IN::HINFO record" do
        hinfo_record = subject.get_hinfo_record(hostname)

        expect(hinfo_record).to be_kind_of(Resolv::DNS::Resource::IN::HINFO)
        expect(hinfo_record.cpu).to eq("some-kinda-cpu")
        expect(hinfo_record.os).to  eq("some-kinda-os")
      end

      context "when the host name does not have a HINFO record" do
        let(:hostname) { 'example.com' }

        it "must return nil" do
          expect(subject.get_hinfo_record(hostname)).to be(nil)
        end
      end
    end
  end

  describe ".get_a_record" do
    context "integration", :network do
      let(:hostname)     { 'example.com'   }
      let(:ipv4_address) { '93.184.216.34' }

      it "must return the first Resolv::DNS::Resource::IN::A record" do
        a_record = subject.get_a_record(hostname)

        expect(a_record).to be_kind_of(Resolv::DNS::Resource::IN::A)
        expect(a_record.address.to_s).to eq(ipv4_address)
      end

      context "when the host name does not have any A records" do
        let(:hostname) { '_spf.google.com' }

        it "must return nil" do
          expect(subject.get_a_record(hostname)).to be(nil)
        end
      end
    end
  end

  describe ".get_a_address" do
    context "integration", :network do
      let(:hostname)     { 'example.com'   }
      let(:ipv4_address) { '93.184.216.34' }

      it "must return the first IPv4 address" do
        expect(subject.get_a_address(hostname)).to eq(ipv4_address)
      end

      context "when the host name does not have any A records" do
        let(:hostname) { '_spf.google.com' }

        it "must return nil" do
          expect(subject.get_a_address(hostname)).to be(nil)
        end
      end
    end
  end

  describe ".get_a_records" do
    context "integration", :network do
      let(:hostname)     { 'example.com'   }
      let(:ipv4_address) { '93.184.216.34' }

      it "must return all Resolv::DNS::Resource::IN::A records" do
        a_records = subject.get_a_records(hostname)

        expect(a_records).to_not be_empty
        expect(a_records).to all(be_kind_of(Resolv::DNS::Resource::IN::A))
      end

      context "when the host name does not have any A records" do
        let(:hostname) { '_spf.google.com' }

        it "must return an empty Array" do
          expect(subject.get_a_records(hostname)).to eq([])
        end
      end
    end
  end

  describe ".get_a_addresses" do
    context "integration", :network do
      let(:hostname)     { 'example.com'   }
      let(:ipv4_address) { '93.184.216.34' }

      it "must return all IPv4 addresses" do
        expect(subject.get_a_addresses(hostname)).to eq([ipv4_address])
      end

      context "when the host name does not have any A records" do
        let(:hostname) { '_spf.google.com' }

        it "must return an empty Array" do
          expect(subject.get_a_addresses(hostname)).to eq([])
        end
      end
    end
  end

  describe ".get_aaaa_record" do
    context "integration", :network do
      let(:hostname)     { 'example.com'   }
      let(:ipv6_address) { '2606:2800:220:1:248:1893:25c8:1946' }

      it "must return the first Resolv::DNS::Resource::IN::AAAA record" do
        aaaa_record = subject.get_aaaa_record(hostname)

        expect(aaaa_record).to be_kind_of(Resolv::DNS::Resource::IN::AAAA)
        expect(aaaa_record.address.to_s).to eq(ipv6_address)
      end

      context "when the host name does not have any AAAA records" do
        let(:hostname) { '_spf.google.com' }

        it "must return nil" do
          expect(subject.get_aaaa_record(hostname)).to be(nil)
        end
      end
    end
  end

  describe ".get_aaaa_address" do
    context "integration", :network do
      let(:hostname)     { 'example.com'   }
      let(:ipv6_address) { '2606:2800:220:1:248:1893:25c8:1946' }

      it "must return the first IPv6 address" do
        expect(subject.get_aaaa_address(hostname)).to eq(ipv6_address)
      end

      context "when the host name does not have any AAAA records" do
        let(:hostname) { '_spf.google.com' }

        it "must return nil" do
          expect(subject.get_aaaa_address(hostname)).to be(nil)
        end
      end
    end
  end

  describe ".get_aaaa_records" do
    context "integration", :network do
      let(:hostname)     { 'example.com'   }
      let(:ipv6_address) { '2606:2800:220:1:248:1893:25c8:1946' }

      it "must return all Resolv::DNS::Resource::IN::AAAA records" do
        aaaa_records = subject.get_aaaa_records(hostname)

        expect(aaaa_records).to_not be_empty
        expect(aaaa_records).to all(be_kind_of(Resolv::DNS::Resource::IN::AAAA))
      end

      context "when the host name does not have any AAAA records" do
        let(:hostname) { '_spf.google.com' }

        it "must return an empty Array" do
          expect(subject.get_aaaa_records(hostname)).to eq([])
        end
      end
    end
  end

  describe ".get_aaaa_addresses" do
    context "integration", :network do
      let(:hostname)     { 'example.com'   }
      let(:ipv6_address) { '2606:2800:220:1:248:1893:25c8:1946' }

      it "must return the IPv6 addresses" do
        expect(subject.get_aaaa_addresses(hostname)).to eq([ipv6_address])
      end

      context "when the host name does not have any AAAA records" do
        let(:hostname) { '_spf.google.com' }

        it "must return an empty Array" do
          expect(subject.get_aaaa_addresses(hostname)).to eq([])
        end
      end
    end
  end

  describe ".get_srv_records" do
    context "integration", :network do
      let(:hostname) { '_xmpp-server._tcp.gmail.com' }

      it "must return all Resolv::DNS::Resource::IN::SRV records" do
        srv_records = subject.get_srv_records(hostname)

        expect(srv_records).to_not be_empty
        expect(srv_records).to all(be_kind_of(Resolv::DNS::Resource::IN::SRV))
      end

      context "when the host name does not have any SRV records" do
        let(:hostname) { 'example.com' }

        it "must return an empty Array" do
          expect(subject.get_srv_records(hostname)).to eq([])
        end
      end
    end
  end

  describe ".get_wks_records" do
    context "integration", :network do
      it "must return all Resolv::DNS::Resource::IN::WKS records" do
        pending "cannot find a host that still has a WKS record"

        wks_records = subject.get_wks_records(hostname)

        expect(wks_records).to_not be_empty
        expect(wks_records).to all(be_kind_of(Resolv::DNS::Resource::IN::WKS))
      end

      context "when the host name does not have any WKS records" do
        let(:hostname) { 'example.com' }

        it "must return an empty Array" do
          expect(subject.get_wks_records(hostname)).to eq([])
        end
      end
    end
  end

  describe ".get_loc_record" do
    context "integration", :network do
      it "must return the Resolv::DNS::Resource::IN::LOC record" do
        pending "cannot find a host that still has a LOC record"

        expect(subject.get_loc_record(hostname)).to be_kind_of(Resolv::DNS::Resource::IN::LOC)
      end

      context "when the host name does not have any LOC records" do
        let(:hostname) { 'example.com' }

        it "must return nil" do
          expect(subject.get_loc_record(hostname)).to be(nil)
        end
      end
    end
  end

  describe ".get_minfo_record" do
    context "integration", :network do
      it "must return the Resolv::DNS::Resource::IN::MINFO record" do
        pending "cannot find a host that still has a MINFO record"

        expect(subject.get_minfo_record(hostname)).to be_kind_of(Resolv::DNS::Resource::IN::MINFO)
      end

      context "when the host name does not have any MINFO records" do
        let(:hostname) { 'example.com' }

        it "must return nil" do
          expect(subject.get_minfo_record(hostname)).to be(nil)
        end
      end
    end
  end

  describe ".get_mx_records" do
    context "integration", :network do
      let(:hostname) { 'gmail.com' }

      it "must return all Resolv::DNS::Resource::IN::MX records" do
        mx_records = subject.get_mx_records(hostname)

        expect(mx_records).to_not be_empty
        expect(mx_records).to all(be_kind_of(Resolv::DNS::Resource::IN::MX))
      end

      context "when the host name does not have any MX records" do
        let(:hostname) { 'www.example.com' }

        it "must return an empty Array" do
          expect(subject.get_mx_records(hostname)).to eq([])
        end
      end
    end
  end

  describe ".get_mailservers" do
    context "integration", :network do
      let(:hostname) { 'gmail.com' }
      let(:mailservers) do
        %w[
          alt1.gmail-smtp-in.l.google.com
          alt2.gmail-smtp-in.l.google.com
          alt3.gmail-smtp-in.l.google.com
          gmail-smtp-in.l.google.com
          alt4.gmail-smtp-in.l.google.com
        ]
      end

      it "must return the Array of mailserver host names" do
        expect(subject.get_mailservers(hostname)).to match_array(mailservers)
      end

      context "when the host name does not have any MX records" do
        let(:hostname) { 'www.example.com' }

        it "must return an empty Array" do
          expect(subject.get_mailservers(hostname)).to eq([])
        end
      end
    end
  end

  describe ".get_ns_records" do
    context "integration", :network do
      let(:hostname) { 'example.com' }

      it "must return all Resolv::DNS::Resource::IN::NS records" do
        ns_records = subject.get_ns_records(hostname)

        expect(ns_records).to_not be_empty
        expect(ns_records).to all(be_kind_of(Resolv::DNS::Resource::IN::NS))
      end

      context "when the host name does not have any NS records" do
        let(:hostname) { 'www.example.com' }

        it "must return an empty Array" do
          expect(subject.get_ns_records(hostname)).to eq([])
        end
      end
    end
  end

  describe ".get_nameservers" do
    context "integration", :network do
      let(:hostname) { 'example.com' }
      let(:nameserver_names) do
        %w[
          b.iana-servers.net
          a.iana-servers.net
        ]
      end

      it "must return the Array of nameserver host names" do
        expect(p(subject.get_nameservers(hostname))).to match_array(nameserver_names)
      end

      context "when the host name does not have any NS records" do
        let(:hostname) { 'www.example.com' }

        it "must return an empty Array" do
          expect(subject.get_nameservers(hostname)).to eq([])
        end
      end
    end
  end

  describe ".get_ptr_record" do
    context "integration", :network do
      let(:ip)       { '142.251.33.110' }
      let(:ptr_name) { 'sea30s10-in-f14.1e100.net' }

      it "must return the first Resolv::DNS::Resource::IN::PTR record for the IP" do
        pending "need to figure out why Resolv::DNS cannot query PTR records"

        ptr_record = subject.get_ptr_record(ip)

        expect(ptr_record).to be_kind_of(Resolv::DNS::Resource::IN::PTR)
        expect(ptr_record.address.to_s).to eq(ptr_name)
      end

      context "when the host name does not have any PTR records" do
        let(:ip) { '127.0.0.1' }

        it "must return nil" do
          expect(subject.get_ptr_record(ip)).to be(nil)
        end
      end
    end
  end

  describe ".get_ptr_name" do
    context "integration", :network do
      let(:ip)       { '142.251.33.110' }
      let(:ptr_name) { 'sea30s10-in-f14.1e100.net' }

      it "must return the first PTR name for the IP" do
        pending "need to figure out why Resolv::DNS cannot query PTR records"

        expect(subject.get_ptr_name(ip)).to eq(ptr_name)
      end

      context "when the host name does not have any PTR records" do
        let(:ip) { '127.0.0.1' }

        it "must return nil" do
          expect(subject.get_ptr_name(ip)).to be(nil)
        end
      end
    end
  end

  describe ".get_ptr_records" do
    context "integration", :network do
      let(:ip)       { '142.251.33.110' }
      let(:ptr_name) { 'sea30s10-in-f14.1e100.net' }

      it "must return all Resolv::DNS::Resource::IN::PTR records for the IP" do
        pending "need to figure out why Resolv::DNS cannot query PTR records"

        ptr_records = subject.get_ptr_records(ip)

        expect(ptr_records).to_not be_empty
        expect(ptr_records).to all(be_kind_of(Resolv::DNS::Resource::IN::PTR))
        expect(ptr_records.first.address.to_s).to eq(ptr_name)
      end

      context "when the host name does not have any PTR records" do
        let(:ip) { '127.0.0.1' }

        it "must return an empty Array" do
          expect(subject.get_ptr_records(ip)).to eq([])
        end
      end
    end
  end

  describe ".get_ptr_names" do
    context "integration", :network do
      let(:ip)       { '142.251.33.110' }
      let(:ptr_name) { 'sea30s10-in-f14.1e100.net' }

      it "must return all PTR names for the IP" do
        pending "need to figure out why Resolv::DNS cannot query PTR records"

        expect(subject.get_ptr_names(ip)).to eq([ptr_name])
      end

      context "when the host name does not have any PTR records" do
        let(:ip) { '127.0.0.1' }

        it "must return an empty Array" do
          expect(subject.get_ptr_names(ip)).to eq([])
        end
      end
    end
  end

  describe ".get_soa_record" do
    context "integration", :network do
      let(:hostname) { 'example.com' }

      it "must return the Resolv::DNS::Resource::IN::SOA record" do
        soa_record = subject.get_soa_record(hostname)

        expect(soa_record).to be_kind_of(Resolv::DNS::Resource::IN::SOA)
      end

      context "when the host name does not have any SOA records" do
        let(:hostname) { 'www.example.com' }

        it "must return nil" do
          expect(subject.get_soa_record(hostname)).to be(nil)
        end
      end
    end
  end

  describe ".get_txt_record" do
    context "integration", :network do
      let(:hostname) { 'example.com' }

      it "must return the first Resolv::DNS::Resource::IN::TXT record" do
        txt_record = subject.get_txt_record(hostname)

        expect(txt_record).to be_kind_of(Resolv::DNS::Resource::IN::TXT)
        expect(txt_record.strings).to eq(['v=spf1 -all']).or(eq(
          ["yxvy9m4blrswgrsz8ndjh467n2y7mgl2"]
        ))
      end

      context "when the host name does not have any TXT records" do
        let(:hostname) { 'a.iana-servers.net' }

        it "must return nil" do
          expect(subject.get_txt_record(hostname)).to be(nil)
        end
      end
    end
  end

  describe ".get_txt_string" do
    context "integration", :network do
      let(:hostname) { 'example.com' }

      it "must return the first TXT string" do
        expect(subject.get_txt_string(hostname)).to eq('v=spf1 -all').or(eq(
          "yxvy9m4blrswgrsz8ndjh467n2y7mgl2"
        ))
      end

      context "when the host name does not have any TXT records" do
        let(:hostname) { 'a.iana-servers.net' }

        it "must return nil" do
          expect(subject.get_txt_string(hostname)).to be(nil)
        end
      end
    end
  end

  describe ".get_txt_records" do
    context "integration", :network do
      let(:hostname) { 'example.com' }

      it "must return all Resolv::DNS::Resource::IN::TXT records" do
        txt_records = subject.get_txt_records(hostname)

        expect(txt_records).to all(be_kind_of(Resolv::DNS::Resource::IN::TXT))
        expect(txt_records.first.strings).to eq(['v=spf1 -all']).or(eq(
          ["yxvy9m4blrswgrsz8ndjh467n2y7mgl2"]
        ))
      end

      context "when the host name does not have any TXT records" do
        let(:hostname) { 'a.iana-servers.net' }

        it "must return an empty Array" do
          expect(subject.get_txt_records(hostname)).to eq([])
        end
      end
    end
  end

  describe ".get_txt_strings" do
    context "integration", :network do
      let(:hostname) { 'example.com' }

      it "must return all TXT string" do
        expect(subject.get_txt_strings(hostname)).to match_array(
          [
            'v=spf1 -all',
            'yxvy9m4blrswgrsz8ndjh467n2y7mgl2'
          ]
        )
      end

      context "when the host name does not have any TXT records" do
        let(:hostname) { 'a.iana-servers.net' }

        it "must return an empty Array" do
          expect(subject.get_txt_strings(hostname)).to eq([])
        end
      end
    end
  end
end
