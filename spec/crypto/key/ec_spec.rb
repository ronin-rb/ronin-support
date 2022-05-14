require 'spec_helper'
require 'ronin/support/crypto/key/ec'

describe Ronin::Support::Crypto::Key::EC do
  let(:path) { File.join(__dir__,'ec.pem') }
  let(:pem)  { File.read(path) }

  describe ".supported_curves" do
    subject { described_class }

    it do
      expect(subject.supported_curves).to_not be_empty
      expect(subject.supported_curves).to all(be_kind_of(String))
    end
  end

  describe ".random" do
    subject { described_class }

    let(:curve) { 'prime256v1' }

    it "must call .generate with the curve name and then call .generate_key" do
      new_key = subject.random(curve)

      expect(new_key).to be_kind_of(described_class)
      expect(new_key.public_key).to be_kind_of(OpenSSL::PKey::EC::Point)
      expect(new_key.private_key).to be_kind_of(OpenSSL::BN)
    end
  end

  describe ".parse" do
    subject { described_class }

    it "must parse a PEM encoded EC key" do
      if RUBY_ENGINE == 'jruby'
        skip "https://github.com/jruby/jruby-openssl/issues/257"
      end

      expect(subject.parse(pem).to_pem).to eq(pem)
    end
  end

  describe ".load_file" do
    subject { described_class }

    it "must read and parse the path to the key file" do
      if RUBY_ENGINE == 'jruby'
        skip "https://github.com/jruby/jruby-openssl/issues/257"
      end

      expect(subject.load_file(path).to_pem).to eq(pem)
    end
  end

  subject { described_class.load_file(path) }
end
