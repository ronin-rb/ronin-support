require 'spec_helper'
require 'ronin/support/network/defang/mixin'

describe Ronin::Support::Network::Defang::Mixin do
  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  describe "#defang_ip" do
    context "when given an IPv4 address" do
      let(:ip)       { '192.168.1.1' }
      let(:defanged) { '192[.]168[.]1[.]1' }

      it "must escape the '.' separators" do
        expect(subject.defang_ip(ip)).to eq(defanged)
      end
    end

    context "when given an IPv6 address" do
      let(:ip)       { '2606:2800:21f:cb07:6820:80da:af6b:8b2c' }
      let(:defanged) { '2606[:]2800[:]21f[:]cb07[:]6820[:]80da[:]af6b[:]8b2c' }

      it "must escape the ':' separators" do
        expect(subject.defang_ip(ip)).to eq(defanged)
      end

      context "and when the IPv6 address contains a '::' separator" do
        let(:ip)       { 'ffff:abcd::12' }
        let(:defanged) { 'ffff[:]abcd[::]12' }

        it "must also escape the '::' separator as '[::]'" do
          expect(subject.defang_ip(ip)).to eq(defanged)
        end
      end
    end
  end

  describe "#refang_ip" do
    context "when given a defanged IPv4 address" do
      let(:defanged) { '192[.]168[.]1[.]1' }
      let(:ip)       { '192.168.1.1' }

      it "must unescape the '[.]' separators" do
        expect(subject.refang_ip(defanged)).to eq(ip)
      end
    end

    context "when given a defanged IPv6 address" do
      let(:defanged) { '2606[:]2800[:]21f[:]cb07[:]6820[:]80da[:]af6b[:]8b2c' }
      let(:ip)       { '2606:2800:21f:cb07:6820:80da:af6b:8b2c' }

      it "must unescape the '[:]' separators" do
        expect(subject.refang_ip(defanged)).to eq(ip)
      end

      context "and when the IPv6 address contains an escaped '[::]' separator" do
        let(:defanged) { 'ffff[:]abcd[::]12' }
        let(:ip)       { 'ffff:abcd::12' }

        it "must also unescape the '[::]' separator" do
          expect(subject.refang_ip(defanged)).to eq(ip)
        end
      end
    end
  end

  describe "#defang_host" do
    let(:host)     { 'www.example.com' }
    let(:defanged) { 'www[.]example[.]com' }

    it "must escape the '.' separators" do
      expect(subject.defang_host(host)).to eq(defanged)
    end
  end

  describe "#refang_host" do
    let(:defanged) { 'www[.]example[.]com' }
    let(:host)     { 'www.example.com' }

    it "must unescape the '[.]' separators" do
      expect(subject.refang_host(defanged)).to eq(host)
    end
  end

  describe "#defang_url" do
    context "when the URL starts with 'http://'" do
      let(:url)      { 'http://www.example.com/foo?q=1' }
      let(:defanged) { 'hxxp[://]www[.]example[.]com/foo?q=1' }

      it "must replace `http://` with 'hxxp[://]'" do
        expect(subject.defang_url(url)).to eq(defanged)
      end
    end

    context "when the URL starts with 'https://'" do
      let(:url)      { 'https://www.example.com/foo?q=1' }
      let(:defanged) { 'hxxps[://]www[.]example[.]com/foo?q=1' }

      it "must replace `https://` with 'hxxps[://]'" do
        expect(subject.defang_url(url)).to eq(defanged)
      end
    end

    context "when the URL contains a host name" do
      let(:url)      { 'https://www.example.com/foo?q=1' }
      let(:defanged) { 'hxxps[://]www[.]example[.]com/foo?q=1' }

      it "must escape the '.' separators in the host name" do
        expect(subject.defang_url(url)).to eq(defanged)
      end
    end

    context "when the URL contains an IPv4 address" do
      let(:url)      { 'https://192.168.1.1/foo?q=1' }
      let(:defanged) { 'hxxps[://]192[.]168[.]1[.]1/foo?q=1' }

      it "must escape the '.' separators in the IPv4 address" do
        expect(subject.defang_url(url)).to eq(defanged)
      end
    end

    context "when the URL contains an IPv6 address" do
      let(:url)      { "https://2606:2800:21f:cb07:6820:80da:af6b:8b2c/foo?q=1" }
      let(:defanged) { 'hxxps[://]2606[:]2800[:]21f[:]cb07[:]6820[:]80da[:]af6b[:]8b2c/foo?q=1' }

      it "must escape the ':' separators in the IPv6 address" do
        expect(subject.defang_url(url)).to eq(defanged)
      end

      context "and the IPv6 address also contains a '::' separator" do
        let(:url)      { "https://ffff:abcd::12/foo?q=1" }
        let(:defanged) { 'hxxps[://]ffff[:]abcd[::]12/foo?q=1' }

        it "must also escape the '::' separator as '[::]'" do
          expect(subject.defang_url(url)).to eq(defanged)
        end
      end
    end
  end

  describe "#refang_url" do
    context "when the URL starts with 'hxxp[://]'" do
      let(:defanged) { 'hxxp[://]www[.]example[.]com/foo?q=1' }
      let(:url)      { 'http://www.example.com/foo?q=1' }

      it "must replace 'hxxp[://]' with 'httw[://]'" do
        expect(subject.refang_url(defanged)).to eq(url)
      end
    end

    context "when the URL starts with 'hxxps[://]'" do
      let(:defanged) { 'hxxps[://]www[.]example[.]com/foo?q=1' }
      let(:url)      { 'https://www.example.com/foo?q=1' }

      it "must replace `hxxps[://]` with 'https://'" do
        expect(subject.refang_url(defanged)).to eq(url)
      end
    end

    context "when the URL contains a host name" do
      let(:defanged) { 'hxxps[://]www[.]example[.]com/foo?q=1' }
      let(:url)      { 'https://www.example.com/foo?q=1' }

      it "must unescape the '[.]' separators in the host name" do
        expect(subject.refang_url(defanged)).to eq(url)
      end
    end

    context "when the URL contains an IPv4 address" do
      let(:defanged) { 'hxxps[://]192[.]168[.]1[.]1/foo?q=1' }
      let(:url)      { 'https://192.168.1.1/foo?q=1' }

      it "must unescape the '[.]' separators in the IPv4 address" do
        expect(subject.refang_url(defanged)).to eq(url)
      end
    end

    context "when the URL contains an IPv6 address" do
      let(:defanged) { 'hxxps[://]2606[:]2800[:]21f[:]cb07[:]6820[:]80da[:]af6b[:]8b2c/foo?q=1' }
      let(:url)      { "https://2606:2800:21f:cb07:6820:80da:af6b:8b2c/foo?q=1" }

      it "must unescape the '[:]' separators in the IPv6 address" do
        expect(subject.refang_url(defanged)).to eq(url)
      end

      context "and the IPv6 address also contains a '[::]' separator" do
        let(:defanged) { 'hxxps[://]ffff[:]abcd[::]12/foo?q=1' }
        let(:url)      { "https://ffff:abcd::12/foo?q=1" }

        it "must also unescape the '[::]' separator as '::'" do
          expect(subject.refang_url(defanged)).to eq(url)
        end
      end
    end
  end

  describe "#defang" do
    context "when given a defanged URL" do
      let(:url)      { 'http://www.example.com/foo?q=1' }
      let(:defanged) { 'hxxp[://]www[.]example[.]com/foo?q=1' }

      it "must return the defanged URL" do
        expect(subject.defang(url)).to eq(defanged)
      end
    end

    context "when given a defanged IPv4 address" do
      let(:ip)       { '192.168.1.1' }
      let(:defanged) { '192[.]168[.]1[.]1' }

      it "must return the defanged IPv4 address" do
        expect(subject.defang(ip)).to eq(defanged)
      end
    end

    context "when given a defanged IPv6 address" do
      let(:ip)       { '2606:2800:21f:cb07:6820:80da:af6b:8b2c' }
      let(:defanged) { '2606[:]2800[:]21f[:]cb07[:]6820[:]80da[:]af6b[:]8b2c' }

      it "must return the defanged IPv6 address" do
        expect(subject.defang(ip)).to eq(defanged)
      end
    end

    context "when given a defanged host name" do
      let(:host)     { 'www.example.com' }
      let(:defanged) { 'www[.]example[.]com' }

      it "must return the defanged host name" do
        expect(subject.defang(host)).to eq(defanged)
      end
    end
  end

  describe "#refang" do
    context "when given a defanged URL" do
      let(:defanged) { 'hxxp[://]www[.]example[.]com/foo?q=1' }
      let(:url)      { 'http://www.example.com/foo?q=1' }

      it "must return the refanged URL" do
        expect(subject.refang(defanged)).to eq(url)
      end
    end

    context "when given a defanged IPv4 address" do
      let(:defanged) { '192[.]168[.]1[.]1' }
      let(:ip)       { '192.168.1.1' }

      it "must return the refanged IPv4 address" do
        expect(subject.refang(defanged)).to eq(ip)
      end
    end

    context "when given a defanged IPv6 address" do
      let(:defanged) { '2606[:]2800[:]21f[:]cb07[:]6820[:]80da[:]af6b[:]8b2c' }
      let(:ip)       { '2606:2800:21f:cb07:6820:80da:af6b:8b2c' }

      it "must return the refanged IPv6 address" do
        expect(subject.refang(defanged)).to eq(ip)
      end
    end

    context "when given a defanged host name" do
      let(:defanged) { 'www[.]example[.]com' }
      let(:host)     { 'www.example.com' }

      it "must return the refanged host name" do
        expect(subject.refang(defanged)).to eq(host)
      end
    end
  end
end
