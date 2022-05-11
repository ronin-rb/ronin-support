require 'rspec'
require 'tempfile'

shared_examples_for "Ronin::Support::Crypto::Key::Methods examples" do
  describe ".parse" do
    subject { described_class }

    it "must parse a PEM encoded RSA key" do
      expect(subject.parse(pem).to_pem).to eq(pem)
    end
  end

  describe ".load" do
    subject { described_class }

    it "must parse a PEM encoded RSA key" do
      expect(subject.load(pem).to_pem).to eq(pem)
    end
  end

  describe ".load_file" do
    subject { described_class }

    it "must read and parse the path to the key file" do
      expect(subject.load_file(path).to_pem).to eq(pem)
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
