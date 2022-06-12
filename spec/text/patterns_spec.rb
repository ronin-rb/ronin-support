require 'spec_helper'
require 'ronin/support/text/patterns'

describe Ronin::Support::Text::Patterns do
  describe "NUMBER" do
    subject { described_class::NUMBER }

    let(:number) { '0123456789' }

    it "must match one or more digits" do
      expect(subject.match(number)[0]).to eq(number)
    end
  end

  describe "HEX_NUMBER" do
    subject { described_class::HEX_NUMBER }

    it "must match one or more decimal digits" do
      number = "0123456789"

      expect(subject.match(number)[0]).to eq(number)
    end

    it "must match one or more lowercase hexadecimal digits" do
      hex = "0123456789abcdef"

      expect(subject.match(hex)[0]).to eq(hex)
    end

    it "must match one or more uppercase hexadecimal digits" do
      hex = "0123456789ABCDEF"

      expect(subject.match(hex)[0]).to eq(hex)
    end

    context "when the number begins with '0x'" do
      it "must match one or more decimal digits" do
        number = "0x0123456789"

        expect(subject.match(number)[0]).to eq(number)
      end

      it "must match one or more lowercase hexadecimal digits" do
        hex = "0x0123456789abcdef"

        expect(subject.match(hex)[0]).to eq(hex)
      end

      it "must match one or more uppercase hexadecimal digits" do
        hex = "0x0123456789ABCDEF"

        expect(subject.match(hex)[0]).to eq(hex)
      end
    end
  end

  describe "HASH" do
    subject { described_class::HASH }

    it "must not match non-hex characters" do
      string = 'X' * 32

      expect(subject.match(string)).to be(nil)
    end

    it "must not match hex strings less than 32 characters" do
      string = "0123456789abcdef"

      expect(subject.match(string)).to be(nil)
    end

    it "must match hex strings with 32 characters" do
      string = "5d41402abc4b2a76b9719d911017c592"

      expect(subject.match(string)[0]).to eq(string)
    end

    it "must match hex strings with 40 characters" do
      string = "aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d"

      expect(subject.match(string)[0]).to eq(string)
    end

    it "must match hex strings with 64 characters" do
      string = "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"

      expect(subject.match(string)[0]).to eq(string)
    end

    it "must match hex strings with 128 characters" do
      string = "9b71d224bd62f3785d96d46ad3ea3d73319bfbc2890caadae2dff72519673ca72323c3d99ba5c11d7c7acc6e14b8c5da0c4663475c2e5c3adef46f73bcdec043"

      expect(subject.match(string)[0]).to eq(string)
    end
  end

  describe "WORD" do
    let(:word) { 'dog' }

    subject { described_class::WORD }

    it "must not match single letters" do
      expect(subject.match('A')).to be_nil
    end

    it "must not match numeric letters" do
      expect(subject.match("123#{word}123")[0]).to eq(word)
    end

    it "must not include ending periods" do
      expect(subject.match("#{word}.")[0]).to eq(word)
    end

    it "must not include leading punctuation" do
      expect(subject.match("'#{word}")[0]).to eq(word)
    end

    it "must not include tailing punctuation" do
      expect(subject.match("#{word}'")[0]).to eq(word)
    end

    it "must include punctuation in the middle of the word" do
      name = "O'Brian"

      expect(subject.match(name)[0]).to eq(name)
    end
  end

  describe "DECIMAL_OCTET" do
    subject { described_class::DECIMAL_OCTET }

    it "must match 0 - 255" do
      expect((0..255).all? { |n|
        subject.match(n.to_s)[0] == n.to_s
      }).to be(true)
    end

    it "must not match numbers greater than 255" do
      expect(subject.match('256')[0]).to eq('25')
    end
  end

  describe "MAC_ADDR" do
    subject { described_class::MAC_ADDR }

    it "must match six hexadecimal bytes" do
      mac = '12:34:56:78:9a:bc'

      expect(subject.match(mac)[0]).to eq(mac)
    end
  end

  describe "IPV4_ADDR" do
    subject { described_class::IPV4_ADDR }

    it "must match valid addresses" do
      ip = '127.0.0.1'

      expect(subject.match(ip)[0]).to eq(ip)
    end

    it "must match the Any address" do
      ip = '0.0.0.0'

      expect(subject.match(ip)[0]).to eq(ip)
    end

    it "must match the broadcast address" do
      ip = '255.255.255.255'

      expect(subject.match(ip)[0]).to eq(ip)
    end

    it "must match addresses with netmasks" do
      ip = '10.1.1.1/24'

      expect(subject.match(ip)[0]).to eq(ip)
    end

    it "must not match addresses with octets > 255" do
      ip = '10.1.256.1'

      expect(subject.match(ip)).to be_nil
    end

    it "must not match addresses with more than three digits per octet" do
      ip = '10.1111.1.1'

      expect(subject.match(ip)).to be_nil
    end
  end

  describe "IPV6_ADDR" do
    subject { described_class::IPV6_ADDR }

    it "must match valid IPv6 addresses" do
      ip = '2001:db8:85a3:0:0:8a2e:370:7334'

      expect(subject.match(ip)[0]).to eq(ip)
    end

    it "must match IPv6 addresses with netmasks" do
      ip = '2001:db8:1234::/48'

      expect(subject.match(ip)[0]).to eq(ip)
    end

    it "must match truncated IPv6 addresses" do
      ip = '2001:db8:85a3::8a2e:370:7334'

      expect(subject.match(ip)[0]).to eq(ip)
    end

    it "must match IPv4-mapped IPv6 addresses" do
      ip = '::ffff:192.0.2.128'

      expect(subject.match(ip)[0]).to eq(ip)
    end
  end

  describe "IP_ADDR" do
    subject { described_class::IP_ADDR }

    it "must match IPv4 addresses" do
      ip = '10.1.1.1'

      expect(subject.match(ip)[0]).to eq(ip)
    end

    it "must match IPv6 addresses" do
      ip = '2001:db8:85a3:0:0:8a2e:370:7334'

      expect(subject.match(ip)[0]).to eq(ip)
    end
  end

  describe "DOMAIN" do
    subject { described_class::DOMAIN }

    it "must match valid domain names" do
      domain = 'google.com'

      expect(subject.match(domain)[0]).to eq(domain)
    end

    it "must not match hostnames without a TLD" do
      expect(subject.match('foo')).to be_nil
    end

    it "must not match hostnames with unknown TLDs" do
      expect(subject.match('foo.zzz')).to be_nil
    end
  end

  describe "HOST_NAME" do
    subject { described_class::HOST_NAME }

    it "must match valid hostnames" do
      hostname = 'www.google.com'

      expect(subject.match(hostname)[0]).to eq(hostname)
    end

    it "must also match valid domain names" do
      hostname = 'google.com'

      expect(subject.match(hostname)[0]).to eq(hostname)
    end

    it "must not match hostnames without a TLD" do
      expect(subject.match('foo')).to be_nil
    end

    it "must not match hostnames with unknown TLDs" do
      expect(subject.match('foo.zzz')).to be_nil
    end
  end

  describe "USER_NAME" do
    subject { described_class::USER_NAME }

    it "must match valid user-names" do
      username = 'alice1234'

      expect(subject.match(username)[0]).to eq(username)
    end

    it "must match user-names containing '_' characters" do
      username = 'alice_1234'

      expect(subject.match(username)[0]).to eq(username)
    end

    it "must match user-names containing '.' characters" do
      username = 'alice.1234'

      expect(subject.match(username)[0]).to eq(username)
    end

    it "must not match user-names beginning with numbers" do
      expect(subject.match('1234bob')[0]).to eq('bob')
    end

    it "must not match user-names containing spaces" do
      expect(subject.match('alice eve')[0]).to eq('alice')
    end

    it "must not match user-names containing other symbols" do
      expect(subject.match('alice^eve')[0]).to eq('alice')
    end
  end

  describe "EMAIL_ADDRESS" do
    subject { described_class::EMAIL_ADDRESS }

    it "must match valid email addresses" do
      email = 'alice@example.com'

      expect(subject.match(email)[0]).to eq(email)
    end
  end

  describe "PHONE_NUMBER" do
    subject { described_class::PHONE_NUMBER }

    it "must match 111-2222" do
      number = '111-2222'

      expect(subject.match(number)[0]).to eq(number)
    end

    it "must match 111-2222x9" do
      number = '111-2222x9'

      expect(subject.match(number)[0]).to eq(number)
    end

    it "must match 800-111-2222" do
      number = '800-111-2222'

      expect(subject.match(number)[0]).to eq(number)
    end

    it "must match 1-800-111-2222" do
      number = '1-800-111-2222'

      expect(subject.match(number)[0]).to eq(number)
    end
  end

  describe "IDENTIFIER" do
    subject { described_class::IDENTIFIER }

    it "must match Strings beginning with a '_' character" do
      identifier = '_foo'

      expect(subject.match(identifier)[0]).to eq(identifier)
    end

    it "must match Strings ending with a '_' character" do
      identifier = 'foo_'

      expect(subject.match(identifier)[0]).to eq(identifier)
    end

    it "must not match Strings beginning with numberic characters" do
      expect(subject.match('1234foo')[0]).to eq('foo')
    end

    it "must not match Strings not containing any alpha characters" do
      identifier = '_1234_'

      expect(subject.match(identifier)).to be_nil
    end
  end

  describe "DOUBLE_QUOTED_STRING" do
    subject { described_class::DOUBLE_QUOTED_STRING }

    it "must not match non-quoted text" do
      string = "foo"

      expect(subject.match(string)).to be(nil)
    end

    it "must match double-quoted text" do
      string = "\"foo\""

      expect(subject.match(string)[0]).to eq(string)
    end

    it "must match double-quoted text containing backslash-escaped chars" do
      string = "\"foo\\\"bar\\\"baz\\0\""

      expect(subject.match(string)[0]).to eq(string)
    end
  end

  describe "SINGLE_QUOTED_STRING" do
    subject { described_class::SINGLE_QUOTED_STRING }

    it "must not match non-quoted text" do
      string = "foo"

      expect(subject.match(string)).to be(nil)
    end

    it "must match single-quoted text" do
      string = "'foo'"

      expect(subject.match(string)[0]).to eq(string)
    end

    it "must match single-quoted text containing backslash-escaped chars" do
      string = "'foo\\bar\\''"

      expect(subject.match(string)[0]).to eq(string)
    end
  end

  describe "STRING" do
    subject { described_class::STRING }

    it "must not match non-quoted text" do
      string = "foo"

      expect(subject.match(string)).to be(nil)
    end

    it "must match double-quoted text" do
      string = "\"foo\""

      expect(subject.match(string)[0]).to eq(string)
    end

    it "must match double-quoted text containing backslash-escaped chars" do
      string = "\"foo\\\"bar\\\"baz\\0\""

      expect(subject.match(string)[0]).to eq(string)
    end

    it "must match single-quoted text" do
      string = "'foo'"

      expect(subject.match(string)[0]).to eq(string)
    end

    it "must match single-quoted text containing backslash-escaped chars" do
      string = "'foo\\bar\\''"

      expect(subject.match(string)[0]).to eq(string)
    end
  end

  describe "BASE64" do
    subject { described_class::BASE64 }

    it "must not match alphabetic strings less then four characters long" do
      string = "YWE"

      expect(subject.match(string)).to be(nil)
    end

    it "must match alphabetic strings padded with '=' characters" do
      string = "YQ=="

      expect(subject.match(string)[0]).to eq(string)
    end

    it "must match alphabetic strings with four characters exactly" do
      string = "YWFh"

      expect(subject.match(string)[0]).to eq(string)
    end

    it "must match alphabetic strings longer than four characters but padded with '=' characters" do
      string = "YWFhYQ=="

      expect(subject.match(string)[0]).to eq(string)
    end
  end

  describe "FILE_EXT" do
    subject { described_class::FILE_EXT }

    it "must match the '.' separator character" do
      ext = '.txt'

      expect(subject.match(ext)[0]).to eq(ext)
    end

    it "must not allow '_' characters" do
      expect(subject.match('.foo_bar')[0]).to eq('.foo')
    end

    it "must not allow '-' characters" do
      expect(subject.match('.foo-bar')[0]).to eq('.foo')
    end
  end

  describe "FILE_NAME" do
    subject { described_class::FILE_NAME }

    it "must match the filename and extension" do
      filename = 'foo_bar.txt'

      expect(subject.match(filename)[0]).to eq(filename)
    end

    it "must match '\\' escapped characters" do
      filename = 'foo\\ bar.txt'

      expect(subject.match(filename)[0]).to eq(filename)
    end

    it "must match file names without extensions" do
      filename = 'foo_bar'

      expect(subject.match(filename)[0]).to eq(filename)
    end
  end

  describe "DIR_NAME" do
    subject { described_class::DIR_NAME }

    it "must match directory names" do
      dir = 'foo_bar'

      expect(subject.match(dir)[0]).to eq(dir)
    end

    it "must match '.'" do
      dir = '.'

      expect(subject.match(dir)[0]).to eq(dir)
    end

    it "must match '..'" do
      dir = '..'

      expect(subject.match(dir)[0]).to eq(dir)
    end
  end

  describe "RELATIVE_UNIX_PATH" do
    subject { described_class::RELATIVE_UNIX_PATH }

    it "must match multiple directories" do
      path = 'foo/./bar/../baz'

      expect(subject.match(path)[0]).to eq(path)
    end
  end

  describe "ABSOLUTE_UNIX_PATH" do
    subject { described_class::ABSOLUTE_UNIX_PATH }

    it "must match absolute paths" do
      path = '/foo/bar/baz'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "must match trailing '/' characters" do
      path = '/foo/bar/baz/'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "must not match relative directories" do
      path = '/foo/./bar/../baz'

      expect(subject.match(path)[0]).to eq('/foo/')
    end
  end

  describe "UNIX_PATH" do
    subject { described_class::UNIX_PATH }

    it "must match relative paths" do
      path = 'foo/./bar/../baz'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "must match absolute paths" do
      path = '/foo/bar/baz'

      expect(subject.match(path)[0]).to eq(path)
    end
  end

  describe "RELATIVE_WINDOWS_PATH" do
    subject { described_class::RELATIVE_WINDOWS_PATH }

    it "must match multiple directories" do
      path = 'foo\\.\\bar\\..\\baz'

      expect(subject.match(path)[0]).to eq(path)
    end
  end

  describe "ABSOLUTE_WINDOWS_PATH" do
    subject { described_class::ABSOLUTE_WINDOWS_PATH }

    it "must match absolute paths" do
      path = 'C:\\foo\\bar\\baz'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "must match trailing '/' characters" do
      path = 'C:\\foo\\bar\\baz\\'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "must not match relative directories" do
      path = 'C:\\foo\\.\\bar\\..\\baz'

      expect(subject.match(path)[0]).to eq('C:\\foo\\')
    end
  end

  describe "WINDOWS_PATH" do
    subject { described_class::WINDOWS_PATH }

    it "must match relative paths" do
      path = 'foo\\.\\bar\\..\\baz'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "must match absolute paths" do
      path = 'C:\\foo\\bar\\baz'

      expect(subject.match(path)[0]).to eq(path)
    end
  end

  describe "RELATIVE_PATH" do
    subject { described_class::RELATIVE_PATH }

    it "must match relative UNIX paths" do
      path = 'foo/./bar/../baz'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "must match relative Windows paths" do
      path = 'foo\\.\\bar\\..\\baz'

      expect(subject.match(path)[0]).to eq(path)
    end
  end

  describe "ABSOLUTE_PATH" do
    subject { described_class::ABSOLUTE_PATH }

    it "must match absolute UNIX paths" do
      path = '/foo/bar/baz'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "must match absolute Windows paths" do
      path = 'C:\\foo\\bar\\baz'

      expect(subject.match(path)[0]).to eq(path)
    end
  end

  describe "PATH" do
    subject { described_class::PATH }

    it "must match relative UNIX paths" do
      path = 'foo/./bar/../baz'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "must match absolute UNIX paths" do
      path = '/foo/bar/baz'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "must match relative Windows paths" do
      path = 'foo\\.\\bar\\..\\baz'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "must match absolute Windows paths" do
      path = 'C:\\foo\\bar\\baz'

      expect(subject.match(path)[0]).to eq(path)
    end
  end
end
