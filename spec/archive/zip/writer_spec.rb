require 'spec_helper'
require 'ronin/support/archive/zip/writer'
require 'ronin/support/archive/zip/reader'

require 'tempfile'

describe Ronin::Support::Archive::Zip::Writer do
  let(:tempfile) { Tempfile.new('ronin-support') }
  let(:path)     { tempfile.path }

  describe "#initialize" do
    subject { described_class.new(path) }

    it "must set #path" do
      expect(subject.path).to eq(path)
    end

    context "when given a relative path" do
      let(:path) { '../path/to/zip' }

      it "must expand the relative path" do
        expect(subject.path).to eq(File.expand_path(path))
      end
    end

    it "must default #password to nil" do
      expect(subject.password).to be(nil)
    end

    context "when given the password: keyword argument" do
      let(:password) { 'secret' }

      subject { described_class.new(path, password: password) }

      it "it must set #password" do
        expect(subject.password).to eq(password)
      end
    end

    it "must create a temporary directory" do
      expect(File.dirname(subject.tempdir)).to eq(Dir.tmpdir)
      expect(File.directory?(subject.tempdir)).to be(true)
    end
  end

  describe ".open" do
    subject { described_class }

    it "must return a #{described_class} object" do
      expect(subject.open(path)).to be_kind_of(described_class)
    end

    it "must set #path to the given path" do
      zip = subject.open(path)

      expect(zip.path).to eq(File.expand_path(path))
    end

    context "and when a block is given" do
      it "must yield the new #{described_class} object then call #close" do
        expect_any_instance_of(described_class).to receive(:close)

        expect { |b|
          subject.open(path,&b)
        }.to yield_with_args(described_class)
      end
    end
  end

  subject { described_class.new(path) }

  describe "#add_file" do
    let(:name)     { 'test.txt'    }
    let(:contents) { 'foo bar baz' }

    context "when the contents argument is given" do
      before { subject.add_file(name,contents) }

      it "must write the contents to the file in the #tempdir" do
        expect(File.read(File.join(subject.tempdir,name))).to eq(contents)
      end
    end

    context "when a block is given" do
      before do
        subject.add_file(name) do |file|
          file.write(contents[0,4])
          file.write(contents[4..])
        end
      end

      it "must be passed the opened file for writing" do
        expect(File.read(File.join(subject.tempdir,name))).to eq(contents)
      end
    end

    after { subject.cleanup }
  end

  describe "#save" do
    context "when files have been added to the zip archive" do
      it "must create a zip archive containing the added files" do
        expect(subject).to receive(:system).with('zip','-q','-r',subject.path,'.')

        subject.add_file('file1.txt','test file 1')
        subject.add_file('file2.txt','test file 2')
        subject.save
      end
    end

    context "when initialized with the password: keyword argument" do
      let(:password) { 'secret' }

      subject { described_class.new(path, password: password) }

      it "must pass the password to the zip command" do
        expect(subject).to receive(:system).with('zip','-q','-P',password,'-r',subject.path,'.')

        subject.save
      end
    end

    context "when no files have been added to the zip archive" do
      it "must still create a zip archive" do
        expect(File.file?(subject.path)).to be(true)
      end
    end
  end

  describe "#cleanup" do
    before { subject.cleanup }

    it "must delete the temp directory" do
      expect(File.directory?(subject.tempdir)).to be(false)
    end
  end

  describe "#close" do
    before do
      allow(subject).to receive(:system).with('zip','-q','-r',subject.path,'.')
      subject.close
    end

    it "must delete the temp directory" do
      expect(File.directory?(subject.tempdir)).to be(false)
    end

    it "must create the zip archive" do
      expect(File.file?(subject.path)).to be(true)
    end
  end
end
