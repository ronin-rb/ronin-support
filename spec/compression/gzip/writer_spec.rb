require 'spec_helper'
require 'ronin/support/compression/gzip/writer'

require 'tempfile'

describe Ronin::Support::Compression::Gzip::Writer do
  it "must inherit from Zlib::GzipWriter" do
    expect(described_class).to be < Zlib::GzipWriter
  end

  let(:fixtures_dir) { File.join(__dir__,'..','fixtures') }

  let(:txt_path) { File.join(fixtures_dir,'file.txt') }
  let(:txt_data) { File.read(txt_path)                }

  let(:gzip_path) { File.join(fixtures_dir,'file.gz') }
  let(:gzip_data) { File.binread(gzip_path)           }

  describe "#initialize" do
    context "when given a String" do
      let(:string) { String.new }

      context "when no mode: keyword is given" do
        subject { described_class.new(string) }
        before do
          subject.write(txt_data)
          subject.close
        end

        it "must write to the given String" do
          expect(string).to_not be_empty

          gz = Zlib::GzipReader.new(StringIO.new(string))
          expect(gz.read).to eq(txt_data)
        end
      end

      context "when given mode: 'a'" do
        let(:string)   { "foo" }

        subject { described_class.new(string, mode: 'a') }
        before do
          subject.write(txt_data)
          subject.close
        end

        it "must append to the given String" do
          expect(string).to start_with("foo")
          expect(string.length).to be > 3

          gz = Zlib::GzipReader.new(StringIO.new(string[3..]))
          expect(gz.read).to eq(txt_data)
        end
      end
    end

    context "when given a StringIO" do
      let(:buffer)    { String.new }
      let(:string_io) { StringIO.new(buffer) }

      context "when no mode: keyword argument is given" do
        subject { described_class.new(string_io) }
        before do
          subject.write(txt_data)
          subject.close
        end

        it "must write to the StringIO object" do
          expect(buffer).to_not be_empty

          gz = Zlib::GzipReader.new(StringIO.new(buffer))
          expect(gz.read).to eq(txt_data)
        end
      end
    end

    context "when given an IO object" do
      let(:tempfile) { Tempfile.new('ronin-support') }

      context "when no mode: keyword is given" do
        subject { described_class.new(tempfile) }
        before do
          subject.write(txt_data)
          subject.close
        end

        it "must write to the IO object" do
          written_data = File.binread(tempfile.path)
          expect(written_data).to_not be_empty

          gz = Zlib::GzipReader.new(StringIO.new(written_data))
          expect(gz.read).to eq(txt_data)
        end
      end
    end
  end
end
