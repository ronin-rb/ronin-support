require 'rspec'

shared_examples_for "Ronin::Support::Crypto::Key::ClassMethods examples" do
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
end
