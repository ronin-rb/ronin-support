require 'spec_helper'
require 'ronin/support/network/ssl/local_cert'

require 'tmpdir'

describe Ronin::Support::Network::SSL::LocalCert do
  describe "PATH" do
    subject { described_class::PATH }

    it "must equal '~/.local/share/ronin/ronin-support/ssl.crt'" do
      expect(subject).to eq(File.expand_path('~/.local/share/ronin/ronin-support/ssl.crt'))
    end
  end

  let(:fixtures_dir) { File.join(__dir__,'..','fixtures') }
  let(:key_path)     { File.join(fixtures_dir,'ssl.key') }
  let(:key)          { Ronin::Support::Crypto::Key::RSA.load_file(key_path) }
  let(:cert_path)    { File.join(fixtures_dir,'ssl.crt') }
  let(:cert)         { Ronin::Support::Crypto::Key::RSA.load_file(cert_path) }

  context do
    let(:tempdir) { Dir.mktmpdir('ronin-support') }

    before(:each) do
      stub_const("#{described_class}::PATH",File.join(tempdir,'ssl.crt'))
    end

    describe ".generate" do
      let(:tempdir) { Dir.mktmpdir('ronin-support') }

      it "must return a new Ronin::Support::Crypto::Cert" do
        expect(subject.generate).to be_kind_of(Ronin::Support::Crypto::Cert)
      end

      it "must write the new certificate to PATH" do
        cert = subject.generate

        expect(File.read(described_class::PATH)).to eq(cert.to_s)
      end

      it "must set the file permission to 0644" do
        subject.generate

        stat = File.stat(described_class::PATH)

        expect(stat.mode & 07777).to eq(0644)
      end

      describe "the certificate" do
        subject { super().generate }

        it "must set command_name to 'localhost'" do
          expect(subject.subject.common_name).to eq('localhost')
        end

        it "must set organization to 'ronin-rb'" do
          expect(subject.subject.organization).to eq('ronin-rb')
        end

        it "must set organizational unit to 'ronin-support'" do
          expect(subject.subject.organizational_unit).to eq('ronin-support')
        end

        describe "subjectAltName" do
          subject { super().subject_alt_names }

          it "must include 'localhost'" do
            expect(subject).to include('localhost')
          end

          it "must include the local IP addresses" do
            local_ips = subject[1..].map do |address|
              Ronin::Support::Network::IP.new(address)
            end

            expect(local_ips).to eq(Ronin::Support::Network::IP.local_ips)
          end
        end
      end
    end

    describe ".load" do
      before(:each) do
        stub_const("#{described_class}::PATH",cert_path)
      end

      it "must load the certificate from PATH" do
        expect(subject.load.to_s).to eq(File.read(cert_path))
      end
    end

    describe ".fetch" do
      context "when ~/.local/share/ronin/ronin-support/ssl.crt exists" do
        before(:each) do
          stub_const("#{described_class}::PATH",cert_path)
        end

        it "must call .load" do
          expect(subject).to receive(:load)

          subject.fetch
        end
      end

      context "when ~/.local/share/ronin/ronin-support/ssl.crt does not exist" do
        let(:tempdir) { Dir.mktmpdir('ronin-support') }

        before(:each) do
          stub_const("#{described_class}::PATH",File.join(tempdir,'ssl.crt'))
        end

        it "must call .generate" do
          expect(subject).to receive(:generate)

          subject.fetch
        end
      end
    end
  end
end
