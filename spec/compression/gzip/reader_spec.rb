require 'spec_helper'
require 'ronin/support/compression/gzip/reader'

describe Ronin::Support::Compression::Gzip::Reader do
  it "must inherit from Reader" do
    expect(described_class).to be < Zlib::GzipReader
  end

  let(:fixtures_dir) { File.join(__dir__,'..','fixtures') }

  let(:txt_path) { File.join(fixtures_dir,'file.txt') }
  let(:txt_data) { File.read(txt_path)                }

  let(:gzip_path) { File.join(fixtures_dir,'file.gz') }
  let(:gzip_data) { File.binread(gzip_path)           }

  describe "#initialize" do
    context "when given a String" do
      let(:string) { gzip_data }

      subject { described_class.new(string) }

      it "must read from the String" do
        expect(subject.read).to eq(txt_data)
      end
    end

    context "when given a StringIO" do
      let(:string_io) { StringIO.new(gzip_data) }

      subject { described_class.new(string_io) }

      it "must read from the StringIO object" do
        expect(subject.read).to eq(txt_data)
      end
    end

    context "when given an IO object" do
      let(:io) { File.open(gzip_path,'rb') }

      subject { described_class.new(io) }

      it "must read from the StringIO object" do
        expect(subject.read).to eq(txt_data)
      end
    end
  end
end
