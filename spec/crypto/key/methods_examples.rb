require 'rspec'
require 'tempfile'

shared_examples_for "Ronin::Support::Crypto::Key::Methods examples" do
  let(:key_type) { described_class.name.split('::').last.downcase }
  let(:pem_file) { File.join(__dir__,"#{key_type}.pem") }
  let(:der_file) { File.join(__dir__,"#{key_type}.der") }
  let(:pem)      { File.read(pem_file) } 
  let(:der)      { File.binread(der_file) }

  let(:password) { "secret" }
  let(:encrypted_pem_file) { File.join(__dir__,"#{key_type}_encrypted.pem") }
  let(:encrypted_pem)      { File.read(encrypted_pem_file) }

  describe ".parse" do
    subject { described_class }

    it "must parse a PEM encoded RSA key" do
      expect(subject.parse(pem).to_pem).to eq(pem)
    end

    context "when the key is encrypted" do
      context "and the password: keyword argument is given" do
        it "must decrypt the key" do
          key = subject.parse(encrypted_pem, password: password)

          expect(key.to_pem).to eq(pem)
        end
      end
    end
  end

  describe ".load" do
    subject { described_class }

    it "must parse a PEM encoded RSA key" do
      key = subject.load(pem)

      expect(key.to_pem).to eq(pem)
    end

    context "when the key is encrypted" do
      context "and the password: keyword argument is given" do
        it "must decrypt the key" do
          key = subject.load(encrypted_pem, password: password)

          expect(key.to_pem).to eq(pem)
        end
      end
    end
  end

  describe ".load_file" do
    subject { described_class }

    it "must read and parse the path to the key file" do
      key = subject.load_file(pem_file)

      expect(key.to_pem).to eq(pem)
    end

    context "when the key is encrypted" do
      context "and the password: keyword argument is given" do
        it "must decrypt the key" do
          key = subject.load_file(encrypted_pem_file, password: password)

          expect(key.to_pem).to eq(pem)
        end
      end
    end
  end

  describe "#save" do
    let(:tempfile)  { Tempfile.new('ronin-support') }
    let(:save_path) { tempfile.path }

    context "when no keyword arguments are given" do
      before { subject.save(save_path) }

      it "must write the exported key to the given path" do
        expect(File.read(save_path)).to eq(pem)
      end
    end

    context "when the encoding: :der keyword argument is given" do
      before { subject.save(save_path, encoding: :der) }

      it "must exported the key in DER encoding" do
        expect(File.binread(save_path)).to eq(der)
      end
    end

    context "when the encoding: keyword argument is neither :pem or :der" do
      let(:encoding) { :foo }

      it do
        expect {
          subject.save(save_path, encoding: encoding)
        }.to raise_error(ArgumentError,"encoding: keyword argument (#{encoding.inspect}) must be either :pem or :der")
      end
    end

    context "when the password: keyword argument is given" do
      let(:password) { 'secret' }

      before { subject.save(save_path, password: password) }

      it "must encrypt the key with AES-256-CBC and the password" do
        key = described_class.load_file(save_path, password: password)

        expect(key.to_pem).to eq(pem)
      end
    end

    context "and when the password: and cipher: keyword arguments are given" do
      let(:cipher)   { 'aes-128-cbc' }
      let(:password) { 'secret' }

      before { subject.save(save_path, cipher: cipher, password: password) }

      it "must use the custom cipher algorithm to encrypt the key file" do
        expect(File.read(save_path)).to include("DEK-Info: #{cipher.upcase},")
      end
    end
  end
end
