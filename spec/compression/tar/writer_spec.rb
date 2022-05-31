require 'spec_helper'
require 'ronin/support/compression/tar/writer'

require 'tempfile'

describe Ronin::Support::Compression::Tar::Writer do
  it "must inherit from Gem::Package::TarWriter" do
    expect(described_class).to be < Gem::Package::TarWriter
  end

  let(:fixtures_dir) { File.join(__dir__,'..','fixtures') }

  let(:txt_path) { File.join(fixtures_dir,'file.txt') }
  let(:txt_data) { File.read(txt_path)                }

  let(:tar_path) { File.join(fixtures_dir,'file.tar') }
  let(:tar_data) { File.binread(tar_path)             }

  describe ".new" do
    context "when given a String" do
      let(:string) { String.new(encoding: Encoding::ASCII_8BIT) }

      context "when no mode: keyword is given" do
        subject { described_class.new(string) }
        before do
          subject.add_file('test.txt') { |io| io.write(txt_data) }
          subject.close
        end

        it "must write to the given String" do
          expect(string).to_not be_empty

          tar   = Gem::Package::TarReader.new(StringIO.new(string))
          entry = tar.find { |entry| entry.full_name == 'test.txt' }

          expect(entry.read).to eq(txt_data)
        end

        context "and when a block is given" do
          it "must yield the new #{described_class} object" do
            expect { |b|
              described_class.new(string,&b)
            }.to yield_with_args(described_class)
          end
        end
      end

      context "when given mode: 'a'" do
        let(:string) { String.new("foo", encoding: Encoding::ASCII_8BIT) }

        subject { described_class.new(string, mode: 'a') }
        before do
          subject.add_file('test.txt') { |io| io.write(txt_data) }
          subject.close
        end

        it "must append to the given String" do
          pending "for some reason appending tar data to a String causes weird padding issues"

          expect(string).to start_with("foo")
          expect(string.length).to be > 3

          tar = Gem::Package::TarReader.new(StringIO.new(string[3..]))

          entry = tar.find { |entry| entry.full_name == 'test.txt' }
          expect(entry.read).to eq(txt_data)
        end

        context "and when a block is given" do
          it "must yield the new #{described_class} object" do
            expect { |b|
              described_class.new(string, mode: 'a', &b)
            }.to yield_with_args(described_class)
          end
        end
      end
    end

    context "when given a StringIO" do
      let(:buffer)    { String.new(encoding: Encoding::ASCII_8BIT) }
      let(:string_io) { StringIO.new(buffer) }

      context "when no mode: keyword argument is given" do
        subject { described_class.new(string_io) }
        before do
          subject.add_file('test.txt') { |io| io.write(txt_data) }
          subject.close
        end

        it "must write to the IO object" do
          expect(buffer).to_not be_empty

          tar   = Gem::Package::TarReader.new(StringIO.new(buffer))
          entry = tar.find { |entry| entry.full_name == 'test.txt' }

          expect(entry.read).to eq(txt_data)
        end

        context "and when a block is given" do
          it "must yield the new #{described_class} object" do
            expect { |b|
              described_class.new(string_io,&b)
            }.to yield_with_args(described_class)
          end
        end
      end
    end

    context "when given an IO object" do
      let(:tempfile) { Tempfile.new('ronin-support') }

      context "when no mode: keyword is given" do
        subject { described_class.new(tempfile) }
        before do
          subject.add_file('test.txt') { |io| io.write(txt_data) }
          subject.close
        end

        it "must write to the IO object" do
          written_data = File.binread(tempfile.path)
          expect(written_data).to_not be_empty

          tar   = Gem::Package::TarReader.new(StringIO.new(written_data))
          entry = tar.find { |entry| entry.full_name == 'test.txt' }

          expect(entry.read).to eq(txt_data)
        end

        context "and when a block is given" do
          it "must yield the new #{described_class} object" do
            expect { |b|
              described_class.new(tempfile,&b)
            }.to yield_with_args(described_class)
          end
        end
      end
    end
  end

  describe ".open" do
    subject { described_class }

    let(:tempfile) { Tempfile.new('ronin-support') }
    let(:path)     { tempfile.path }

    it "must return a #{described_class} object" do
      expect(subject.open(path)).to be_kind_of(described_class)
    end

    context "and when a block is given" do
      it "must yield the new #{described_class} object" do
        expect { |b|
          subject.open(path,&b)
        }.to yield_with_args(described_class)
      end
    end
  end

  let(:buffer) { String.new(encoding: Encoding::ASCII_8BIT) }

  subject { described_class.new(buffer) }

  let(:tar) { Gem::Package::TarReader.new(StringIO.new(buffer)) }

  describe "#add_file" do
    let(:name) { 'test.txt' }
    let(:entry) do
      tar.find { |entry| entry.full_name == name }
    end

    context "when given a content argument" do
      context "and when no mode: keyword argument is given" do
        before do
          subject.add_file(name) { |io| io.write(txt_data) }
        end

        it "must yield a Gem::Package::TarWriter::RestrictedStream object" do
          expect { |b|
            subject.add_file(name,&b)
          }.to yield_with_args(Gem::Package::TarWriter::RestrictedStream)
        end

        it "must add a file with the given name" do
          expect(entry.file?).to be(true)
          expect(entry.full_name).to eq(name)
        end

        it "must default the mode to 0644" do
          expect(entry.header.mode).to eq(0644)
        end
      end

      context "and when a mode: keyword argument is given" do
        let(:mode) { 0777 }

        before do
          subject.add_file(name, mode: mode) do |io|
            io.write(txt_data)
          end
        end

        it "must yield a Gem::Package::TarWriter::RestrictedStream object" do
          expect { |b|
            subject.add_file(name, mode: mode, &b)
          }.to yield_with_args(Gem::Package::TarWriter::RestrictedStream)
        end

        it "must add a file with the given name" do
          expect(entry.file?).to be(true)
          expect(entry.full_name).to eq(name)
        end

        it "must use the given mode: value" do
          expect(entry.header.mode).to eq(mode)
        end
      end
    end

    context "when a content argument is given" do
      let(:contents) { "contents" }

      context "and when no mode: keyword argument is given" do
        before do
          subject.add_file(name,contents)
        end

        it "must add a file with the given name and contents" do
          expect(entry.file?).to be(true)
          expect(entry.full_name).to eq(name)
          expect(entry.read).to eq(contents)
        end

        it "must default the mode to 0644" do
          expect(entry.header.mode).to eq(0644)
        end
      end

      context "and when a mode: keyword argument is given" do
        let(:mode) { 0777 }

        before do
          subject.add_file(name,contents, mode: mode)
        end

        it "must add a file with the given name" do
          expect(entry.file?).to be(true)
          expect(entry.full_name).to eq(name)
          expect(entry.read).to eq(contents)
        end

        it "must use the given mode: value" do
          expect(entry.header.mode).to eq(mode)
        end
      end
    end
  end

  describe "#allocate_file" do
    let(:name) { 'test.txt' }
    let(:entry) do
      tar.find { |entry| entry.full_name == name }
    end

    let(:size) { 1024 }

    context "when no mode: keyword argument is given" do
      before do
        subject.allocate_file(name, size) do |io|
          io.write(txt_data)
        end
      end

      it "must add a file with the given name" do
        expect(entry.file?).to be(true)
        expect(entry.full_name).to eq(name)
      end

      it "must default the mode to 0644" do
        expect(entry.header.mode).to eq(0644)
      end

      it "must set the size to the given size" do
        expect(entry.header.size).to eq(size)
      end
    end

    context "when a mode: keyword argument is given" do
      let(:mode) { 0777 }

      before do
        subject.allocate_file(name, size, mode: mode) do
          |io| io.write(txt_data)
        end
      end

      it "must add a file with the given name" do
        expect(entry.file?).to be(true)
        expect(entry.full_name).to eq(name)
      end

      it "must use the given mode: value" do
        expect(entry.header.mode).to eq(mode)
      end

      it "must set the size to the given size" do
        expect(entry.header.size).to eq(size)
      end
    end
  end

  describe "#add_symlink" do
    let(:name)   { 'test'     }
    let(:target) { 'test.txt' }
    let(:entry) do
      tar.find { |entry| entry.full_name == name }
    end

    before do
      subject.add_file(target) do |io|
        io.write(txt_data)
      end
    end

    context "when no mode: keyword argument is given" do
      before { subject.add_symlink(name,target) }

      it "must add a symlink with the given name to the target" do
        expect(entry.symlink?).to be(true)
        expect(entry.header.linkname).to eq(target)
      end

      it "must default the mode to 0777" do
        expect(entry.header.mode).to eq(0777)
      end
    end

    context "when a mode: keyword argument is given" do
      let(:mode) { 0766 }

      before { subject.add_symlink(name, target, mode: mode) }

      it "must add a symlink with the given name to the target" do
        expect(entry.symlink?).to be(true)
        expect(entry.header.linkname).to eq(target)
      end

      it "must use the given mode: value" do
        expect(entry.header.mode).to eq(mode)
      end
    end
  end

  describe "#mkdir" do
    let(:name)   { 'test_dir' }
    let(:entry) do
      tar.find { |entry| entry.full_name == name }
    end

    context "when no mode: keyword argument is given" do
      before { subject.mkdir(name) }

      it "must add a symlink with the given name to the target" do
        expect(entry.directory?).to be(true)
        expect(entry.full_name).to eq(name)
      end

      it "must default the mode to 0755" do
        expect(entry.header.mode).to eq(0755)
      end
    end

    context "when a mode: keyword argument is given" do
      let(:mode) { 0744 }

      before { subject.mkdir(name, mode: mode) }

      it "must add a symlink with the given name to the target" do
        expect(entry.directory?).to be(true)
        expect(entry.full_name).to eq(name)
      end

      it "must use the given mode: value" do
        expect(entry.header.mode).to eq(mode)
      end
    end
  end
end
