require 'spec_helper'
require 'ronin/support/crypto/key/ec'

describe Ronin::Support::Crypto::Key::EC do
  let(:fixtures_dir) { File.join(__dir__,'..','fixtures') }

  let(:path) { File.join(fixtures_dir,'ec.pem') }
  let(:pem)  { File.read(path) }

  describe ".supported_curves" do
    subject { described_class }

    it do
      expect(subject.supported_curves).to_not be_empty
      expect(subject.supported_curves).to all(be_kind_of(String))
    end
  end

  describe ".generate" do
    subject { described_class }

    it "must return a new #{described_class} instance" do
      expect(subject.superclass).to receive(:generate).with('prime256v1').and_return(described_class.new)

      expect(subject.generate).to be_kind_of(described_class)
    end

    context "when given a specific curve" do
      let(:curve) { 'secp224r1' }

      it "must generate a new #{described_class} using that curve" do
        expect(subject.superclass).to receive(:generate).with(curve).and_return(described_class.new)

        expect(subject.generate(curve)).to be_kind_of(described_class)
      end
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

  describe "#curve" do
    it "must return the #group #curve_name String" do
      expect(subject.curve).to eq(subject.group.curve_name)
    end
  end
end
