require 'spec_helper'
require 'ronin/support/network/public_suffix/list'

require 'fileutils'
require 'tempfile'
require 'tmpdir'

describe Ronin::Support::Network::PublicSuffix::List do
  let(:fixtures_dir) { File.join(__dir__,'fixtures') }
  let(:list_file)    { File.join(fixtures_dir,'public_suffix_list.dat') }
  let(:suffixes)     { described_class.parse(list_file).to_a }

  let(:path) { list_file }
  subject { described_class.new(path) }

  describe "FILE_NAME" do
    subject { described_class::FILE_NAME }

    it do
      expect(subject).to eq('public_suffix_list.dat')
    end
  end

  describe "URL" do
    subject { described_class::URL }

    it do
      expect(subject).to eq('https://publicsuffix.org/list/public_suffix_list.dat')
    end
  end

  describe "PATH" do
    subject { described_class::PATH }

    it do
      expect(subject).to eq(File.join(Gem.user_home,'.cache','ronin','ronin-support','public_suffix_list.dat'))
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

    describe ".parse" do
      let(:path) { list_file }

      subject { described_class }

      context "when given no argument" do
        let(:path) { File.join(fixtures_dir,'public_suffix_list.dat') }

        context "and when given a block" do
          it "must yield each parsed Ronin::Support::Network::PublicSuffix::Suffix" do
            expect { |b|
              subject.parse(&b)
            }.to yield_successive_args(*suffixes)
          end
        end

        context "and when given no block" do
          it "must return an Enumerator for .parse" do
            expect(subject.parse.to_a).to eq(suffixes)
          end
        end
      end

      context "when given a path" do
        context "and when given a block" do
          it "must yield each parsed Ronin::Support::Network::PublicSuffix::Suffix" do
            expect { |b|
              subject.parse(path,&b)
            }.to yield_successive_args(*suffixes)
          end
        end

        context "and when given no block" do
          it "must return an Enumerator for .parse" do
            expect(subject.parse(path).to_a).to eq(suffixes)
          end
        end
      end

      describe "record" do
        subject { super().parse.first }
      end
    end

    describe ".load_file" do
      let(:path) { list_file }

      subject { described_class }

      context "when given no argument" do
        subject { super().load_file }

        it "must return a #{described_class} object with the parsed records" do
          expect(subject).to be_kind_of(described_class)
          expect(subject.suffixes).to_not be_empty
          expect(subject.suffixes).to all(be_kind_of(
            Ronin::Support::Network::PublicSuffix::Suffix
          ))

          expect(subject.tree).to_not be_empty
        end
      end

      context "when given a path" do
        subject { super().load_file(path) }

        it "must return a #{described_class} object with the parsed records" do
          expect(subject).to be_kind_of(described_class)
          expect(subject.suffixes).to_not be_empty
          expect(subject.suffixes).to all(be_kind_of(
            Ronin::Support::Network::PublicSuffix::Suffix
          ))

          expect(subject.tree).to_not be_empty
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
      let(:path) { '/path/to/public_suffix_list.dat' }

      subject { described_class.new(path) }

      it "must set #path" do
        expect(subject.path).to eq(path)
      end
    end

    it "must initializes #suffixes to []" do
      expect(subject.suffixes).to eq([])
    end

    it "must initializes #tree to {}" do
      expect(subject.tree).to eq({})
    end
  end

  describe "#<<" do
    subject { described_class.new }

    let(:suffix1) do
      Ronin::Support::Network::PublicSuffix::Suffix.new('arpa')
    end
    let(:suffix2) do
      Ronin::Support::Network::PublicSuffix::Suffix.new('ip6.arpa')
    end

    it "must append the suffix to the #suffixes" do
      subject << suffix1
      subject << suffix2

      expect(subject.suffixes).to eq([suffix1, suffix2])
    end

    context "when the suffix does not contain a '.'" do
      let(:tld) do
        Ronin::Support::Network::PublicSuffix::Suffix.new("com")
      end

      before { subject << tld }

      it "must add the TLD to #tree as a key" do
        expect(subject.tree).to have_key(tld.name)
      end
    end

    context "when the suffix does contain a '.'" do
      let(:tld)     { "uk" }
      let(:sub_tld) { "co" }
      let(:suffix) do
        Ronin::Support::Network::PublicSuffix::Suffix.new("#{sub_tld}.#{tld}")
      end

      before { subject << suffix }

      it "must add the first tld to #tree as a key" do
        expect(subject.tree).to have_key(tld)
      end

      it "must add a sub-Hash to #tree using the TLD as a key" do
        expect(subject.tree[tld]).to be_kind_of(Hash)
      end

      it "must add the second TLD to the TLD's sub-Hash as a key" do
        expect(subject.tree[tld]).to eq({sub_tld => nil})
      end
    end

    context "when the suffix does contain two '.' characters" do
      let(:tld)         { "org"    }
      let(:sub_tld)     { "dyndns" }
      let(:sub_sub_tld) { "go"     }
      let(:suffix) do
        Ronin::Support::Network::PublicSuffix::Suffix.new(
          "#{sub_sub_tld}.#{sub_tld}.#{tld}", type: :private
        )
      end

      before { subject << suffix }

      it "must add the first tld to #tree as a key" do
        expect(subject.tree).to have_key(tld)
      end

      it "must add a sub-Hash to #tree using the TLD as a key" do
        expect(subject.tree[tld]).to be_kind_of(Hash)
      end

      it "must add the second TLD to the sub-Hash as a key" do
        expect(subject.tree[tld]).to have_key(sub_tld)
      end

      it "must add a sub-sub-Hash to #tree using the second TLD as a key" do
        expect(subject.tree[tld][sub_tld]).to be_kind_of(Hash)
      end

      it "must add the third TLD to the sub-sub-Hash as a key" do
        expect(subject.tree[tld][sub_tld]).to eq({sub_sub_tld => nil})
      end
    end
  end

  subject { described_class.load_file(path) }

  describe "#split" do
    context "when given a domain name" do
      context "when the domain ends with a single TLD" do
        let(:prefix) { "example" }
        let(:tld)    { "com"     }
        let(:domain) { "#{prefix}.#{tld}" }

        it "must return the domain prefix and the TLD" do
          expect(subject.split(domain)).to eq([prefix, tld])
        end
      end

      context "when the domain ends with multiple TLDs" do
        let(:prefix) { "example" }
        let(:suffix) { "co.uk"   }
        let(:domain) { "#{prefix}.#{suffix}" }

        it "must return the domain prefix and the suffix" do
          expect(subject.split(domain)).to eq([prefix, suffix])
        end
      end

      context "when the public suffix starts with a '*' wildcard" do
        let(:prefix) { "example" }
        let(:label)  { 'foo'     }
        let(:suffix) { "nom.br"  }
        let(:domain) { "#{prefix}.#{label}.#{suffix}" }

        it "must consume an arbitrary label for the '*' wildcard label" do
          expect(subject.split(domain)).to eq([prefix, "#{label}.#{suffix}"])
        end
      end

      context "but the domain name does not end in a valid suffix" do
        let(:domain) { "example.X" }

        it do
          expect {
            subject.split(domain)
          }.to raise_error(Ronin::Support::Network::InvalidHostname,"hostname does not have a valid suffix: #{domain.inspect}")
        end
      end
    end

    context "when given a hostname" do
      context "when the hostname ends with a single TLD" do
        let(:prefix)   { "www.example" }
        let(:tld)      { "com"         }
        let(:hostname) { "#{prefix}.#{tld}" }

        it "must return the hostname label and the TLD" do
          expect(subject.split(hostname)).to eq([prefix, tld])
        end
      end

      context "when the hostname ends with multiple TLDs" do
        let(:prefix)   { "www.example" }
        let(:suffix)   { "co.uk"       }
        let(:hostname) { "#{prefix}.#{suffix}" }

        it "must return the hostname label and the suffix" do
          expect(subject.split(hostname)).to eq([prefix, suffix])
        end
      end

      context "when the public suffix starts with a '*' wildcard" do
        let(:prefix)   { "www.example" }
        let(:label)    { 'foo'         }
        let(:suffix)   { "nom.br"      }
        let(:hostname) { "#{prefix}.#{label}.#{suffix}" }

        it "must consume an arbitrary label for the '*' wildcard label" do
          expect(subject.split(hostname)).to eq([prefix, "#{label}.#{suffix}"])
        end
      end

      context "but the hostname name does not end in a valid suffix" do
        let(:domain) { "www.example.X" }

        it do
          expect {
            subject.split(domain)
          }.to raise_error(Ronin::Support::Network::InvalidHostname,"hostname does not have a valid suffix: #{domain.inspect}")
        end
      end
    end
  end

  describe "#to_regexp" do
    it "must return a Regexp" do
      expect(subject.to_regexp).to be_kind_of(Regexp)
    end

    let(:suffixes) do
      subject.reject(&:wildcard?).map(&:to_s)
    end

    it "must match every suffix in the #list" do
      expect(suffixes).to all(match(subject.to_regexp))
    end
  end

  describe "#inspect" do
    it "must include the class name and the #path" do
      expect(subject.inspect).to eq("#<#{described_class}: #{subject.path}>")
    end
  end
end
