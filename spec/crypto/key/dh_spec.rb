require 'spec_helper'
require 'ronin/support/crypto/key/dh'

describe Ronin::Support::Crypto::Key::DH do
  let(:fixtures_dir) { File.join(__dir__,'..','fixtures') }

  let(:path) { File.join(fixtures_dir,'dh.key') }
  let(:der)  { File.binread(path) }

  if RUBY_ENGINE == 'jruby'
    describe ".generate" do
      let(:key_size) { 1024 }

      subject { described_class }

      it "must call .new with the key size" do
        expect(subject).to receive(:new).with(key_size)

        subject.generate(key_size)
      end

      context "and when a generator number is given" do
        let(:generator) { 2 }

        it "must call .generate with the given key size and generator" do
          expect(subject).to receive(:new).with(key_size,generator)

          subject.generate(key_size,generator)
        end
      end
    end
  end

  describe ".random" do
    subject { described_class }

    it "must call .generate with a key size of 1024" do
      expect(subject).to receive(:generate).with(1024).and_return(der)

      expect(subject.random).to be_kind_of(subject)
    end

    context "when given a key size" do
      let(:key_size) { 2048 }

      it "must call .generate with the given key size" do
        expect(subject).to receive(:generate).with(key_size).and_return(der)

        expect(subject.random(key_size)).to be_kind_of(subject)
      end

      context "and when a generator number is given" do
        let(:generator) { 2 }

        it "must call .generate with the given key size and generator" do
          expect(subject).to receive(:generate).with(key_size,generator).and_return(der)

          expect(subject.random(key_size, generator: generator)).to be_kind_of(subject)
        end
      end
    end
  end

  describe ".parse" do
    subject { described_class }

    it "must parse a DER encoded DH key" do
      expect(subject.parse(der).to_der).to eq(der)
    end
  end

  describe ".load_file" do
    subject { described_class }

    it "must read and parse the path to the key file" do
      expect(subject.load_file(path).to_der).to eq(der)
    end
  end

  subject { described_class.load_file(path) }

  describe "#p" do
    it "must return the 'p' value" do
      expect(subject.p).to be_kind_of(OpenSSL::BN)
    end
  end

  describe "#q" do
    it "must return the 'q' value" do
      expect(subject.q).to be_kind_of(OpenSSL::BN).or(be(nil))
    end
  end

  describe "#g" do
    it "must return the 'g' value" do
      expect(subject.g).to be_kind_of(OpenSSL::BN)
    end
  end

  describe "#size" do
    it "must return the bit size of the 'p' variable" do
      expect(subject.size).to eq(subject.p.num_bits)
    end
  end
end
