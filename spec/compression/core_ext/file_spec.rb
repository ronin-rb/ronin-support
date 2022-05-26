require 'spec_helper'
require 'ronin/support/compression/core_ext/file'

require 'tempfile'

describe File do
  let(:fixtures_dir) { File.join(__dir__,'..','fixtures') }

  let(:txt_path) { File.join(fixtures_dir,'file.txt') }
  let(:txt_data) { File.read(txt_path)                }

  let(:gzip_path) { File.join(fixtures_dir,'file.gz') }
  let(:gzip_data) { File.binread(gzip_path)           }

  it { expect(described_class).to respond_to(:gzip)   }
  it { expect(described_class).to respond_to(:gunzip) }

  describe ".gzip" do
    subject { described_class }

    let(:tempfile) { Tempfile.new('ronin-support') }
    let(:path)     { tempfile.path }

    it "must return a Zlib::GzipWriter object" do
      expect(subject.gzip(path)).to be_kind_of(Zlib::GzipWriter)
    end

    it "must write compressed data to the file" do
      subject.gzip(path) do |gz|
        gz.write(txt_data)
      end

      expect(subject.gunzip(path).read).to eq(txt_data)
    end

    context "and when a block is given" do
      it "must yield the new Zlib::GzipWriter object" do
        expect { |b|
          subject.gzip(path,&b)
        }.to yield_with_args(Zlib::GzipWriter)
      end
    end
  end

  describe ".gunzip" do
    subject { described_class }

    let(:path) { gzip_path }

    it "must return a Zlib::GzipReader object" do
      expect(subject.gunzip(path)).to be_kind_of(Zlib::GzipReader)
    end

    it "must read the gzipped data from the file" do
      expect(subject.gunzip(path).read).to eq(txt_data)
    end

    context "and when a block is given" do
      it "must yield the new Zlib::GzipReader object" do
        expect { |b|
          subject.gunzip(path,&b)
        }.to yield_with_args(Zlib::GzipReader)
      end
    end
  end
end
