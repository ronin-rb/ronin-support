require 'spec_helper'
require 'ronin/support/crypto/key/rsa'

require 'tempfile'

describe Ronin::Support::Crypto::Key::RSA do
  describe ".random" do
    subject { described_class }

    it "must generate a new random RSA key" do
      new_key = subject.random

      expect(new_key).to be_kind_of(described_class)
      expect(new_key).to_not eq(subject.random)
    end
  end

  describe ".parse" do
    subject { described_class }

    let(:key) { subject.random }
    let(:pem) { key.to_pem }

    it "must parse a PEM encoded RSA key" do
      parsed_key = subject.parse(pem)

      expect(parsed_key.n).to eq(key.n)
      expect(parsed_key.d).to eq(key.d)
      expect(parsed_key.e).to eq(key.e)
    end
  end

  describe ".open" do
    subject { described_class }

    let(:key) { subject.random }
    let(:pem) { key.to_pem }

    let(:tempfile) { Tempfile.new('ronin-support') }

    before do
      tempfile.write(pem)
      tempfile.flush
    end

    it "must read and parse the path to the key file" do
      parsed_key = subject.open(tempfile.path)

      expect(parsed_key.n).to eq(key.n)
      expect(parsed_key.d).to eq(key.d)
      expect(parsed_key.e).to eq(key.e)
    end
  end

  subject { described_class.random }

  describe "#n" do
    it "must return the 'n' value" do
      expect(subject.n).to be_kind_of(OpenSSL::BN)
    end
  end

  describe "#e" do
    it "must return the 'e' value" do
      expect(subject.e).to be_kind_of(OpenSSL::BN)
    end
  end

  describe "#d" do
    it "must return the 'd' value" do
      expect(subject.d).to be_kind_of(OpenSSL::BN)
    end
  end
end
