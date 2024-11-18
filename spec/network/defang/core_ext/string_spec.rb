require 'spec_helper'
require 'ronin/support/network/defang/core_ext/string'

describe String do
  describe "#refang" do
    context "when the String is a defanged URL" do
      subject { 'hxxp[://]www[.]example[.]com/foo?q=1' }

      let(:url) { 'http://www.example.com/foo?q=1' }

      it "must return the refanged URL" do
        expect(subject.refang).to eq(url)
      end
    end

    context "when the String is a defanged IPv4 address" do
      subject { '192[.]168[.]1[.]1' }

      let(:ip) { '192.168.1.1' }

      it "must return the refanged IPv4 address" do
        expect(subject.refang).to eq(ip)
      end
    end

    context "when the String is a defanged IPv6 address" do
      subject { '2606[:]2800[:]21f[:]cb07[:]6820[:]80da[:]af6b[:]8b2c' }

      let(:ip) { '2606:2800:21f:cb07:6820:80da:af6b:8b2c' }

      it "must return the refanged IPv6 address" do
        expect(subject.refang).to eq(ip)
      end
    end

    context "when the String is a defanged host name" do
      subject { 'www[.]example[.]com' }

      let(:host) { 'www.example.com' }

      it "must return the refanged host name" do
        expect(subject.refang).to eq(host)
      end
    end
  end
end
