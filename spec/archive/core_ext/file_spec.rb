require 'spec_helper'
require 'ronin/support/archive/core_ext/file'

require 'tempfile'

describe File do
  let(:fixtures_dir) { File.join(__dir__,'..','fixtures') }

  let(:txt_path) { File.join(fixtures_dir,'file.txt') }
  let(:txt_data) { File.read(txt_path)                }

  let(:tar_path) { File.join(fixtures_dir,'file.tar') }
  let(:tar_data) { File.binread(tar_path)             }

  let(:zip_path) { File.join(fixtures_dir,'file.zip') }

  it { expect(described_class).to respond_to(:tar)   }
  it { expect(described_class).to respond_to(:untar) }

  it { expect(described_class).to respond_to(:zip)   }
  it { expect(described_class).to respond_to(:unzip) }

  describe ".tar" do
    subject { described_class }

    let(:tempfile) { Tempfile.new('ronin-support') }
    let(:path)     { tempfile.path }

    it "must return a Ronin::Support::Archive::Tar::Writer object" do
      expect(subject.tar(path)).to be_kind_of(Ronin::Support::Archive::Tar::Writer)
    end

    it "must write tar data to the file" do
      subject.tar(path) do |tar|
        tar.add_file('file.txt') do |io|
          io.write(txt_data)
        end
      end

      tar = Gem::Package::TarReader.new(File.open(path))
      tar.seek('file.txt') do |entry|
        expect(entry.full_name).to eq('file.txt')
        expect(entry.read).to eq(txt_data)
      end
    end

    context "and when a block is given" do
      it "must yield the new Ronin::Support::Archive::Tar::Writer object" do
        expect { |b|
          subject.tar(path,&b)
        }.to yield_with_args(Ronin::Support::Archive::Tar::Writer)
      end
    end
  end

  describe ".untar" do
    subject { described_class }

    let(:path) { tar_path }

    it "must return a Ronin::Support::Archive::Tar::Reader object" do
      expect(subject.untar(path)).to be_kind_of(Ronin::Support::Archive::Tar::Reader)
    end

    it "must read the tarped data from the file" do
      tar = subject.untar(path)

      tar.seek('file.txt') do |entry|
        expect(entry.full_name).to eq('file.txt')
        expect(entry.read).to eq(txt_data)
      end
    end

    context "and when a block is given" do
      it "must yield the new Ronin::Support::Archive::Tar::Reader object" do
        expect { |b|
          subject.untar(path,&b)
        }.to yield_with_args(Ronin::Support::Archive::Tar::Reader)
      end
    end
  end

  describe ".zip" do
    subject { described_class }

    let(:tempfile) { Tempfile.new('ronin-support') }
    let(:path)     { tempfile.path }

    it "must return a Ronin::Support::Archive::Zip::Writer object" do
      expect(subject.zip(path)).to be_kind_of(Ronin::Support::Archive::Zip::Writer)
    end

    it "must write zip data to the file" do
      subject.zip(path) do |zip|
        zip.add_file('file.txt') do |io|
          io.write(txt_data)
        end
      end

      zip = Ronin::Support::Archive::Zip::Reader.new(path)
      expect(zip.read('file.txt')).to eq(txt_data)
    end

    context "and when a block is given" do
      it "must yield the new Ronin::Support::Archive::Zip::Writer object" do
        expect { |b|
          subject.zip(path,&b)
        }.to yield_with_args(Ronin::Support::Archive::Zip::Writer)
      end
    end
  end

  describe ".unzip" do
    subject { described_class }

    let(:path) { zip_path }

    it "must return a Ronin::Support::Archive::Zip::Reader object" do
      expect(subject.unzip(path)).to be_kind_of(Ronin::Support::Archive::Zip::Reader)
    end

    it "must read the zipped data from the file" do
      zip = subject.unzip(path)

      expect(zip.read('file.txt')).to eq(txt_data)
    end

    context "and when a block is given" do
      it "must yield the new Ronin::Support::Archive::Zip::Reader object" do
        expect { |b|
          subject.unzip(path,&b)
        }.to yield_with_args(Ronin::Support::Archive::Zip::Reader)
      end
    end
  end
end
