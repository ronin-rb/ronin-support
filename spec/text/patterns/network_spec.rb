require 'spec_helper'
require 'matchers/fully_match'
require 'ronin/support/text/patterns/network'

describe Ronin::Support::Text::Patterns do
  describe "MAC_ADDR" do
    subject { described_class::MAC_ADDR }

    it "must match six hexadecimal bytes" do
      mac_addr = '12:34:56:78:9a:bc'

      expect(mac_addr).to fully_match(subject)
    end
  end

  describe "IPV4_ADDR" do
    subject { described_class::IPV4_ADDR }

    it "must match valid addresses" do
      ip = '127.0.0.1'

      expect(ip).to fully_match(subject)
    end

    it "must match the Any address" do
      ip = '0.0.0.0'

      expect(ip).to fully_match(subject)
    end

    it "must match the broadcast address" do
      ip = '255.255.255.255'

      expect(ip).to fully_match(subject)
    end

    it "must match addresses with netmasks" do
      ip = '10.1.1.1/24'

      expect(ip).to fully_match(subject)
    end

    it "must not match addresses with octets > 255" do
      ip = '10.1.256.1'

      expect(ip).to_not match(subject)
    end

    it "must not match addresses with more than three digits per octet" do
      ip = '10.1111.1.1'

      expect(ip).to_not match(subject)
    end
  end

  describe "IPV6_ADDR" do
    subject { described_class::IPV6_ADDR }

    it "must match valid IPv6 addresses" do
      ip = '2001:db8:85a3:0:0:8a2e:370:7334'

      expect(ip).to fully_match(subject)
    end

    it "must match IPv6 addresses with netmasks" do
      ip = '2001:db8:1234::/48'

      expect(ip).to fully_match(subject)
    end

    it "must match truncated IPv6 addresses" do
      ip = '2001:db8:85a3::8a2e:370:7334'

      expect(ip).to fully_match(subject)
    end

    it "must match IPv4-mapped IPv6 addresses" do
      ip = '::ffff:192.0.2.128'

      expect(ip).to fully_match(subject)
    end
  end

  describe "IP_ADDR" do
    subject { described_class::IP_ADDR }

    it "must match IPv4 addresses" do
      ip = '10.1.1.1'

      expect(ip).to fully_match(subject)
    end

    it "must match IPv6 addresses" do
      ip = '2001:db8:85a3:0:0:8a2e:370:7334'

      expect(ip).to fully_match(subject)
    end
  end

  describe "DOMAIN" do
    subject { described_class::DOMAIN }

    it "must match valid domain names" do
      domain = 'example.com'

      expect(domain).to fully_match(subject)
    end

    it "must not match hostnames without a TLD" do
      expect('foo').to_not match(subject)
    end

    it "must match domains within punctuation" do
      domain = 'example.com'
      html   = "<a href=\"https://#{domain}/foo>link</a>"

      expect(html.match(subject)[0]).to eq(domain)
    end

    it "must match domains within hostnames" do
      domain   = 'example.com'
      hostname = "www.#{domain}"

      expect(hostname.match(subject)[0]).to eq(domain)
    end

    it "must not match domains starting with a '_' character" do
      expect("_foo.com").to_not match(subject)
    end

    it "must not match domains ending with a '_' character" do
      expect("foo_.com").to_not match(subject)
    end

    it "must not match domains containing '_' characters" do
      expect("foo_bar.com").to_not match(subject)
    end

    it "must not match domains starting with a '-' character" do
      expect("-foo.com").to_not match(subject)
    end

    it "must not match domains ending with a '-' character" do
      expect("foo-.com").to_not match(subject)
    end

    it "must not match domains with unknown TLDs" do
      expect('foo.zzz').to_not match(subject)
    end

    it "must not partially match a string which contains a TLD name" do
      expect('foo.commmmm').to_not match(subject)
    end

    it "must not match domains with TLDs that begin with a valid TLD" do
      expect("foo.comzzz").to_not match(subject)
    end
  end

  describe "HOST_NAME" do
    subject { described_class::HOST_NAME }

    it "must match valid hostnames" do
      hostname = 'www.example.com'

      expect(hostname).to fully_match(subject)
    end

    it "must match sub-sub-domains" do
      hostname = 'foo.bar.example.com'

      expect(hostname).to fully_match(subject)
    end

    it "must also match valid domain names" do
      hostname = 'example.com'

      expect(hostname).to fully_match(subject)
    end

    it "must match hostnames starting with a '_' character" do
      hostname = '_spf.example.com'

      expect(hostname).to fully_match(subject)
    end

    it "must match hostnames within punctuation" do
      hostname = 'www.example.com'
      html     = "<a href=\"https://#{hostname}/foo>link</a>"

      expect(html.match(subject)[0]).to eq(hostname)
    end

    it "must not match hostnames starting with a '.' character" do
      expect('.www.example.com').to_not match(subject)
    end

    it "must not match hostnames with labels longer than 63 characters" do
      label    = 'a' * 64
      hostname = "#{label}.example.com"

      expect(hostname).to_not match(subject)
    end

    it "must not match hostnames without a TLD" do
      expect('www.has-no-tld').to_not match(subject)
    end

    it "must not match hostnames with unknown TLDs" do
      expect('www.foo.zzz').to_not match(subject)
    end

    it "must not match hostnames with TLDs that begin with a valid TLD" do
      expect("www.foo.comzzz").to_not match(subject)
    end
  end

  describe "URI" do
    subject { described_class::URI }

    it "must match http://example.com" do
      expect("http://example.com").to fully_match(subject)
    end

    it "must match https://example.com" do
      expect("https://example.com").to fully_match(subject)
    end

    it "must match http://www.example.com" do
      expect("http://example.com").to fully_match(subject)
    end

    it "must match http://127.0.0.1" do
      expect("http://127.0.0.1").to fully_match(subject)
    end

    it "must match http://127.0.0.1:8000" do
      expect("http://127.0.0.1:8000").to fully_match(subject)
    end

    it "must match http://[::1]" do
      expect("http://[::1]").to fully_match(subject)
    end

    it "must match http://[::1]:8000" do
      expect("http://[::1]:8000").to fully_match(subject)
    end

    it "must match http://example.com:8000" do
      expect("http://example.com:8000").to fully_match(subject)
    end

    it "must match http://user@example.com" do
      expect("http://user@example.com").to fully_match(subject)
    end

    it "must match http://user:password@example.com" do
      expect("http://user:password@example.com").to fully_match(subject)
    end

    it "must match http://user:password@example.com:8000" do
      expect("http://user:password@example.com:8000").to fully_match(subject)
    end

    it "must match http://example.com/" do
      expect("http://example.com/").to fully_match(subject)
    end

    it "must match http://example.com:8000/" do
      expect("http://example.com:8000/").to fully_match(subject)
    end

    it "must match http://example.com/foo" do
      expect("http://example.com/foo").to fully_match(subject)
    end

    it "must match http://example.com/foo/bar" do
      expect("http://example.com/foo/bar").to fully_match(subject)
    end

    it "must match http://example.com/foo/./bar" do
      expect("http://example.com/foo/./bar").to fully_match(subject)
    end

    it "must match http://example.com/foo/../bar" do
      expect("http://example.com/foo/../bar").to fully_match(subject)
    end

    it "must match http://example.com/foo%20bar" do
      expect("http://example.com/foo%20bar").to fully_match(subject)
    end

    it "must match http://example.com?id=1" do
      expect("http://example.com?id=1").to fully_match(subject)
    end

    it "must match http://example.com/?id=1" do
      expect("http://example.com/?id=1").to fully_match(subject)
    end

    it "must match http://example.com/foo?id=1" do
      expect("http://example.com/foo?id=1").to fully_match(subject)
    end

    it "must match http://example.com/foo?id=%20" do
      expect("http://example.com/foo?id=%20").to fully_match(subject)
    end

    it "must match http://example.com#fragment" do
      expect("http://example.com#fragment").to fully_match(subject)
    end

    it "must match http://example.com/#fragment" do
      expect("http://example.com/#fragment").to fully_match(subject)
    end

    it "must match http://example.com/foo#fragment" do
      expect("http://example.com/foo#fragment").to fully_match(subject)
    end

    it "must match http://example.com?id=1#fragment" do
      expect("http://example.com?id=1#fragment").to fully_match(subject)
    end

    it "must match http://example.com/?id=1#fragment" do
      expect("http://example.com/?id=1#fragment").to fully_match(subject)
    end

    it "must match http://example.com/foo?id=1#fragment" do
      expect("http://example.com/foo?id=1#fragment").to fully_match(subject)
    end

    it "must match ssh://user@host.example.com" do
      expect("ssh://user@host.example.com").to fully_match(subject)
    end

    it "must match ldap://ds.example.com:389" do
      expect("ldap://ds.example.com:389").to fully_match(subject)
    end

    it "must match foo://host" do
      expect("foo://host").to fully_match(subject)
    end

    it "must match foo:/path" do
      expect("foo:/path").to fully_match(subject)
    end

    it "must match foo:" do
      expect("foo:").to fully_match(subject)
    end
  end

  describe "URL" do
    subject { described_class::URL }

    it "must match http://example.com" do
      expect("http://example.com").to fully_match(subject)
    end

    it "must match https://example.com" do
      expect("https://example.com").to fully_match(subject)
    end

    it "must match http://www.example.com" do
      expect("http://example.com").to fully_match(subject)
    end

    it "must match http://127.0.0.1" do
      expect("http://127.0.0.1").to fully_match(subject)
    end

    it "must match http://127.0.0.1:8000" do
      expect("http://127.0.0.1:8000").to fully_match(subject)
    end

    it "must match http://[::1]" do
      expect("http://[::1]").to fully_match(subject)
    end

    it "must match http://[::1]:8000" do
      expect("http://[::1]:8000").to fully_match(subject)
    end

    it "must match http://example.com:8000" do
      expect("http://example.com:8000").to fully_match(subject)
    end

    it "must match http://user@example.com" do
      expect("http://user@example.com").to fully_match(subject)
    end

    it "must match http://user:password@example.com" do
      expect("http://user:password@example.com").to fully_match(subject)
    end

    it "must match http://user:password@example.com:8000" do
      expect("http://user:password@example.com:8000").to fully_match(subject)
    end

    it "must match http://example.com/" do
      expect("http://example.com/").to fully_match(subject)
    end

    it "must match http://example.com:8000/" do
      expect("http://example.com:8000/").to fully_match(subject)
    end

    it "must match http://example.com/foo" do
      expect("http://example.com/foo").to fully_match(subject)
    end

    it "must match http://example.com/foo/bar" do
      expect("http://example.com/foo/bar").to fully_match(subject)
    end

    it "must match http://example.com/foo/./bar" do
      expect("http://example.com/foo/./bar").to fully_match(subject)
    end

    it "must match http://example.com/foo/../bar" do
      expect("http://example.com/foo/../bar").to fully_match(subject)
    end

    it "must match http://example.com/foo%20bar" do
      expect("http://example.com/foo%20bar").to fully_match(subject)
    end

    it "must match http://example.com?id=1" do
      expect("http://example.com?id=1").to fully_match(subject)
    end

    it "must match http://example.com/?id=1" do
      expect("http://example.com/?id=1").to fully_match(subject)
    end

    it "must match http://example.com/foo?id=1" do
      expect("http://example.com/foo?id=1").to fully_match(subject)
    end

    it "must match http://example.com/foo?id=%20" do
      expect("http://example.com/foo?id=%20").to fully_match(subject)
    end

    it "must match http://example.com#fragment" do
      expect("http://example.com#fragment").to fully_match(subject)
    end

    it "must match http://example.com/#fragment" do
      expect("http://example.com/#fragment").to fully_match(subject)
    end

    it "must match http://example.com/foo#fragment" do
      expect("http://example.com/foo#fragment").to fully_match(subject)
    end

    it "must match http://example.com?id=1#fragment" do
      expect("http://example.com?id=1#fragment").to fully_match(subject)
    end

    it "must match http://example.com/?id=1#fragment" do
      expect("http://example.com/?id=1#fragment").to fully_match(subject)
    end

    it "must match http://example.com/foo?id=1#fragment" do
      expect("http://example.com/foo?id=1#fragment").to fully_match(subject)
    end

    it "must match ssh://user@host.example.com" do
      expect("ssh://user@host.example.com").to fully_match(subject)
    end

    it "must match ldap://ds.example.com:389" do
      expect("ldap://ds.example.com:389").to fully_match(subject)
    end

    it "must not match http://" do
      expect("http://").to_not match(subject)
    end
  end
end
