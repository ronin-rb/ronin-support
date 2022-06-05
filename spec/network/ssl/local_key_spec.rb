require 'spec_helper'
require 'ronin/support/network/ssl/local_key'

require 'tmpdir'

describe Ronin::Support::Network::SSL::LocalKey do
  describe "PATH" do
    subject { described_class::PATH }

    it "must equal '~/.local/share/ronin/ronin-support/ssl.key'" do
      expect(subject).to eq(File.expand_path('~/.local/share/ronin/ronin-support/ssl.key'))
    end
  end

  let(:fixtures_dir) { File.join(__dir__,'..','fixtures') }
  let(:key_path)     { File.join(fixtures_dir,'ssl.key')  }
  let(:key)          { Ronin::Support::Crypto::Key::RSA.load_file(key_path) }

  describe ".generate" do
    let(:tempdir) { Dir.mktmpdir('ronin-support') }

    before(:each) do
      stub_const("#{described_class}::PATH",File.join(tempdir,'ssl.key'))

      allow(Ronin::Support::Crypto::Key::RSA).to receive(:generate).and_return(key)
    end

    it "must return a new Ronin::Support::Crypto::Key::RSA" do
      expect(subject.generate).to eq(key)
    end

    it "must write the new RSA key to PATH" do
      subject.generate

      expect(File.read(described_class::PATH)).to eq(key.to_s)
    end

    it "must set the file permission to 0640" do
      subject.generate

      stat = File.stat(described_class::PATH)

      expect(stat.mode & 07777).to eq(0640)
    end
  end

  describe ".load" do
    before(:each) do
      stub_const("#{described_class}::PATH",key_path)
    end

    it "must load the RSA key from PATH" do
      expect(subject.load.to_s).to eq(key.to_s)
    end
  end

  describe ".fetch" do
    context "when ~/.local/share/ronin/ronin-support/ssl.key exists" do
      before(:each) do
        stub_const("#{described_class}::PATH",key_path)
      end

      it "must call .load" do
        expect(subject).to receive(:load)

        subject.fetch
      end
    end

    context "when ~/.local/share/ronin/ronin-support/ssl.key does not exist" do
      let(:tempdir) { Dir.mktmpdir('ronin-support') }

      before(:each) do
        stub_const("#{described_class}::PATH",File.join(tempdir,'ssl.key'))
      end

      it "must call .generate" do
        expect(subject).to receive(:generate)

        subject.fetch
      end
    end
  end
end
