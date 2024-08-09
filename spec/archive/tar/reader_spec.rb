require 'spec_helper'
require 'ronin/support/archive/tar/reader'

describe Ronin::Support::Archive::Tar::Reader do
  it "must inherit from Gem::Package::TarReader" do
    expect(described_class).to be < Gem::Package::TarReader
  end

  let(:fixtures_dir) { File.join(__dir__,'..','fixtures') }

  let(:txt_path) { File.join(fixtures_dir,'file.txt') }
  let(:txt_data) { File.read(txt_path)                }

  let(:tar_path) { File.join(fixtures_dir,'file.tar') }
  let(:tar_data) { File.binread(tar_path)             }

  describe "#initialize" do
    context "when given a String" do
      let(:string) { tar_data }

      subject { described_class.new(string) }

      it "must read from the String" do
        file = subject.find { |entry| entry.full_name == 'file.txt' }

        expect(file.read).to eq(txt_data)
      end

      context "and when a block is given" do
        it "must yield the new #{described_class} object" do
          expect { |b|
            described_class.new(string,&b)
          }.to yield_with_args(described_class)
        end
      end
    end

    context "when given a StringIO" do
      let(:string_io) { StringIO.new(tar_data) }

      subject { described_class.new(string_io) }

      it "must read from the StringIO object" do
        file = subject.find { |entry| entry.full_name == 'file.txt' }

        expect(file.read).to eq(txt_data)
      end

      context "and when a block is given" do
        it "must yield the new #{described_class} object" do
          expect { |b|
            described_class.new(string_io,&b)
          }.to yield_with_args(described_class)
        end
      end
    end

    context "when given an IO object" do
      let(:io) { File.open(tar_path,'rb') }

      subject { described_class.new(io) }

      it "must read from the StringIO object" do
        file = subject.find { |entry| entry.full_name == 'file.txt' }

        expect(file.read).to eq(txt_data)
      end

      context "and when a block is given" do
        it "must yield the new #{described_class} object" do
          expect { |b|
            described_class.new(io,&b)
          }.to yield_with_args(described_class)
        end
      end
    end
  end

  describe ".open" do
    subject { described_class }

    let(:path) { tar_path }

    it "must return a #{described_class} object" do
      expect(subject.open(path)).to be_kind_of(described_class)
    end

    it "must read tar data from the given path" do
      tar = subject.open(path)

      tar.seek('file.txt') do |entry|
        expect(entry.full_name).to eq('file.txt')
        expect(entry.read).to eq(txt_data)
      end
    end

    context "and when a block is given" do
      it "must yield the new #{described_class} object" do
        expect { |b|
          subject.open(path,&b)
        }.to yield_with_args(described_class)
      end
    end
  end

  subject { described_class.new(File.new(tar_path,'rb')) }

  describe "#[]" do
    context "when given the name of an entry in the archive" do
      let(:name) { 'file.txt' }

      it "must return the entry with the matching #full_name" do
        entry = subject[name]

        expect(entry).to_not be(nil)
        expect(entry.full_name).to eq(name)
      end
    end

    context "when no entry in the tar archive has the matching name" do
      let(:name) { "foo" }

      it "must return nil" do
        expect(subject[name]).to be(nil)
      end
    end
  end

  describe "#read" do
    let(:name) { 'file.txt' }

    it "must read the full contents of the file within the archive" do
      expect(subject.read(name)).to eq(txt_data)
    end

    context "when the length: keyword argument is given" do
      let(:length) { 3 }

      it "must only read length number of bytes" do
        expect(subject.read(name, length: length)).to eq(txt_data[0,length])
      end
    end
  end
end
