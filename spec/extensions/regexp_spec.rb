require 'spec_helper'
require 'ronin/extensions/regexp'

describe Regexp do
  describe "OCTET" do
    subject { Regexp::OCTET }

    it "should match 0 - 255" do
      (0..255).all? { |n|
        subject.match(n.to_s)[0] == n.to_s
      }.should be_true
    end

    it "should not match numbers greater than 255" do
      subject.match('256')[0].should == '25'
    end
  end

  describe "MAC" do
    subject { Regexp::MAC }

    it "should match six hexadecimal bytes" do
      mac = '12:34:56:78:9a:bc'

      subject.match(mac)[0].should == mac
    end
  end

  describe "IPv4" do
    subject { Regexp::IPv4 }

    it "should match valid addresses" do
      ip = '127.0.0.1'

      subject.match(ip)[0].should == ip
    end

    it "should match the Any address" do
      ip = '0.0.0.0'

      subject.match(ip)[0].should == ip
    end

    it "should match the broadcast address" do
      ip = '255.255.255.255'

      subject.match(ip)[0].should == ip
    end

    it "should match addresses with netmasks" do
      ip = '10.1.1.1/24'

      subject.match(ip)[0].should == ip
    end

    it "should not match addresses with octets > 255" do
      ip = '10.1.256.1'

      subject.match(ip).should be_nil
    end

    it "should not match addresses with more than three digits per octet" do
      ip = '10.1111.1.1'

      subject.match(ip).should be_nil
    end
  end

  describe "IPv6" do
    subject { Regexp::IPv6 }

    it "should match valid IPv6 addresses" do
      ip = '2001:db8:85a3:0:0:8a2e:370:7334'

      subject.match(ip)[0].should == ip
    end

    it "should match IPv6 addresses with netmasks" do
      ip = '2001:db8:1234::/48'

      subject.match(ip)[0].should == ip
    end

    it "should match truncated IPv6 addresses" do
      ip = '2001:db8:85a3::8a2e:370:7334'

      subject.match(ip)[0].should == ip
    end

    it "should match IPv4-mapped IPv6 addresses" do
      ip = '::ffff:192.0.2.128'

      subject.match(ip)[0].should == ip
    end
  end

  describe "IP" do
    subject { Regexp::IP }

    it "should match IPv4 addresses" do
      ip = '10.1.1.1'

      subject.match(ip)[0].should == ip
    end

    it "should match IPv6 addresses" do
      ip = '2001:db8:85a3:0:0:8a2e:370:7334'

      subject.match(ip)[0].should == ip
    end
  end

  describe "HOST_NAME" do
    subject { Regexp::HOST_NAME }

    it "should match valid hostnames" do
      hostname = 'www.google.com'

      subject.match(hostname)[0].should == hostname
    end

    it "should not match hostnames without a TLD" do
      subject.match('foo').should be_nil
    end

    it "should not match hostnames with unknown TLDs" do
      subject.match('foo.zzz').should be_nil
    end
  end

  describe "USER_NAME" do
    subject { Regexp::USER_NAME }

    it "should match valid user-names" do
      username = 'alice1234'

      subject.match(username)[0].should == username
    end

    it "should match user-names containing '_' characters" do
      username = 'alice_1234'

      subject.match(username)[0].should == username
    end

    it "should match user-names containing '.' characters" do
      username = 'alice.1234'

      subject.match(username)[0].should == username
    end

    it "should not match user-names beginning with numbers" do
      subject.match('1234bob')[0].should == 'bob'
    end

    it "should not match user-names containing spaces" do
      subject.match('alice eve')[0].should == 'alice'
    end

    it "should not match user-names containing other symbols" do
      subject.match('alice^eve')[0].should == 'alice'
    end
  end

  describe "EMAIL_ADDR" do
    subject { Regexp::EMAIL_ADDR }

    it "should match valid email addresses" do
      email = 'alice@example.com'

      subject.match(email)[0].should == email
    end
  end

  describe "IDENTIFIER" do
    subject { Regexp::IDENTIFIER }

    it "should match Strings beginning with a '_' character" do
      identifier = '_foo'

      subject.match(identifier)[0].should == identifier
    end

    it "should match Strings ending with a '_' character" do
      identifier = 'foo_'

      subject.match(identifier)[0].should == identifier
    end

    it "should not match Strings beginning with numberic characters" do
      subject.match('1234foo')[0].should == 'foo'
    end

    it "should not match Strings not containing any alpha characters" do
      identifier = '_1234_'

      subject.match(identifier).should be_nil
    end
  end

  describe "FILE_EXT" do
    subject { Regexp::FILE_EXT }

    it "should match the '.' separator character" do
      ext = '.txt'

      subject.match(ext)[0].should == ext
    end

    it "should not allow '_' characters" do
      subject.match('.foo_bar')[0].should == '.foo'
    end

    it "should not allow '-' characters" do
      subject.match('.foo-bar')[0].should == '.foo'
    end
  end

  describe "FILE_NAME" do
    subject { Regexp::FILE_NAME }

    it "should match file names" do
      filename = 'foo_bar'

      subject.match(filename)[0].should == filename
    end

    it "should match '\\' escapped characters" do
      filename = 'foo\\ bar'

      subject.match(filename)[0].should == filename
    end
  end

  describe "FILE" do
    subject { Regexp::FILE }

    it "should match the filename and extension" do
      filename = 'foo_bar.txt'

      subject.match(filename)[0].should == filename
    end
  end

  describe "DIRECTORY" do
    subject { Regexp::DIRECTORY }

    it "should match directory names" do
      dir = 'foo_bar'

      subject.match(dir)[0].should == dir
    end

    it "should match '.'" do
      dir = '.'

      subject.match(dir)[0].should == dir
    end

    it "should match '..'" do
      dir = '..'

      subject.match(dir)[0].should == dir
    end
  end

  describe "RELATIVE_UNIX_PATH" do
    subject { Regexp::RELATIVE_UNIX_PATH }

    it "should match multiple directories" do
      path = 'foo/./bar/../baz'

      subject.match(path)[0].should == path
    end
  end

  describe "ABSOLUTE_UNIX_PATH" do
    subject { Regexp::ABSOLUTE_UNIX_PATH }

    it "should match absolute paths" do
      path = '/foo/bar/baz'

      subject.match(path)[0].should == path
    end

    it "should match trailing '/' characters" do
      path = '/foo/bar/baz/'

      subject.match(path)[0].should == path
    end

    it "should not match relative directories" do
      path = '/foo/./bar/../baz'

      subject.match(path)[0].should == '/foo/'
    end
  end

  describe "UNIX_PATH" do
    subject { Regexp::UNIX_PATH }

    it "should match relative paths" do
      path = 'foo/./bar/../baz'

      subject.match(path)[0].should == path
    end

    it "should match absolute paths" do
      path = '/foo/bar/baz'

      subject.match(path)[0].should == path
    end
  end

  describe "RELATIVE_WINDOWS_PATH" do
    subject { Regexp::RELATIVE_WINDOWS_PATH }

    it "should match multiple directories" do
      path = 'foo\\.\\bar\\..\\baz'

      subject.match(path)[0].should == path
    end
  end

  describe "ABSOLUTE_WINDOWS_PATH" do
    subject { Regexp::ABSOLUTE_WINDOWS_PATH }

    it "should match absolute paths" do
      path = 'C:\\foo\\bar\\baz'

      subject.match(path)[0].should == path
    end

    it "should match trailing '/' characters" do
      path = 'C:\\foo\\bar\\baz\\'

      subject.match(path)[0].should == path
    end

    it "should not match relative directories" do
      path = 'C:\\foo\\.\\bar\\..\\baz'

      subject.match(path)[0].should == 'C:\\foo\\'
    end
  end

  describe "WINDOWS_PATH" do
    subject { Regexp::WINDOWS_PATH }

    it "should match relative paths" do
      path = 'foo\\.\\bar\\..\\baz'

      subject.match(path)[0].should == path
    end

    it "should match absolute paths" do
      path = 'C:\\foo\\bar\\baz'

      subject.match(path)[0].should == path
    end
  end

  describe "RELATIVE_PATH" do
    subject { Regexp::RELATIVE_PATH }

    it "should match relative UNIX paths" do
      path = 'foo/./bar/../baz'

      subject.match(path)[0].should == path
    end

    it "should match relative Windows paths" do
      path = 'foo\\.\\bar\\..\\baz'

      subject.match(path)[0].should == path
    end
  end

  describe "ABSOLUTE_PATH" do
    subject { Regexp::ABSOLUTE_PATH }

    it "should match absolute UNIX paths" do
      path = '/foo/bar/baz'

      subject.match(path)[0].should == path
    end

    it "should match absolute Windows paths" do
      path = 'C:\\foo\\bar\\baz'

      subject.match(path)[0].should == path
    end
  end

  describe "PATH" do
    subject { Regexp::PATH }

    it "should match relative UNIX paths" do
      path = 'foo/./bar/../baz'

      subject.match(path)[0].should == path
    end

    it "should match absolute UNIX paths" do
      path = '/foo/bar/baz'

      subject.match(path)[0].should == path
    end

    it "should match relative Windows paths" do
      path = 'foo\\.\\bar\\..\\baz'

      subject.match(path)[0].should == path
    end

    it "should match absolute Windows paths" do
      path = 'C:\\foo\\bar\\baz'

      subject.match(path)[0].should == path
    end
  end
end
