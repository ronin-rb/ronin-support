require 'spec_helper'
require 'ronin/support/compression/tar/reader'

describe Ronin::Support::Compression::Tar::Reader do
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
        entry = subject.find { |entry| entry.full_name == 'file.txt' }

        expect(entry.read).to eq(txt_data)
      end
    end

    context "when given a StringIO" do
      let(:string_io) { StringIO.new(tar_data) }

      subject { described_class.new(string_io) }

      it "must read from the StringIO object" do
        entry = subject.find { |entry| entry.full_name == 'file.txt' }

        expect(entry.read).to eq(txt_data)
      end
    end

    context "when given an IO object" do
      let(:io) { File.open(tar_path,'rb') }

      subject { described_class.new(io) }

      it "must read from the StringIO object" do
        entry = subject.find { |entry| entry.full_name == 'file.txt' }

        expect(entry.read).to eq(txt_data)
      end
    end
  end
end
