require 'spec_helper'
require 'ronin/support/crypto/key'

describe Ronin::Support::Crypto::Key do
  let(:fixtures_dir) { File.join(__dir__,'fixtures') }

  let(:rsa_pem_file) { File.join(fixtures_dir,'rsa.pem') }
  let(:rsa_pem)      { File.read(rsa_pem_file) }
  let(:rsa_key)      { described_class::RSA.load_file(rsa_pem_file) }

  let(:dsa_pem_file) { File.join(fixtures_dir,'dsa.pem') }
  let(:dsa_pem)      { File.read(dsa_pem_file) }
  let(:dsa_key)      { described_class::DSA.load_file(dsa_pem_file) }

  let(:dh_pem_file)  { File.join(fixtures_dir,'dh.pem') }
  let(:dh_pem)       { File.read(dh_pem_file) }
  let(:dh_key)       { described_class::DSA.load_file(dh_pem_file) }

  let(:ec_pem_file)  { File.join(fixtures_dir,'ec.pem') }
  let(:ec_pem)       { File.read(ec_pem_file) }
  let(:ec_key)       { described_class::EC.load_file(ec_pem_file) }

  describe ".parse" do
    context "when the key string starts with '-----BEGIN RSA PRIVATE KEY-----'" do
      subject { super().parse(rsa_pem) }

      it "must load the #{described_class}::RSA key from the parse" do
        expect(subject).to be_kind_of(described_class::RSA)
        expect(subject.to_pem).to eq(rsa_pem)
      end
    end

    context "when the key string starts with '-----BEGIN DSA PRIVATE KEY-----'" do
      subject { super().parse(dsa_pem) }

      it "must load the #{described_class}::DSA key from the string" do
        expect(subject).to be_kind_of(described_class::DSA)
        expect(subject.to_pem).to eq(dsa_pem)
      end
    end

    context "when the key string starts with '-----BEGIN DH PARAMETERS-----'" do
      subject { super().parse(dh_pem) }

      it "must load the #{described_class}::DH key from the string" do
        expect(subject).to be_kind_of(described_class::DH)
        expect(subject.to_pem).to eq(dh_pem)
      end
    end

    context "when the key string starts with '-----BEGIN EC PRIVATE KEY-----'" do
      subject { super().parse(ec_pem) }

      it "must load the #{described_class}::EC key from the string" do
        expect(subject).to be_kind_of(described_class::EC)
        expect(subject.to_pem).to eq(ec_pem)
      end
    end

    context "when the key string is DER encoded" do
      let(:der_file) { File.join(fixtures_dir,'rsa.der') }
      let(:der)      { File.binread(der_file) }

      it do
        expect {
          subject.parse(der)
        }.to raise_error(ArgumentError,"cannot determine the key type for key: #{der.inspect}")
      end
    end
  end

  describe ".load_file" do
    context "when the key file starts with '-----BEGIN RSA PRIVATE KEY-----'" do
      subject { super().load_file(rsa_pem_file) }

      it "must load the #{described_class}::RSA key from the file" do
        expect(subject).to be_kind_of(described_class::RSA)
        expect(subject.to_pem).to eq(rsa_pem)
      end
    end

    context "when the key file starts with '-----BEGIN DSA PRIVATE KEY-----'" do
      subject { super().load_file(dsa_pem_file) }

      it "must load the #{described_class}::DSA key from the file" do
        expect(subject).to be_kind_of(described_class::DSA)
        expect(subject.to_pem).to eq(dsa_pem)
      end
    end

    context "when the key file starts with '-----BEGIN DH PARAMETERS-----'" do
      subject { super().load_file(dh_pem_file) }

      it "must load the #{described_class}::DH key from the file" do
        expect(subject).to be_kind_of(described_class::DH)
        expect(subject.to_pem).to eq(dh_pem)
      end
    end

    context "when the key file starts with '-----BEGIN EC PRIVATE KEY-----'" do
      subject { super().load_file(ec_pem_file) }

      it "must load the #{described_class}::EC key from the file" do
        expect(subject).to be_kind_of(described_class::EC)
        expect(subject.to_pem).to eq(ec_pem)
      end
    end

    context "when the key file is DER encoded" do
      let(:der_file) { File.join(fixtures_dir,'rsa.der') }
      let(:der)      { File.read(der_file) }

      it do
        expect {
          subject.load_file(der_file)
        }.to raise_error(ArgumentError,"cannot determine the key type for key: #{der.inspect}")
      end
    end
  end

  describe "Key()" do
    context "when given a String" do
      context "when the key string starts with '-----BEGIN RSA PRIVATE KEY-----'" do
        subject { Ronin::Support::Crypto::Key(rsa_pem) }

        it "must load the #{described_class}::RSA key from the parse" do
          expect(subject).to be_kind_of(described_class::RSA)
          expect(subject.to_pem).to eq(rsa_pem)
        end
      end

      context "when the key string starts with '-----BEGIN DSA PRIVATE KEY-----'" do
        subject { Ronin::Support::Crypto::Key(dsa_pem) }

        it "must load the #{described_class}::DSA key from the string" do
          expect(subject).to be_kind_of(described_class::DSA)
          expect(subject.to_pem).to eq(dsa_pem)
        end
      end

      context "when the key string starts with '-----BEGIN DH PARAMETERS-----'" do
        subject { Ronin::Support::Crypto::Key(dh_pem) }

        it "must load the #{described_class}::DH key from the string" do
          expect(subject).to be_kind_of(described_class::DH)
          expect(subject.to_pem).to eq(dh_pem)
        end
      end

      context "when the key string starts with '-----BEGIN EC PRIVATE KEY-----'" do
        subject { Ronin::Support::Crypto::Key(ec_pem) }

        it "must load the #{described_class}::EC key from the string" do
          expect(subject).to be_kind_of(described_class::EC)
          expect(subject.to_pem).to eq(ec_pem)
        end
      end
    end

    context "when given a OpenSSL::PKey::RSA object" do
      let(:pkey) { OpenSSL::PKey::RSA.new(rsa_pem) }

      it "must return a #{described_class}::RSA object" do
        new_key = Ronin::Support::Crypto::Key(pkey)

        expect(new_key).to be_kind_of(described_class::RSA)
        expect(new_key.to_pem).to eq(rsa_pem)
      end
    end

    context "when given a OpenSSL::PKey::DSA object" do
      let(:pkey) { OpenSSL::PKey::DSA.new(dsa_pem) }

      it "must return a #{described_class}::DSA object" do
        new_key = Ronin::Support::Crypto::Key(pkey)

        expect(new_key).to be_kind_of(described_class::DSA)
        expect(new_key.to_pem).to eq(dsa_pem)
      end
    end

    context "when given a OpenSSL::PKey::DH object" do
      let(:pkey) { OpenSSL::PKey::DH.new(dh_pem) }

      it "must return a #{described_class}::DH object" do
        new_key = Ronin::Support::Crypto::Key(pkey)

        expect(new_key).to be_kind_of(described_class::DH)
        expect(new_key.to_s).to eq(dh_pem)
      end
    end

    context "when given a OpenSSL::PKey::EC object" do
      let(:pkey) { OpenSSL::PKey::EC.new(ec_pem) }

      it "must return a #{described_class}::EC object" do
        new_key = Ronin::Support::Crypto::Key(pkey)

        expect(new_key).to be_kind_of(described_class::EC)
        expect(new_key.to_pem).to eq(ec_pem)
      end
    end

    context "when given another kind of Object" do
      let(:object) { Object.new }

      it do
        expect {
          Ronin::Support::Crypto::Key(object)
        }.to raise_error(ArgumentError,"value must be either a String or a OpenSSL::PKey::PKey object: #{object.inspect}")
      end
    end
  end
end
