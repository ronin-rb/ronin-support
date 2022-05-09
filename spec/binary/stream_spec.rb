require 'spec_helper'
require 'ronin/support/binary/stream'

require 'stringio'
require 'binary/stream/methods_examples'

describe Ronin::Support::Binary::Stream do
  let(:buffer) { String.new }
  let(:io)     { StringIO.new(buffer.encode(Encoding::ASCII_8BIT)) }

  subject { described_class.new(io) }

  describe "#initialize" do
    subject { described_class.new(io) }

    it "must set #io" do
      expect(subject.io).to be(io)
    end

    it "must default #endian to nil" do
      expect(subject.endian).to be(nil)
    end

    it "must default #arch to nil" do
      expect(subject.arch).to be(nil)
    end

    it "must default #type_system to Ronin::Support::Binary::CTypes" do
      expect(subject.type_system).to be(Ronin::Support::Binary::CTypes)
    end

    context "when the endian: keyword argument is given" do
      let(:endian) { :little }

      subject { described_class.new(io, endian: endian) }

      it "must set #endian" do
        expect(subject.endian).to be(endian)
      end

      it "must set #type_system using Ronin::Support::Binary::CTypes.platform(endian: ...)" do
        expect(subject.type_system).to be(
          Ronin::Support::Binary::CTypes.platform(endian: endian)
        )
      end
    end

    context "when the arch: keyword argument is given" do
      let(:arch) { :x86 }

      subject { described_class.new(io, arch: arch) }

      it "must set #arch" do
        expect(subject.arch).to be(arch)
      end

      it "must set #type_system using Ronin::Support::Binary::CTypes.platform(arch: ...)" do
        expect(subject.type_system).to be(
          Ronin::Support::Binary::CTypes.platform(arch: arch)
        )
      end
    end
  end

  describe ".open" do
    let(:path) { __FILE__ }

    subject { described_class.open(path) }

    it "must return a new #{described_class} object" do
      expect(subject).to be_kind_of(described_class)
    end

    it "must set #io to a File object with the given path" do
      expect(subject.io).to be_kind_of(File)
      expect(subject.io.path).to eq(path)
    end

    it "must open the File in binary mode" do
      expect(subject.io.binmode?).to be(true)
    end

    context "when a mode argument is given" do
      require 'tempfile'

      let(:tempfile) { Tempfile.new('ronin-support-binary-stream') }
      let(:path)     { tempfile.path }
      let(:mode)     { 'w' }

      subject { described_class.open(path,mode) }

      it "must open the File with the given mode" do
        expect {
          subject.write("test")
        }.to_not raise_error(IOError,"not opened for writing")
      end

      it "must still open the File in binary mode" do
        expect(subject.io.binmode?).to be(true)
      end
    end
  end

  describe "#read" do
    let(:buffer) { "ABCAAAAAA" }
    let(:length) { 3 }

    it "must read the given number of bytes and return a String" do
      expect(subject.read(length)).to eq(buffer[0,length])
    end

    context "when no arguments are given" do
      it "must read until the end of the stream and return a String" do
        expect(subject.read).to eq(buffer)
      end
    end
  end

  describe "#eof?" do
    let(:buffer) { "AAAAAAA" }

    context "when there is still data to be read in the stream" do
      it "must return false" do
        expect(subject.eof?).to be(false)
      end
    end

    context "when the end of the stream has been reached" do
      before { subject.read }

      it "must return true" do
        expect(subject.eof?).to be(true)
      end
    end
  end

  describe "#write" do
    let(:string) { "ABC" }

    it "must write the String to the stream" do
      subject.write(string)

      expect(io.string).to eq(string)
    end
  end

  include_examples "Ronin::Support::Binary::Stream::Methods examples"
end
