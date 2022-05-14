require 'rspec'
require 'tempfile'

shared_examples_for "Ronin::Support::Crypto::Key::Methods examples" do
  let(:key_type) { described_class.name.split('::').last.downcase }
  let(:pem_file) { File.join(__dir__,"#{key_type}.pem") }
  let(:pem)      { File.read(pem_file) } 

  let(:password) { "secret" }
  let(:encrypted_pem_file) { File.join(__dir__,"#{key_type}_encrypted.pem") }
  let(:encrypted_pem)      { File.read(encrypted_pem_file) }

  describe ".parse" do
    subject { described_class }

    it "must parse a PEM encoded RSA key" do
      expect(subject.parse(pem).to_pem).to eq(pem)
    end

    context "when the key is encrypted" do
      context "and a password is given" do
        it "must decrypt the key" do
          expect(subject.parse(encrypted_pem,password).to_pem).to eq(pem)
        end
      end
    end
  end

  describe ".load" do
    subject { described_class }

    it "must parse a PEM encoded RSA key" do
      expect(subject.load(pem).to_pem).to eq(pem)
    end

    context "when the key is encrypted" do
      context "and a password is given" do
        it "must decrypt the key" do
          expect(subject.load(encrypted_pem,password).to_pem).to eq(pem)
        end
      end
    end
  end

  describe ".load_file" do
    subject { described_class }

    it "must read and parse the path to the key file" do
      expect(subject.load_file(pem_file).to_pem).to eq(pem)
    end

    context "when the key is encrypted" do
      context "and a password is given" do
        it "must decrypt the key" do
          expect(
            subject.load_file(encrypted_pem_file,password).to_pem
          ).to eq(pem)
        end
      end
    end
  end

  describe "#save" do
    let(:tempfile)  { Tempfile.new('ronin-support') }
    let(:save_path) { tempfile.path }

    before { subject.save(save_path) }

    it "must write the exported key to the given path" do
      expect(File.read(save_path)).to eq(subject.export)
    end
  end
end
