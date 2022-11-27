require 'spec_helper'
require 'ronin/support/network/tld/list'

require 'fileutils'
require 'tempfile'
require 'tmpdir'

describe Ronin::Support::Network::TLD::List do
  let(:fixtures_dir) { File.join(__dir__,'fixtures') }
  let(:list_file)    { File.join(fixtures_dir,'tlds-alpha-by-domain.txt') }
  let(:path)         { list_file }

  describe "FILE_NAME" do
    subject { described_class::FILE_NAME }

    it do
      expect(subject).to eq('tlds-alpha-by-domain.txt')
    end
  end

  describe "URL" do
    subject { described_class::URL }

    it do
      expect(subject).to eq('https://data.iana.org/TLD/tlds-alpha-by-domain.txt')
    end
  end

  describe "PATH" do
    subject { described_class::PATH }

    it do
      expect(subject).to eq(File.join(Gem.user_home,'.cache','ronin','ronin-support','tlds-alpha-by-domain.txt'))
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

      context "when given no keyword arguments" do
        before { subject.download }

        it "must download the URL to the PATH" do
          expect(File.file?(described_class::PATH)).to be(true)
          expect(File.stat(described_class::PATH).size).to be > 0
        end
      end

      context "when the path: keyword argument is given" do
        let(:tempfile) { Tempfile.new(['list', '.dat']) }
        let(:path)     { tempfile.path }

        before { subject.download(path: path) }

        it "must download the ASN list to the specified path" do
          expect(File.file?(path)).to be(true)
          expect(File.stat(path).size).to be > 0
        end

        context "but the parent directory does not yet exist" do
          let(:tempdir) { Dir.mktmpdir('ronin-support') }
          let(:path)    { File.join(tempdir,'new_dir','list.dat') }

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

    describe ".load_file" do
      let(:path) { list_file }

      subject { described_class }

      context "when given no argument" do
        let(:path) { File.join(fixtures_dir,'tlds-alpha-by-domain.txt') }

        subject { super().load_file }

        it "must return a #{described_class} object with the parsed records" do
          expect(subject).to be_kind_of(described_class)
          expect(subject.list).to_not be_empty
        end

        it "must downcase the TLDs and not parse comment lines" do
          expect(subject.list).to all(match(/\A(?:[a-z]+|xn--[a-z0-9-]+)\z/))
        end
      end

      context "when given a path" do
        subject { super().load_file(path) }

        it "must return a #{described_class} object with the parsed records" do
          expect(subject).to be_kind_of(described_class)
          expect(subject.list).to_not be_empty
        end

        it "must downcase the TLDs and not parse comment lines" do
          expect(subject.list).to all(match(/\A(?:[a-z]+|xn--[a-z0-9-]+)\z/))
        end
      end
    end
  end

  describe "#initialize" do
    subject { described_class.new }

    it "must default #path to #{described_class}::PATH" do
      expect(subject.path).to eq(described_class::PATH)
    end

    context "when given a custom path" do
      let(:path) { '/path/to/tlds-alpha-by-domain.txt' }

      subject { described_class.new(path) }

      it "must set #path" do
        expect(subject.path).to eq(path)
      end
    end

    it "must initializes #list to []" do
      expect(subject.list).to eq([])
    end
  end

  describe "#<<" do
    subject { described_class.new }

    let(:tld1) { 'arpa' }
    let(:tld2) { 'art'  }

    it "must append the tld to the #list" do
      subject << tld1
      subject << tld2

      expect(subject.list).to eq([tld1, tld2])
    end
  end

  subject { described_class.load_file(path) }

  describe "#each" do
    context "when given a block" do
      it "must yield every entry in #list" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(*subject.list)
      end
    end

    context "when given no block" do
      it "must return an Enumerator for #each" do
        expect(subject.each.to_a).to eq(subject.list)
      end
    end
  end

  describe "#split" do
    context "when the domain ends with a single TLD" do
      let(:prefix) { "example" }
      let(:tld)    { "com"     }
      let(:domain) { "#{prefix}.#{tld}" }

      it "must return the domain prefix and the TLD" do
        expect(subject.split(domain)).to eq([prefix, tld])
      end
    end

    context "when the domain ends with multiple TLDs" do
      let(:prefix) { "example.co"       }
      let(:tld)    { 'uk'               }
      let(:domain) { "#{prefix}.#{tld}" }

      it "must return the domain prefix and the TLD" do
        expect(subject.split(domain)).to eq([prefix, tld])
      end
    end
  end

  describe "#to_regexp" do
    it "must return a Regexp" do
      expect(subject.to_regexp).to be_kind_of(Regexp)
    end

    it "must match every TLD in the #list" do
      expect(subject.list).to all(match(subject.to_regexp))
    end
  end

  describe "#inspect" do
    it "must include the class name and the #path" do
      expect(subject.inspect).to eq("#<#{described_class}: #{subject.path}>")
    end
  end
end
