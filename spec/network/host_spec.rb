require 'spec_helper'
require 'ronin/support/network/host'

describe Ronin::Support::Network::Host do
  let(:nameservers)      { %w[8.8.8.8] }
  let(:hostname)         { 'example.com' }
  let(:bad_hostname)     { 'foo.bar' }
  let(:address)          { '93.184.216.34' }
  let(:bad_address)      { '0.0.0.0' }
  let(:reverse_address)  { '142.251.33.110' }
  let(:reverse_hostname) { 'sea30s10-in-f14.1e100.net' }

  let(:example_spf_record) { "v=spf1 -all" }
  let(:example_txt_record) { "wgyf8z8cgvm2qmxpnbnldrcltvk4xqfn" }

  let(:google_spf_record) { "v=spf1 include:_netblocks.google.com include:_netblocks2.google.com include:_netblocks3.google.com ~all" }
  let(:google_txt_record) { "wgyf8z8cgvm2qmxpnbnldrcltvk4xqfn" }

  subject { described_class.new(hostname) }

  describe "#initialize" do
    it "must set #name" do
      expect(subject.name).to eq(hostname)
    end
  end

  describe "#defang" do
    let(:hostname) { 'www.example.com' }
    let(:defanged) { 'www[.]example[.]com' }

    it "must return the defanged host name" do
      expect(subject.defang).to eq(defanged)
    end
  end

  let(:unicode_hostname)  { "www.詹姆斯.com" }
  let(:punycode_hostname) { 'www.xn--8ws00zhy3a.com' }

  describe "#idn?" do
    context "when the hostname contains unicode characters" do
      let(:hostname)  { unicode_hostname }

      it "must return true" do
        expect(subject.idn?).to be(true)
      end
    end

    context "when the hostname only contains ASCII characters" do
      it "must return false" do
        expect(subject.idn?).to be(false)
      end
    end
  end

  describe "#punycode?" do
    context "when the hostname is not a punycode hostname" do
      it "must return false" do
        expect(subject.punycode?).to be(false)
      end
    end

    context "when the hostname is a punycode hostname" do
      let(:hostname) { punycode_hostname }

      it "must return true" do
        expect(subject.punycode?).to be(true)
      end
    end
  end

  describe "#punycode" do
    context "when the hostname contains unicode characters" do
      let(:hostname) { unicode_hostname }

      it "must return a new #{described_class}" do
        expect(subject.punycode).to be_kind_of(described_class)
        expect(subject.punycode).to_not be(subject)
      end

      it "must convert the unicode hostname to punycode" do
        expect(subject.punycode.name).to eq(punycode_hostname)
      end
    end

    context "when the hostname does not contain unicode" do
      it "must return a new #{described_class}" do
        expect(subject.punycode).to be_kind_of(described_class)
        expect(subject.punycode).to_not be(subject)
      end

      it "must not change the hostname" do
        expect(subject.punycode.name).to eq(subject.name)
      end
    end
  end

  let(:tld_fixtures_dir) do
    File.join(__dir__,'tld','fixtures')
  end
  let(:tld_list_file) do
    File.join(fixtures_dir,'tlds-alpha-by-domain.txt')
  end
  let(:tld_list) do
    Ronin::Support::Network::TLD::List.load_file(list_file)
  end

  before do
    allow(Ronin::Support::Network::TLD).to receive(:list).and_return(tld_list)
  end

  let(:public_suffix_fixtures_dir) do
    File.join(__dir__,'public_suffix','fixtures')
  end
  let(:public_suffix_list_file) do
    File.join(fixtures_dir,'public_suffix_list.dat')
  end
  let(:public_suffix_list) do
    Ronin::Support::Network::PublicSuffix::List.load_file(list_file)
  end

  before do
    allow(Ronin::Support::Network::PublicSuffix).to receive(:list).and_return(public_suffix_list)
  end

  describe "#tld" do
    context "when the hostname only has two components" do
      let(:hostname) { 'example.com' }

      it "must return the TLD of the hostname" do
        expect(subject.tld).to eq('com')
      end
    end

    context "when the hostname has a multi-component suffix" do
      let(:hostname) { 'www.example.co.uk' }

      it "must return the last component of the hostname" do
        expect(subject.tld).to eq('uk')
      end
    end
  end

  describe "#suffix" do
    context "when the hostname is already a domain name" do
      let(:hostname) { 'example.com' }

      it "must return the suffix of the hostname" do
        expect(subject.suffix).to eq('com')
      end
    end

    context "when the hostname has a multi-component suffix" do
      let(:hostname) { 'www.example.co.uk' }

      it "must return the full suffix of the hostname" do
        expect(subject.suffix).to eq('co.uk')
      end
    end
  end

  describe "#domain" do
    it "must return a Ronin::Support::Network::Domain object" do
      expect(subject.domain).to be_kind_of(Ronin::Support::Network::Domain)
    end

    context "when the hostname is already a domain name" do
      let(:hostname) { 'example.com' }

      it "the resulting domain must have the same hostname" do
        expect(subject.domain.name).to eq(subject.name)
      end
    end

    context "when the hostname is a sub-domain name" do
      let(:hostname) { "foo.bar.example.com" }

      it "must strip the sub-domains from the domain name" do
        expect(subject.domain.name).to eq('example.com')
      end
    end

    context "when the hostname has a multi-component suffix" do
      let(:hostname) { 'www.example.co.uk' }

      it "must separate the domain name from the multi-part suffix" do
        expect(subject.domain.name).to eq('example.co.uk')
      end

      context "and the hostname is also a sub-domain name" do
        let(:hostname) { "foo.bar.example.co.uk" }

        it "must strip the sub-domains from the domain name" do
          expect(subject.domain.name).to eq('example.co.uk')
        end
      end
    end

    context "when the hostname does not end in a valid suffix" do
      let(:hostname) { "example.X" }

      it do
        expect {
          subject.domain
        }.to raise_error(Ronin::Support::Network::InvalidHostname,"hostname does not have a valid suffix: #{hostname.inspect}")
      end
    end
  end

  describe "#subdomain" do
    let(:subname) { 'foo' }

    it "must return a new #{described_class}" do
      expect(subject.subdomain(subname)).to be_kind_of(described_class)
    end

    it "must add the sub-name under the hostname" do
      expect(subject.subdomain(subname).name).to eq("#{subname}.#{hostname}")
    end
  end

  let(:fixtures_dir) { File.join(__dir__,'public_suffix','fixtures') }
  let(:list_file)    { File.join(fixtures_dir,'public_suffix_list.dat') }

  let(:public_suffix_list) do
    Ronin::Support::Network::PublicSuffix::List.load_file(list_file)
  end

  describe "#change_suffix" do
    before do
      allow(Ronin::Support::Network::PublicSuffix).to receive(:list).and_return(public_suffix_list)
    end

    let(:hostname)   { 'www.example.com' }
    let(:new_suffix) { '.net' }

    it "must return a Ronin::Support::Network::Host object" do
      expect(subject.change_suffix(new_suffix)).to be_kind_of(Ronin::Support::Network::Host)
    end

    it "must replace the suffix with the new suffix" do
      expect(subject.change_suffix(new_suffix).name).to eq('www.example.net')
    end

    context "when given a new suffix that does not start with a '.'" do
      let(:new_suffix) { 'net' }

      it "must add the missing '.' character" do
        expect(subject.change_suffix(new_suffix).name).to eq('www.example.net')
      end
    end

    context "when the hostname has a multi-component suffix" do
      let(:hostname) { 'www.example.co.uk' }

      it "must replace the multi-part suffix with the new suffix" do
        expect(subject.change_suffix(new_suffix).name).to eq('www.example.net')
      end
    end

    context "when the hostname does not end in a valid suffix" do
      let(:hostname) { "example.X" }

      it do
        expect {
          subject.change_suffix(new_suffix)
        }.to raise_error(Ronin::Support::Network::InvalidHostname,"hostname does not have a valid suffix: #{hostname.inspect}")
      end
    end
  end

  describe "#each_tld" do
    let(:prefix)   { 'www.example'   }
    let(:hostname) { "#{prefix}.com" }

    before do
      allow(Ronin::Support::Network::TLD).to receive(:list).and_return(tld_list)
    end

    context "when given a block" do
      it "must yield new #{described_class} objects with different TLDs" do
        yielded_hosts = []

        subject.each_tld do |host|
          yielded_hosts << host
        end

        expect(yielded_hosts).to_not be_empty
        expect(yielded_hosts).to all(be_kind_of(described_class))
        expect(yielded_hosts.map(&:name)).to eq(
          tld_list.map { |tld| "#{prefix}.#{tld}" }
        )
      end
    end

    context "when no block is given" do
      it "must return an Enumerator for the method" do
        expect(subject.each_tld).to be_kind_of(Enumerator)

        returned_hosts = subject.each_tld.to_a
        expect(returned_hosts).to_not be_empty
        expect(returned_hosts).to all(be_kind_of(described_class))
        expect(returned_hosts.map(&:name)).to eq(
          tld_list.map { |tld| "#{prefix}.#{tld}" }
        )
      end
    end
  end

  describe "#each_suffix" do
    let(:prefix)   { 'www.example'   }
    let(:hostname) { "#{prefix}.com" }

    before do
      allow(Ronin::Support::Network::PublicSuffix).to receive(:list).and_return(public_suffix_list)
    end

    let(:public_suffixes) do
      public_suffix_list.reject(&:wildcard?)
    end

    context "when given a block" do
      it "must yield new #{described_class} objects with different suffixes" do
        yielded_hosts = []

        subject.each_suffix do |host|
          yielded_hosts << host
        end

        expect(yielded_hosts).to_not be_empty
        expect(yielded_hosts).to all(be_kind_of(described_class))
        expect(yielded_hosts.map(&:name)).to eq(
          public_suffixes.map { |suffix| "#{prefix}.#{suffix}" }
        )
      end

      context "when given `type: :icann` keyword argument" do
        let(:public_suffixes) { super().select(&:icann?) }

        it "must only yield new #{described_class} objects with ICANN suffixes" do
          yielded_hosts = []

          subject.each_suffix(type: :icann) do |host|
            yielded_hosts << host
          end

          expect(yielded_hosts).to_not be_empty
          expect(yielded_hosts).to all(be_kind_of(described_class))
          expect(yielded_hosts.map(&:name)).to eq(
            public_suffixes.map { |suffix| "#{prefix}.#{suffix}" }
          )
        end
      end

      context "when given `type: :private` keyword argument" do
        let(:public_suffixes) { super().select(&:private?) }

        it "must only yield new #{described_class} objects with private suffixes" do
          yielded_hosts = []

          subject.each_suffix(type: :private) do |host|
            yielded_hosts << host
          end

          expect(yielded_hosts).to_not be_empty
          expect(yielded_hosts).to all(be_kind_of(described_class))
          expect(yielded_hosts.map(&:name)).to eq(
            public_suffixes.map { |suffix| "#{prefix}.#{suffix}" }
          )
        end
      end
    end

    context "when no block is given" do
      it "must return an Enumerator for the method" do
        expect(subject.each_suffix).to be_kind_of(Enumerator)

        returned_hosts = subject.each_suffix.to_a
        expect(returned_hosts).to_not be_empty
        expect(returned_hosts).to all(be_kind_of(described_class))
        expect(returned_hosts.map(&:name)).to eq(
          public_suffixes.map { |suffix| "#{prefix}.#{suffix}" }
        )
      end

      context "when given `type: :icann` keyword argument" do
        let(:public_suffixes) { super().select(&:icann?) }

        it "must return an Enumerator only for new #{described_class} objects with ICANN suffixes" do
          returned_hosts = subject.each_suffix(type: :icann).to_a

          expect(returned_hosts).to_not be_empty
          expect(returned_hosts).to all(be_kind_of(described_class))
          expect(returned_hosts.map(&:name)).to eq(
            public_suffixes.map { |suffix| "#{prefix}.#{suffix}" }
          )
        end
      end

      context "when given `type: :private` keyword argument" do
        let(:public_suffixes) { super().select(&:private?) }

        it "must return an Enumerator only for new #{described_class} objects with private suffixes" do
          returned_hosts = subject.each_suffix(type: :private).to_a

          expect(returned_hosts).to_not be_empty
          expect(returned_hosts).to all(be_kind_of(described_class))
          expect(returned_hosts.map(&:name)).to eq(
            public_suffixes.map { |suffix| "#{prefix}.#{suffix}" }
          )
        end
      end
    end
  end

  describe "#get_address" do
    context "integration", :network do
      it "must lookup the address for a hostname" do
        expect(subject.get_address).to eq(address)
      end

      context "when the host nmae has no IP addresses" do
        let(:hostname) { bad_hostname }

        it "must return nil for unknown hostnames" do
          expect(subject.get_address).to be(nil)
        end
      end
    end
  end

  describe "#lookup" do
    context "integration", :network do
      it "must lookup the address for a hostname" do
        expect(subject.lookup).to eq(address)
      end

      context "when the host nmae has no IP addresses" do
        let(:hostname) { bad_hostname }

        it "must return nil for unknown hostnames" do
          expect(subject.lookup).to be(nil)
        end
      end
    end
  end

  describe "#get_addresses" do
    context "integration", :network do
      it "must lookup all addresses for a hostname" do
        expect(subject.get_addresses).to include(address)
      end

      context "when the host nmae has no IP addresses" do
        let(:hostname) { bad_hostname }

        it "must return an empty Array" do
          expect(subject.get_addresses).to eq([])
        end
      end
    end
  end

  describe "#addresses" do
    context "integration", :network do
      it "must return all addresses for a hostname" do
        expect(subject.addresses).to include(address)
      end

      it "must memoize the value" do
        expect(subject.addresses).to be(subject.addresses)
      end

      context "when the host nmae has no IP addresses" do
        let(:hostname) { bad_hostname }

        it "must return an empty Array" do
          expect(subject.addresses).to eq([])
        end
      end
    end
  end

  describe "#has_addresses?" do
    context "integration", :network do
      context "when the host name has associated addresses" do
        it "must return true" do
          expect(subject.has_addresses?).to be(true)
        end
      end

      context "when the host nmae has no IP addresses" do
        let(:hostname) { bad_hostname }

        it "must return an empty Array" do
          expect(subject.has_addresses?).to be(false)
        end
      end
    end
  end

  describe "#get_ip" do
    context "integration", :network do
      it "must return an IP for the host" do
        ip = subject.get_ip

        expect(ip).to be_kind_of(Ronin::Support::Network::IP)
        expect(ip.address).to eq(address)
      end

      context "when the host nmae has no IP addresses" do
        let(:hostname) { bad_hostname }

        it "must return nil for unknown hostnames" do
          expect(subject.get_ip).to be(nil)
        end
      end
    end
  end

  describe "#get_ips" do
    context "integration", :network do
      it "must return all IPs for the hostname" do
        ips = subject.get_ips

        expect(ips).to_not be_empty
        expect(ips).to all(be_kind_of(Ronin::Support::Network::IP))
        expect(ips.map(&:address)).to include(address)
      end

      context "when the host nmae has no IP addresses" do
        let(:hostname) { bad_hostname }

        it "must return an empty Array" do
          expect(subject.get_ips).to eq([])
        end
      end
    end
  end

  describe "#ips" do
    context "integration", :network do
      it "must return all IPs for the hostname" do
        ips = subject.ips

        expect(ips).to_not be_empty
        expect(ips).to all(be_kind_of(Ronin::Support::Network::IP))
        expect(ips.map(&:address)).to include(address)
      end

      context "when the host nmae has no IP addresses" do
        let(:hostname) { bad_hostname }

        it "must return an empty Array" do
          expect(subject.ips).to eq([])
        end
      end
    end
  end

  describe "#ip" do
    context "integration", :network do
      it "must return an IP for the host" do
        ip = subject.get_ip

        expect(ip).to be_kind_of(Ronin::Support::Network::IP)
        expect(ip.address).to eq(address)
      end

      context "when the host nmae has no IP addresses" do
        let(:hostname) { bad_hostname }

        it "must return nil for unknown hostnames" do
          expect(subject.ip).to be(nil)
        end
      end
    end
  end

  describe "#get_record" do
    context "integration", :network do
      let(:record_type)  { :txt }
      let(:record_class) { Resolv::DNS::Resource::IN::TXT }

      it "must return the first DNS record for the host name and record type" do
        record = subject.get_record(record_type)

        expect(record).to be_kind_of(record_class)
        expect(record.strings.first).to eq(example_spf_record).or(
          eq(example_txt_record)
        )
      end

      context "when the host name does not exist" do
        let(:hostname) { bad_hostname }

        it "must return nil" do
          expect(subject.get_record(record_type)).to be(nil)
        end
      end

      context "when the host name has no matching records" do
        let(:record_type) { :cname }

        it "must return nil" do
          expect(subject.get_record(record_type)).to be(nil)
        end
      end

      context "when a record name is given" do
        let(:hostname )   { 'twitter.com' }
        let(:name)        { 'dev' }
        let(:record_type)  { :cname }
        let(:record_class) { Resolv::DNS::Resource::IN::CNAME }

        it "must query the record and and type under the host name" do
          record = subject.get_record(name,record_type)

          expect(record).to be_kind_of(record_class)
          expect(record.name.to_s).to eq('s.twitter.com')
        end
      end
    end
  end

  describe "#get_records" do
    context "integration", :network do
      let(:record_type)  { :txt }
      let(:record_class) { Resolv::DNS::Resource::IN::TXT }

      it "must return all DNS record of the given type for the host name" do
        records = subject.get_records(record_type)

        expect(records).to_not be_empty
        expect(records).to all(be_kind_of(record_class))
        expect(records.map(&:strings).flatten).to match_array(
          [example_spf_record, example_txt_record]
        )
      end

      context "when the host name does not exist" do
        let(:hostname) { bad_hostname }

        it "must return an empty Array" do
          expect(subject.get_records(record_type)).to eq([])
        end
      end

      context "when the host name has no matching records" do
        let(:record_type) { :cname }

        it "must return an empty Array" do
          expect(subject.get_records(record_type)).to eq([])
        end
      end

      context "when a record name is given" do
        let(:hostname )    { 'twitter.com' }
        let(:name)         { 'dev' }
        let(:record_type)  { :cname }
        let(:record_class) { Resolv::DNS::Resource::IN::CNAME }

        it "must query the records and and type under the host name" do
          records = subject.get_records(name,record_type)

          expect(records).to_not be_empty
          expect(records).to all(be_kind_of(record_class))
          expect(records.first.name.to_s).to eq('s.twitter.com')
        end
      end
    end
  end

  describe "#get_cname_record" do
    context "integration", :network do
      let(:domain)   { 'twitter.com'   }
      let(:hostname) { "www.#{domain}" }

      it "must return the Resolv::DNS::Resource::IN::CNAME record" do
        cname_record = subject.get_cname_record

        expect(cname_record).to be_kind_of(Resolv::DNS::Resource::IN::CNAME)
        expect(cname_record.name.to_s).to eq(domain)
      end

      context "when the host name does not have a CNAME record" do
        let(:hostname) { domain }

        it "must return nil" do
          expect(subject.get_cname_record).to be(nil)
        end
      end

      context "when a record name is given" do
        let(:hostname )   { 'twitter.com' }
        let(:name)        { 'dev' }
        let(:cname)       { 's.twitter.com' }

        it "must query the CNAME record for the name under the host name" do
          cname_record = subject.get_cname_record(name)

          expect(cname_record).to be_kind_of(Resolv::DNS::Resource::IN::CNAME)
          expect(cname_record.name.to_s).to eq(cname)
        end
      end
    end
  end

  describe "#get_cname" do
    context "integration", :network do
      let(:domain)   { 'twitter.com'   }
      let(:hostname) { "www.#{domain}" }

      it "must return the CNAME string" do
        expect(subject.get_cname).to eq(domain)
      end

      context "when the host name does not have a CNAME record" do
        let(:hostname) { domain }

        it "must return nil" do
          expect(subject.get_cname).to be(nil)
        end
      end

      context "when a record name is given" do
        let(:hostname )   { 'twitter.com' }
        let(:name)        { 'dev' }
        let(:cname)       { 's.twitter.com' }

        it "must query the CNAME record for the name under the host name" do
          expect(subject.get_cname(name)).to eq(cname)
        end
      end
    end
  end

  describe "#cname" do
    context "integration", :network do
      let(:domain)   { 'twitter.com'   }
      let(:hostname) { "www.#{domain}" }

      it "must return the CNAME string" do
        expect(subject.cname).to eq(domain)
      end

      it "must memoize the value" do
        expect(subject.cname).to be(subject.cname)
      end

      context "when the host name does not have a CNAME record" do
        let(:hostname) { domain }

        it "must return nil" do
          expect(subject.cname).to be(nil)
        end
      end
    end
  end

  describe "#get_hinfo_record" do
    context "integration", :network do
      let(:hostname) { "hinfo-example.lookup.dog" }

      it "must return the Resolv::DNS::Resource::IN::HINFO record" do
        hinfo_record = subject.get_hinfo_record

        expect(hinfo_record).to be_kind_of(Resolv::DNS::Resource::IN::HINFO)
        expect(hinfo_record.cpu).to eq("some-kinda-cpu")
        expect(hinfo_record.os).to  eq("some-kinda-os")
      end

      context "when the host name does not have a HINFO record" do
        let(:hostname) { 'example.com' }

        it "must return nil" do
          expect(subject.get_hinfo_record).to be(nil)
        end
      end

      context "when a record name is given" do
        let(:hostname )   { 'lookup.dog' }
        let(:name)        { 'hinfo-example' }

        it "must query the HINFO record for the name under the host name" do
          hinfo_record = subject.get_hinfo_record(name)

          expect(hinfo_record).to be_kind_of(Resolv::DNS::Resource::IN::HINFO)
          expect(hinfo_record.cpu).to eq("some-kinda-cpu")
          expect(hinfo_record.os).to  eq("some-kinda-os")
        end
      end
    end
  end

  describe "#hinfo_record" do
    context "integration", :network do
      let(:hostname) { "hinfo-example.lookup.dog" }

      it "must return the Resolv::DNS::Resource::IN::HINFO record" do
        hinfo_record = subject.hinfo_record

        expect(hinfo_record).to be_kind_of(Resolv::DNS::Resource::IN::HINFO)
        expect(hinfo_record.cpu).to eq("some-kinda-cpu")
        expect(hinfo_record.os).to  eq("some-kinda-os")
      end

      it "must memoize the value" do
        expect(subject.hinfo_record).to be(subject.hinfo_record)
      end

      context "when the host name does not have a HINFO record" do
        let(:hostname) { 'example.com' }

        it "must return nil" do
          expect(subject.hinfo_record).to be(nil)
        end
      end
    end
  end

  describe "#get_a_record" do
    context "integration", :network do
      let(:hostname)     { 'example.com'   }
      let(:ipv4_address) { '93.184.216.34' }

      it "must return the first Resolv::DNS::Resource::IN::A record" do
        a_record = subject.get_a_record

        expect(a_record).to be_kind_of(Resolv::DNS::Resource::IN::A)
        expect(a_record.address.to_s).to eq(ipv4_address)
      end

      context "when the host name does not have any A records" do
        let(:hostname) { '_spf.google.com' }

        it "must return nil" do
          expect(subject.get_a_record).to be(nil)
        end
      end

      context "when a record name is given" do
        let(:hostname )    { 'google.com' }
        let(:name)         { 'ns' }
        let(:ipv4_address) { '216.239.32.10' }

        it "must query the A record for the name under the host name" do
          a_record = subject.get_a_record(name)

          expect(a_record).to be_kind_of(Resolv::DNS::Resource::IN::A)
          expect(a_record.address.to_s).to eq(ipv4_address)
        end
      end
    end
  end

  describe "#get_a_address" do
    context "integration", :network do
      let(:hostname)     { 'example.com'   }
      let(:ipv4_address) { '93.184.216.34' }

      it "must return the first IPv4 address" do
        expect(subject.get_a_address).to eq(ipv4_address)
      end

      context "when the host name does not have any A records" do
        let(:hostname) { '_spf.google.com' }

        it "must return nil" do
          expect(subject.get_a_address).to be(nil)
        end
      end

      context "when a record name is given" do
        let(:hostname )    { 'google.com' }
        let(:name)         { 'ns' }
        let(:ipv4_address) { '216.239.32.10' }

        it "must query the IPv4 address for the name under the host name" do
          expect(subject.get_a_address(name)).to eq(ipv4_address)
        end
      end
    end
  end

  describe "#get_a_records" do
    context "integration", :network do
      let(:hostname)     { 'example.com'   }
      let(:ipv4_address) { '93.184.216.34' }

      it "must return all Resolv::DNS::Resource::IN::A records" do
        a_records = subject.get_a_records

        expect(a_records).to_not be_empty
        expect(a_records).to all(be_kind_of(Resolv::DNS::Resource::IN::A))
      end

      context "when the host name does not have any A records" do
        let(:hostname) { '_spf.google.com' }

        it "must return an empty Array" do
          expect(subject.get_a_records).to eq([])
        end
      end

      context "when a record name is given" do
        let(:hostname )    { 'google.com' }
        let(:name)         { 'ns' }
        let(:ipv4_address) { '216.239.32.10' }

        it "must query the A records for the name under the host name" do
          a_records = subject.get_a_records(name)

          expect(a_records).to_not be_empty
          expect(a_records).to all(be_kind_of(Resolv::DNS::Resource::IN::A))
          expect(a_records.first.address.to_s).to eq(ipv4_address)
        end
      end
    end
  end

  describe "#get_a_addresses" do
    context "integration", :network do
      let(:hostname)     { 'example.com'   }
      let(:ipv4_address) { '93.184.216.34' }

      it "must return all IPv4 addresses" do
        expect(subject.get_a_addresses).to eq([ipv4_address])
      end

      context "when the host name does not have any A records" do
        let(:hostname) { '_spf.google.com' }

        it "must return an empty Array" do
          expect(subject.get_a_addresses).to eq([])
        end
      end

      context "when a record name is given" do
        let(:hostname )    { 'google.com' }
        let(:name)         { 'ns' }
        let(:ipv4_address) { '216.239.32.10' }

        it "must query the IPv4 addresses for the name under the host name" do
          expect(subject.get_a_addresses(name)).to eq([ipv4_address])
        end
      end
    end
  end

  describe "#get_aaaa_record" do
    context "integration", :network do
      let(:hostname)     { 'example.com' }
      let(:ipv6_address) { '2606:2800:220:1:248:1893:25c8:1946' }

      it "must return the first Resolv::DNS::Resource::IN::AAAA record" do
        aaaa_record = subject.get_aaaa_record

        expect(aaaa_record).to be_kind_of(Resolv::DNS::Resource::IN::AAAA)
        expect(aaaa_record.address.to_s).to eq(ipv6_address)
      end

      context "when the host name does not have any AAAA records" do
        let(:hostname) { '_spf.google.com' }

        it "must return nil" do
          expect(subject.get_aaaa_record).to be(nil)
        end
      end

      context "when a record name is given" do
        let(:hostname )    { 'google.com' }
        let(:name)         { 'ns2' }
        let(:ipv6_address) { '2001:4860:4802:34::a' }

        it "must query the AAAA record for the name under the host name" do
          aaaa_record = subject.get_aaaa_record(name)

          expect(aaaa_record).to be_kind_of(Resolv::DNS::Resource::IN::AAAA)
          expect(aaaa_record.address.to_s).to eq(ipv6_address)
        end
      end
    end
  end

  describe "#get_aaaa_address" do
    context "integration", :network do
      let(:hostname)     { 'example.com' }
      let(:ipv6_address) { '2606:2800:220:1:248:1893:25c8:1946' }

      it "must return the first IPv6 address" do
        expect(subject.get_aaaa_address).to eq(ipv6_address)
      end

      context "when the host name does not have any AAAA records" do
        let(:hostname) { '_spf.google.com' }

        it "must return nil" do
          expect(subject.get_aaaa_address).to be(nil)
        end
      end

      context "when a record name is given" do
        let(:hostname )    { 'google.com' }
        let(:name)         { 'ns2' }
        let(:ipv6_address) { '2001:4860:4802:34::a' }

        it "must query the IPv6 address for the name under the host name" do
          expect(subject.get_aaaa_address(name)).to eq(ipv6_address)
        end
      end
    end
  end

  describe "#get_aaaa_records" do
    context "integration", :network do
      let(:hostname)     { 'example.com' }
      let(:ipv6_address) { '2606:2800:220:1:248:1893:25c8:1946' }

      it "must return all Resolv::DNS::Resource::IN::AAAA records" do
        aaaa_records = subject.get_aaaa_records

        expect(aaaa_records).to_not be_empty
        expect(aaaa_records).to all(be_kind_of(Resolv::DNS::Resource::IN::AAAA))
      end

      context "when the host name does not have any AAAA records" do
        let(:hostname) { '_spf.google.com' }

        it "must return an empty Array" do
          expect(subject.get_aaaa_records).to eq([])
        end
      end

      context "when a record name is given" do
        let(:hostname )    { 'google.com' }
        let(:name)         { 'ns2' }
        let(:ipv6_address) { '2001:4860:4802:34::a' }

        it "must query the AAAA records for the name under the host name" do
          aaaa_records = subject.get_aaaa_records(name)

          expect(aaaa_records).to_not be_empty
          expect(aaaa_records).to all(be_kind_of(Resolv::DNS::Resource::IN::AAAA))
          expect(aaaa_records.first.address.to_s).to eq(ipv6_address)
        end
      end
    end
  end

  describe "#get_aaaa_addresses" do
    context "integration", :network do
      let(:hostname)     { 'example.com' }
      let(:ipv6_address) { '2606:2800:220:1:248:1893:25c8:1946' }

      it "must return the IPv6 addresses" do
        expect(subject.get_aaaa_addresses).to eq([ipv6_address])
      end

      context "when the host name does not have any AAAA records" do
        let(:hostname) { '_spf.google.com' }

        it "must return an empty Array" do
          expect(subject.get_aaaa_addresses).to eq([])
        end
      end

      context "when a record name is given" do
        let(:hostname )    { 'google.com' }
        let(:name)         { 'ns2' }
        let(:ipv6_address) { '2001:4860:4802:34::a' }

        it "must query the IPv6 address for the name under the host name" do
          expect(subject.get_aaaa_addresses(name)).to eq([ipv6_address])
        end
      end
    end
  end

  describe "#get_srv_records" do
    context "integration", :network do
      let(:hostname) { '_http._tcp.update.freebsd.org' }

      it "must return all Resolv::DNS::Resource::IN::SRV records" do
        srv_records = subject.get_srv_records

        expect(srv_records).to_not be_empty
        expect(srv_records).to all(be_kind_of(Resolv::DNS::Resource::IN::SRV))
      end

      context "when the host name does not have any SRV records" do
        let(:hostname) { 'example.com' }

        it "must return an empty Array" do
          expect(subject.get_srv_records).to eq([])
        end
      end

      context "when a record name is given" do
        let(:hostname )    { 'update.freebsd.org' }
        let(:name)         { '_http._tcp' }

        it "must query the SRV records for the name under the host name" do
          srv_records = subject.get_srv_records(name)

          expect(srv_records).to_not be_empty
          expect(srv_records).to all(be_kind_of(Resolv::DNS::Resource::IN::SRV))
        end
      end
    end
  end

  describe "#get_wks_records" do
    context "integration", :network do
      it "must return all Resolv::DNS::Resource::IN::WKS records" do
        pending "cannot find a host that still has a WKS record"

        wks_records = subject.get_wks_records

        expect(wks_records).to_not be_empty
        expect(wks_records).to all(be_kind_of(Resolv::DNS::Resource::IN::WKS))
      end

      context "when the host name does not have any WKS records" do
        let(:hostname) { 'example.com' }

        it "must return an empty Array" do
          expect(subject.get_wks_records).to eq([])
        end
      end

      context "when a record name is given" do
        it "must query the WKS records for the name under the host name" do
          pending "cannot find a host that still has a WKS record"

          wks_records = subject.get_wks_records(name)

          expect(wks_records).to_not be_empty
          expect(wks_records).to all(be_kind_of(Resolv::DNS::Resource::IN::WKS))
        end
      end
    end
  end

  describe "#get_loc_record" do
    context "integration", :network do
      it "must return the Resolv::DNS::Resource::IN::LOC record" do
        pending "cannot find a host that still has a LOC record"

        expect(subject.get_loc_record).to be_kind_of(Resolv::DNS::Resource::IN::LOC)
      end

      context "when the host name does not have any LOC records" do
        let(:hostname) { 'example.com' }

        it "must return nil" do
          expect(subject.get_loc_record).to be(nil)
        end
      end

      context "when a record name is given" do
        it "must query the LOC records for the name under the host name" do
          pending "cannot find a host that still has a LOC record"

          loc_records = subject.get_loc_records(name)

          expect(loc_records).to_not be_empty
          expect(loc_records).to all(be_kind_of(Resolv::DNS::Resource::IN::LOC))
        end
      end
    end
  end

  describe "#get_minfo_record" do
    context "integration", :network do
      it "must return the Resolv::DNS::Resource::IN::MINFO record" do
        pending "cannot find a host that still has a MINFO record"

        expect(subject.get_minfo_record).to be_kind_of(Resolv::DNS::Resource::IN::MINFO)
      end

      context "when the host name does not have any MINFO records" do
        let(:hostname) { 'example.com' }

        it "must return nil" do
          expect(subject.get_minfo_record).to be(nil)
        end
      end

      context "when a record name is given" do
        it "must query the MINFO record for the name under the host name" do
          pending "cannot find a host that still has a MINFO record"

          minfo_records = subject.get_minfo_records(name)

          expect(minfo_records).to_not be_empty
          expect(minfo_records).to all(be_kind_of(Resolv::DNS::Resource::IN::MINFO))
        end
      end
    end
  end

  describe "#get_mx_records" do
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

      it "must return all Resolv::DNS::Resource::IN::MX records" do
        mx_records = subject.get_mx_records

        expect(mx_records).to_not be_empty
        expect(mx_records).to all(be_kind_of(Resolv::DNS::Resource::IN::MX))
        expect(mx_records.map(&:exchange).map(&:to_s)).to match_array(mailservers)
      end

      context "when the host name does not have any MX records" do
        let(:hostname) { 'www.example.com' }

        it "must return an empty Array" do
          expect(subject.get_mx_records).to eq([])
        end
      end

      context "when a record name is given" do
        it "must query the MX records for the name under the host name" do
          pending "cannot find a sub-domain that has a MX record"

          mx_records = subject.get_minfo_records(name)

          expect(mx_records).to_not be_empty
          expect(mx_records).to all(be_kind_of(Resolv::DNS::Resource::IN::MX))
        end
      end
    end
  end

  describe "#get_mailservers" do
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
        expect(subject.get_mailservers).to match_array(mailservers)
      end

      context "when the host name does not have any MX records" do
        let(:hostname) { 'www.example.com' }

        it "must return an empty Array" do
          expect(subject.get_mailservers).to eq([])
        end
      end
    end
  end

  describe "#mailservers" do
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
        expect(subject.mailservers).to match_array(mailservers)
      end

      it "must memoize the value" do
        expect(subject.mailservers).to be(subject.mailservers)
      end

      context "when the host name does not have any MX records" do
        let(:hostname) { 'www.example.com' }

        it "must return an empty Array" do
          expect(subject.mailservers).to eq([])
        end
      end
    end
  end

  describe "#has_mailservers?" do
    context "integration", :network do
      context "when the hostname has mailservers" do
        let(:hostname) { 'example.com' }

        it "must return true" do
          expect(subject.has_mailservers?).to be(true)
        end
      end

      context "when the host name does not have any NS records" do
        let(:hostname) { 'www.example.com' }

        it "must return false" do
          expect(subject.has_mailservers?).to be(false)
        end
      end
    end
  end

  describe "#get_ns_records" do
    context "integration", :network do
      let(:hostname) { 'example.com' }

      it "must return all Resolv::DNS::Resource::IN::NS records" do
        ns_records = subject.get_ns_records

        expect(ns_records).to_not be_empty
        expect(ns_records).to all(be_kind_of(Resolv::DNS::Resource::IN::NS))
      end

      context "when the host name does not have any NS records" do
        let(:hostname) { 'www.example.com' }

        it "must return an empty Array" do
          expect(subject.get_ns_records).to eq([])
        end
      end

      context "when a record name is given" do
        it "must query the NS records for the name under the host name" do
          pending "cannot find a sub-domain that has a NS record"

          ns_records = subject.get_minfo_records(name)

          expect(ns_records).to_not be_empty
          expect(ns_records).to all(be_kind_of(Resolv::DNS::Resource::IN::NS))
        end
      end
    end
  end

  describe "#get_nameservers" do
    context "integration", :network do
      let(:hostname) { 'example.com' }
      let(:nameserver_names) do
        %w[
          b.iana-servers.net
          a.iana-servers.net
        ]
      end

      it "must return the Array of nameserver host names" do
        expect(subject.get_nameservers).to match_array(nameserver_names)
      end

      context "when the host name does not have any NS records" do
        let(:hostname) { 'www.example.com' }

        it "must return an empty Array" do
          expect(subject.get_nameservers).to eq([])
        end
      end
    end
  end

  describe "#nameservers" do
    context "integration", :network do
      let(:hostname) { 'example.com' }
      let(:nameserver_names) do
        %w[
          b.iana-servers.net
          a.iana-servers.net
        ]
      end

      it "must return the Array of nameserver host names" do
        expect(subject.nameservers).to match_array(nameserver_names)
      end

      it "must memoize the value" do
        expect(subject.nameservers).to be(subject.nameservers)
      end

      context "when the host name does not have any NS records" do
        let(:hostname) { 'www.example.com' }

        it "must return an empty Array" do
          expect(subject.nameservers).to eq([])
        end
      end
    end
  end

  describe "#has_nameservers?" do
    context "integration", :network do
      context "when the hostname has nameservers" do
        let(:hostname) { 'example.com' }

        it "must return true" do
          expect(subject.has_nameservers?).to be(true)
        end
      end

      context "when the host name does not have any NS records" do
        let(:hostname) { 'www.example.com' }

        it "must return false" do
          expect(subject.has_nameservers?).to be(false)
        end
      end
    end
  end

  describe "#get_soa_record" do
    context "integration", :network do
      let(:hostname) { 'example.com' }

      it "must return the Resolv::DNS::Resource::IN::SOA record" do
        soa_record = subject.get_soa_record

        expect(soa_record).to be_kind_of(Resolv::DNS::Resource::IN::SOA)
      end

      context "when the host name does not have any SOA records" do
        let(:hostname) { 'www.example.com' }

        it "must return nil" do
          expect(subject.get_soa_record).to be(nil)
        end
      end

      context "when a record name is given" do
        it "must query the SOA record for the name under the host name" do
          pending "cannot find a sub-domain that has a SOA record"

          soa_record = subject.get_soa_records(name)

          expect(soa_record).to all(be_kind_of(Resolv::DNS::Resource::IN::SOA))
        end
      end
    end
  end

  describe "#soa_record" do
    context "integration", :network do
      let(:hostname) { 'example.com' }

      it "must return the Resolv::DNS::Resource::IN::SOA record" do
        soa_record = subject.soa_record

        expect(soa_record).to be_kind_of(Resolv::DNS::Resource::IN::SOA)
      end

      it "must memoize the value" do
        expect(subject.soa_record).to be(subject.soa_record)
      end

      context "when the host name does not have any SOA records" do
        let(:hostname) { 'www.example.com' }

        it "must return nil" do
          expect(subject.soa_record).to be(nil)
        end
      end
    end
  end

  describe "#get_txt_record" do
    context "integration", :network do
      let(:hostname) { 'example.com' }

      it "must return the first Resolv::DNS::Resource::IN::TXT record" do
        txt_record = subject.get_txt_record

        expect(txt_record).to be_kind_of(Resolv::DNS::Resource::IN::TXT)
        expect(txt_record.strings).to eq([example_spf_record]).or(
          eq([example_txt_record])
        )
      end

      context "when the host name does not have any TXT records" do
        let(:hostname) { 'a.iana-servers.net' }

        it "must return nil" do
          expect(subject.get_txt_record).to be(nil)
        end
      end

      context "when a record name is given" do
        let(:hostname )    { 'google.com' }
        let(:name)         { '_spf' }

        it "must query the first TXT record for the name under the host name" do
          txt_record = subject.get_txt_record(name)

          expect(txt_record).to be_kind_of(Resolv::DNS::Resource::IN::TXT)
          expect(txt_record.strings).to eq([google_spf_record]).or(
            eq([google_txt_record])
          )
        end
      end
    end
  end

  describe "#get_txt_string" do
    context "integration", :network do
      let(:hostname) { 'example.com' }

      it "must return the first TXT string" do
        expect(subject.get_txt_string).to eq(example_spf_record).or(
          eq(example_txt_record)
        )
      end

      context "when the host name does not have any TXT records" do
        let(:hostname) { 'a.iana-servers.net' }

        it "must return nil" do
          expect(subject.get_txt_string).to be(nil)
        end
      end

      context "when a record name is given" do
        let(:hostname )    { 'google.com' }
        let(:name)         { '_spf' }

        it "must query the first TXT string for the name under the host name" do
          expect(subject.get_txt_string(name)).to eq(google_spf_record).or(
            eq(google_txt_record)
          )
        end
      end
    end
  end

  describe "#get_txt_records" do
    context "integration", :network do
      let(:hostname) { 'example.com' }

      it "must return all Resolv::DNS::Resource::IN::TXT records" do
        txt_records = subject.get_txt_records

        expect(txt_records).to all(be_kind_of(Resolv::DNS::Resource::IN::TXT))
        expect(txt_records.map(&:strings).flatten).to match_array(
          [example_spf_record, example_txt_record]
        )
      end

      context "when the host name does not have any TXT records" do
        let(:hostname) { 'a.iana-servers.net' }

        it "must return an empty Array" do
          expect(subject.get_txt_records).to eq([])
        end
      end

      context "when a record name is given" do
        let(:hostname )    { 'google.com' }
        let(:name)         { '_spf' }

        it "must query the TXT records for the name under the host name" do
          txt_records = subject.get_txt_records(name)

          expect(txt_records).to_not be_empty
          expect(txt_records).to all(be_kind_of(Resolv::DNS::Resource::IN::TXT))
          expect(txt_records.map(&:strings).flatten).to eq([google_spf_record])
        end
      end
    end
  end

  describe "#get_txt_strings" do
    context "integration", :network do
      let(:hostname) { 'example.com' }

      it "must return all TXT string" do
        expect(subject.get_txt_strings).to match_array(
          [example_spf_record, example_txt_record]
        )
      end

      context "when the host name does not have any TXT records" do
        let(:hostname) { 'a.iana-servers.net' }

        it "must return an empty Array" do
          expect(subject.get_txt_strings).to eq([])
        end
      end

      context "when a record name is given" do
        let(:hostname )    { 'google.com' }
        let(:name)         { '_spf' }

        it "must query the first TXT string for the name under the host name" do
          expect(subject.get_txt_strings(name)).to eq([google_spf_record])
        end
      end
    end
  end

  describe "#txt_strings" do
    context "integration", :network do
      let(:hostname) { 'example.com' }

      it "must return all TXT string" do
        expect(subject.get_txt_strings).to match_array(
          [example_spf_record, example_txt_record]
        )
      end

      it "must memoize the value" do
        expect(subject.txt_strings).to be(subject.txt_strings)
      end

      context "when the host name does not have any TXT records" do
        let(:hostname) { 'a.iana-servers.net' }

        it "must return an empty Array" do
          expect(subject.txt_strings).to eq([])
        end
      end
    end
  end

  describe "#registered?" do
    context "integration", :network do
      context "when the host name has at least one record" do
        let(:hostname) { 'github.com' }

        it "must return true" do
          expect(subject.registered?).to be(true)
        end
      end

      context "when the host name does not have any records" do
        let(:hostname) { 'github.comsec' }

        it "must return false" do
          expect(subject.registered?).to be(false)
        end
      end
    end
  end

  describe "#unregistered?" do
    context "integration", :network do
      context "when the host name has at least one record" do
        let(:hostname) { 'github.com' }

        it "must return false" do
          expect(subject.unregistered?).to be(false)
        end
      end

      context "when the host name does not have any records" do
        let(:hostname) { 'github.comsec' }

        it "must return true" do
          expect(subject.unregistered?).to be(true)
        end
      end
    end
  end

  describe "#to_s" do
    it "must return the host name String" do
      expect(subject.to_s).to eq(hostname)
    end
  end

  describe "#to_str" do
    it "must return the host name String" do
      expect(subject.to_str).to eq(hostname)
    end
  end

  describe "#inspect" do
    it "must return the class name and #name" do
      expect(subject.inspect).to eq("#<#{described_class}: #{hostname}>")
    end
  end
end
