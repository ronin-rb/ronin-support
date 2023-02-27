require 'spec_helper'
require 'ronin/support/network/asn/list'

require 'fileutils'
require 'tempfile'
require 'tmpdir'
require 'webmock'

describe Ronin::Support::Network::ASN::List do
  let(:fixtures_dir) { File.join(__dir__,'fixtures')         }
  let(:list_file)    { File.join(fixtures_dir,'list.tsv')    }
  let(:records)      { described_class.parse(list_file).to_a }

  let(:path) { list_file }
  subject { described_class.new(path) }

  it { expect(described_class).to be < Ronin::Support::Network::ASN::RecordSet }

  describe "FILE_NAME" do
    subject { described_class::FILE_NAME }

    it do
      expect(subject).to eq('ip2asn-combined.tsv.gz')
    end
  end

  describe "URL" do
    subject { described_class::URL }

    it do
      expect(subject).to eq('https://iptoasn.com/data/ip2asn-combined.tsv.gz')
    end
  end

  describe "PATH" do
    subject { described_class::PATH }

    it do
      expect(subject).to eq(File.join(Gem.user_home,'.cache','ronin','ronin-support','ip2asn-combined.tsv.gz'))
    end
  end

  describe "#initialize" do
    it "must set #path" do
      expect(subject.path).to eq(path)
    end

    it "must initializes #records to []" do
      expect(subject.records).to eq([])
    end
  end

  describe "file methods" do
    let(:tempdir) { Dir.mktmpdir('ronin-support') }
    let(:path)    { File.join(tempdir,described_class::FILE_NAME) }

    before do
      stub_const("#{described_class}::PATH",path)
    end

    describe ".downloaded?" do
      subject { described_class }

      context "when given no argument" do
        context "when the file does not exist" do
          it "must return false" do
            expect(subject.downloaded?).to be(false)
          end
        end

        context "when the file does exist" do
          before { FileUtils.touch(path) }

          it "must return true" do
            expect(subject.downloaded?).to be(true)
          end

          after { FileUtils.rm(path) }
        end
      end

      context "when given a path" do
        context "when the file does not exist" do
          it "must return false" do
            expect(subject.downloaded?(path)).to be(false)
          end
        end

        context "when the file does exist" do
          before { FileUtils.touch(path) }

          it "must return true" do
            expect(subject.downloaded?(path)).to be(true)
          end

          after { FileUtils.rm(path) }
        end
      end
    end

    describe ".stale?" do
      subject { described_class }

      context "when given no argument" do
        context "when the file does not exist" do
          it "must return true" do
            expect(subject.stale?).to be(true)
          end
        end

        context "when the file does exist" do
          before { FileUtils.touch(path) }

          context "and the modification time of the file is within the last day" do
            before do
              FileUtils.touch(path, mtime: (Time.now - (60 * 60)))
            end

            it "must return false" do
              expect(subject.stale?).to be(false)
            end
          end

          context "but the modification time is older than one day" do
            before do
              FileUtils.touch(path, mtime: (Time.now - (60 * 60 * 25)))
            end

            it "must return true" do
              expect(subject.stale?).to be(true)
            end
          end

          after { FileUtils.rm(path) }
        end
      end

      context "when given a path" do
        context "when the file does not exist" do
          it "must return true" do
            expect(subject.stale?(path)).to be(true)
          end
        end

        context "when the file does exist" do
          before { FileUtils.touch(path) }

          context "and the modification time of the file is within the last day" do
            before do
              FileUtils.touch(path, mtime: (Time.now - (60 * 60)))
            end

            it "must return false" do
              expect(subject.stale?(path)).to be(false)
            end
          end

          context "but the modification time is older than one day" do
            before do
              FileUtils.touch(path, mtime: (Time.now - (60 * 60 * 25)))
            end

            it "must return true" do
              expect(subject.stale?(path)).to be(true)
            end
          end

          after { FileUtils.rm(path) }
        end
      end
    end

    describe ".download", :network do
      subject { described_class }

      before(:all) { WebMock.allow_net_connect! }

      context "when given no keyword arguments" do
        before { subject.download }

        it "must download the URL to the PATH" do
          expect(File.file?(described_class::PATH)).to be(true)
          expect(File.stat(described_class::PATH).size).to be > 0
        end
      end

      context "when the path: keyword argument is given" do
        let(:tempfile) { Tempfile.new(['list', '.tsv.gz']) }
        let(:path)     { tempfile.path }

        before { subject.download(path: path) }

        it "must download the ASN list to the specified path" do
          expect(File.file?(path)).to be(true)
          expect(File.stat(path).size).to be > 0
        end

        context "but the parent directory does not yet exist" do
          let(:tempdir) { Dir.mktmpdir('ronin-support') }
          let(:path)    { File.join(tempdir,'new_dir','list.tsv.gz') }

          it "must create the parent directory" do
            expect(File.directory?(File.dirname(path))).to be(true)
            expect(File.file?(path)).to be(true)
            expect(File.stat(path).size).to be > 0
          end
        end
      end
    end

    describe ".update" do
      subject { described_class }

      context "when given no keyword arguments" do
        context "and when .downloaded? returns false" do
          before { allow(subject).to receive(:downloaded?).and_return(false) }

          it "must call .download" do
            expect(subject).to receive(:download)

            subject.update
          end

          context "but when .download raises an exception" do
            let(:exception) { RuntimeError.new("download failed") }

            it "must ignore any exceptions" do
              allow(subject).to receive(:download).and_raise(exception)

              expect {
                subject.update
              }.to raise_error(exception)
            end
          end
        end

        context "and when .downloaded? returns true" do
          before { allow(subject).to receive(:downloaded?).and_return(true) }

          context "and when .stale? returns true" do
            before { allow(subject).to receive(:stale?).and_return(true) }

            it "must call .download" do
              expect(subject).to receive(:download)

              subject.update
            end

            context "but when .download raises an exception" do
              it "must ignore any exceptions" do
                allow(subject).to receive(:download).and_raise(
                  RuntimeError.new("download failed")
                )

                expect {
                  subject.update
                }.to_not raise_error
              end
            end
          end

          context "and when .stale? returns false" do
            before { allow(subject).to receive(:stale?).and_return(false) }

            it "must not call .download" do
              expect(subject).to_not receive(:download)

              subject.update
            end
          end
        end
      end
    end

    describe ".parse" do
      let(:path) { list_file }

      subject { described_class }

      context "when given no argument" do
        let(:path) { File.join(fixtures_dir,'list.tsv.gz') }

        context "and when given a block" do
          it "must yield each parsed Ronin::Support::Network::ASN::Record" do
            expect { |b|
              subject.parse(&b)
            }.to yield_successive_args(*records)
          end
        end

        context "and when given no block" do
          it "must return an Enumerator for .parse" do
            expect(subject.parse.to_a).to eq(records)
          end
        end
      end

      context "when given a path" do
        context "and when given a block" do
          it "must yield each parsed Ronin::Support::Network::ASN::Record" do
            expect { |b|
              subject.parse(path,&b)
            }.to yield_successive_args(*records)
          end

          context "but when the path ends in '.gz'" do
            let(:path) { File.join(fixtures_dir,'list.tsv.gz') }

            it "must uncompress the gzip data" do
              expect { |b|
                subject.parse(&b)
              }.to yield_successive_args(*records)
            end
          end
        end

        context "and when given no block" do
          it "must return an Enumerator for .parse" do
            expect(subject.parse(path).to_a).to eq(records)
          end

          context "but when the path ends in '.gz'" do
            let(:path) { File.join(fixtures_dir,'list.tsv.gz') }

            it "must uncompress the gzip data" do
              expect(subject.parse.to_a).to eq(records)
            end
          end
        end
      end

      describe "record" do
        subject { super().parse.first }

        it "must parse the first and second IPs into a Ronin::Support::Network::IPRange::Range" do
          expect(subject.range).to be_kind_of(Ronin::Support::Network::IPRange::Range)
          expect(subject.range.begin).to eq(Ronin::Support::Network::IP.new('1.0.0.0'))
          expect(subject.range.end).to eq(Ronin::Support::Network::IP.new('1.0.0.255'))
        end

        it "must parse the AS number into an Integer" do
          expect(subject.number).to eq(13335)
        end

        it "must parse the country code" do
          expect(subject.country_code).to eq('US')
        end

        it "must parse the name" do
          expect(subject.name).to eq('CLOUDFLARENET')
        end
      end
    end

    describe ".load_file" do
      let(:path) { list_file }

      subject { described_class }

      context "when given no argument" do
        let(:path) { File.join(fixtures_dir,'list.tsv.gz') }

        subject { super().load_file }

        it "must return a #{described_class} object with the parsed records" do
          expect(subject).to be_kind_of(described_class)
          expect(subject.records).to eq(records)
        end
      end

      context "when given a path" do
        subject { super().load_file(path) }

        it "must return a #{described_class} object with the parsed records" do
          expect(subject).to be_kind_of(described_class)
          expect(subject.records).to eq(records)
        end

        context "but when the path ends in '.gz'" do
          let(:path) { File.join(fixtures_dir,'list.tsv.gz') }

          it "must uncompress the gzip data" do
            expect(subject).to be_kind_of(described_class)
            expect(subject.records).to eq(records)
          end
        end
      end
    end
  end

  describe "#<<" do
    let(:record1) { records[0] }
    let(:record2) { records[1] }

    it "must append the record to #records" do
      subject << record1
      subject << record2

      expect(subject.records).to eq([record1, record2])
    end

    it "must return self" do
      expect(subject << record1).to be(subject)
    end
  end

  describe "#ip" do
    subject { described_class.load_file(path) }

    context "when one of the record's range includes the IP address" do
      let(:ip) { '1.1.1.1' }

      subject { super().ip(ip) }

      it "must return the record who's range includes the IP address" do
        expect(subject).to be_kind_of(Ronin::Support::Network::ASN::Record)
        expect(subject.range).to include(ip)
      end
    end

    context "when no record's range includes the IP address" do
      let(:ip) { '255.255.255.255' }

      subject { super().ip(ip) }

      it "must return nil" do
        expect(subject).to be(nil)
      end
    end
  end

  describe "#inspect" do
    it "must include the class name and the #path" do
      expect(subject.inspect).to eq("#<#{described_class}: #{path}>")
    end
  end
end
