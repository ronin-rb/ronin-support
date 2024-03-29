require 'spec_helper'
require 'ronin/support/archive/mixin'

require 'tempfile'

describe Ronin::Support::Archive::Mixin do
  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  let(:fixtures_dir) { File.join(__dir__,'fixtures') }

  let(:txt_path) { File.join(fixtures_dir,'file.txt') }
  let(:txt_data) { File.read(txt_path)                }

  let(:tar_path) { File.join(fixtures_dir,'file.tar') }
  let(:tar_data) { File.binread(tar_path)             }

  let(:zip_path) { File.join(fixtures_dir,'file.zip') }

  describe ".tar_stream" do
    context "when given a String" do
      let(:string) { tar_data }

      it "must return a Ronin::Support::Archive::Tar::Reader object" do
        expect(subject.tar_stream(string)).to be_kind_of(Ronin::Support::Archive::Tar::Reader)
      end

      context "and when a block is given" do
        it "must yield the new Ronin::Support::Archive::Tar::Reader object" do
          expect { |b|
            subject.tar_stream(string,&b)
          }.to yield_with_args(Ronin::Support::Archive::Tar::Reader)
        end
      end

      it "must tar_stream the String in a StringIO object" do
        tar  = subject.tar_stream(string)
        file = tar.find { |entry| entry.full_name == 'file.txt' }

        expect(file.read).to eq(txt_data)
      end

      context "when given mode: 'w'" do
        it "must return a Ronin::Support::Archive::Tar::Writer object" do
          expect(subject.tar_stream(string, mode: 'w')).to be_kind_of(Ronin::Support::Archive::Tar::Writer)
        end

        context "and when a block is given" do
          it "must yield the new Ronin::Support::Archive::Tar::Writer object" do
            expect { |b|
              subject.tar_stream(string, mode: 'w', &b)
            }.to yield_with_args(Ronin::Support::Archive::Tar::Writer)
          end
        end
      end

      context "when given mode: 'a'" do
        it "must return a Ronin::Support::Archive::Tar::Writer object" do
          expect(subject.tar_stream(string, mode: 'a')).to be_kind_of(Ronin::Support::Archive::Tar::Writer)
        end

        context "and when a block is given" do
          it "must yield the new Ronin::Support::Archive::Tar::Writer object" do
            expect { |b|
              subject.tar_stream(string, mode: 'a', &b)
            }.to yield_with_args(Ronin::Support::Archive::Tar::Writer)
          end
        end
      end

      context "when given an unknown mode String" do
        let(:mode) { 'x' }

        it do
          expect {
            subject.tar_stream(string, mode: mode)
          }.to raise_error(ArgumentError,"mode argument must include either 'r', 'w', or 'a': #{mode.inspect}")
        end
      end
    end

    context "when given a StringIO" do
      let(:string_io) { StringIO.new(tar_data) }

      it "must return a Ronin::Support::Archive::Tar::Reader object" do
        expect(subject.tar_stream(string_io)).to be_kind_of(Ronin::Support::Archive::Tar::Reader)
      end

      context "and when a block is given" do
        it "must yield the new Ronin::Support::Archive::Tar::Reader object" do
          expect { |b|
            subject.tar_stream(string_io,&b)
          }.to yield_with_args(Ronin::Support::Archive::Tar::Reader)
        end
      end

      it "must tar_stream the String in a StringIO object" do
        tar  = subject.tar_stream(string_io)
        file = tar.find { |entry| entry.full_name == 'file.txt' }

        expect(file.read).to eq(txt_data)
      end

      context "when given mode: 'w'" do
        it "must return a Ronin::Support::Archive::Tar::Writer object" do
          expect(subject.tar_stream(string_io, mode: 'w')).to be_kind_of(Ronin::Support::Archive::Tar::Writer)
        end

        context "and when a block is given" do
          it "must yield the new Ronin::Support::Archive::Tar::Writer object" do
            expect { |b|
              subject.tar_stream(string_io, mode: 'w', &b)
            }.to yield_with_args(Ronin::Support::Archive::Tar::Writer)
          end
        end
      end

      context "when given mode: 'a'" do
        it "must return a Ronin::Support::Archive::Tar::Writer object" do
          expect(subject.tar_stream(string_io, mode: 'a')).to be_kind_of(Ronin::Support::Archive::Tar::Writer)
        end

        context "and when a block is given" do
          it "must yield the new Ronin::Support::Archive::Tar::Writer object" do
            expect { |b|
              subject.tar_stream(string_io, mode: 'a', &b)
            }.to yield_with_args(Ronin::Support::Archive::Tar::Writer)
          end
        end
      end

      context "when given an unknown mode String" do
        let(:mode) { 'x' }

        it do
          expect {
            subject.tar_stream(string_io, mode: mode)
          }.to raise_error(ArgumentError,"mode argument must include either 'r', 'w', or 'a': #{mode.inspect}")
        end
      end
    end

    context "when given an IO object" do
      let(:io) { File.open(tar_path,'rb') }

      it "must return a Ronin::Support::Archive::Tar::Reader object" do
        expect(subject.tar_stream(io)).to be_kind_of(Ronin::Support::Archive::Tar::Reader)
      end

      context "and when a block is given" do
        it "must yield the new Ronin::Support::Archive::Tar::Reader object" do
          expect { |b|
            subject.tar_stream(io,&b)
          }.to yield_with_args(Ronin::Support::Archive::Tar::Reader)
        end
      end

      context "when given mode: 'w'" do
        let(:tempfile) { Tempfile.new('ronin-support') }
        let(:path)     { tempfile.path }
        let(:io)       { File.open(path,'wb') }

        it "must return a Ronin::Support::Archive::Tar::Writer object" do
          expect(subject.tar_stream(tempfile, mode: 'w')).to be_kind_of(Ronin::Support::Archive::Tar::Writer)
        end

        context "and when a block is given" do
          it "must yield the new Ronin::Support::Archive::Tar::Writer object" do
            expect { |b|
              subject.tar_stream(io, mode: 'w', &b)
            }.to yield_with_args(Ronin::Support::Archive::Tar::Writer)
          end
        end
      end

      context "when given mode: 'a'" do
        let(:tempfile) { Tempfile.new('ronin-support') }
        let(:path)     { tempfile.path }
        let(:io)       { File.open(path,'ab') }

        it "must return a Ronin::Support::Archive::Tar::Writer object" do
          expect(subject.tar_stream(io, mode: 'a')).to be_kind_of(Ronin::Support::Archive::Tar::Writer)
        end

        context "and when a block is given" do
          it "must yield the new Ronin::Support::Archive::Tar::Writer object" do
            expect { |b|
              subject.tar_stream(io, mode: 'a', &b)
            }.to yield_with_args(Ronin::Support::Archive::Tar::Writer)
          end
        end
      end

      context "when given an unknown mode String" do
        let(:mode) { 'x' }

        it do
          expect {
            subject.tar_stream(io, mode: mode)
          }.to raise_error(ArgumentError,"mode argument must include either 'r', 'w', or 'a': #{mode.inspect}")
        end
      end
    end
  end

  describe ".tar_open" do
    let(:path) { tar_path }

    it "must return a Ronin::Support::Archive::Tar::Reader object" do
      expect(subject.tar_open(path)).to be_kind_of(Ronin::Support::Archive::Tar::Reader)
    end

    context "and when a block is given" do
      it "must yield the new Ronin::Support::Archive::Tar::Reader object" do
        expect { |b|
          subject.tar_open(path,&b)
        }.to yield_with_args(Ronin::Support::Archive::Tar::Reader)
      end
    end

    context "when given mode: 'w'" do
      let(:tempfile) { Tempfile.new('ronin-support') }
      let(:path)     { tempfile.path }

      it "must return a Ronin::Support::Archive::Tar::Writer object" do
        expect(subject.tar_open(path, mode: 'w')).to be_kind_of(Ronin::Support::Archive::Tar::Writer)
      end

      context "and when a block is given" do
        it "must yield the new Ronin::Support::Archive::Tar::Writer object" do
          expect { |b|
            subject.tar_open(path, mode: 'w', &b)
          }.to yield_with_args(Ronin::Support::Archive::Tar::Writer)
        end
      end
    end

    context "when given mode: 'a'" do
      let(:tempfile) { Tempfile.new('ronin-support') }
      let(:path)     { tempfile.path }

      it "must return a Ronin::Support::Archive::Tar::Writer object" do
        expect(subject.tar_open(path, mode: 'w')).to be_kind_of(Ronin::Support::Archive::Tar::Writer)
      end

      context "and when a block is given" do
        it "must yield the new Ronin::Support::Archive::Tar::Writer object" do
          expect { |b|
            subject.tar_open(path, mode: 'a', &b)
          }.to yield_with_args(Ronin::Support::Archive::Tar::Writer)
        end
      end
    end
  end

  describe ".untar" do
    let(:path) { tar_path }

    it "must return a Ronin::Support::Archive::Tar::Reader object" do
      expect(subject.untar(path)).to be_kind_of(Ronin::Support::Archive::Tar::Reader)
    end

    it "must read tar data from the given path" do
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

  describe ".tar" do
    let(:tempfile) { Tempfile.new('ronin-support') }
    let(:path)     { tempfile.path }

    it "must return a Ronin::Support::Archive::Tar::Writer object" do
      expect(subject.tar(path)).to be_kind_of(Ronin::Support::Archive::Tar::Writer)
    end

    it "must write tar data to the given path" do
      tar = subject.tar(path)
      tar.add_file('file.txt',txt_data)
      tar.close

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

  describe ".zip_open" do
    let(:path) { zip_path }

    it "must return a Ronin::Support::Archive::Zip::Reader object" do
      expect(subject.zip_open(path)).to be_kind_of(Ronin::Support::Archive::Zip::Reader)
    end

    context "and when a block is given" do
      it "must yield the new Ronin::Support::Archive::Zip::Reader object" do
        expect { |b|
          subject.zip_open(path,&b)
        }.to yield_with_args(Ronin::Support::Archive::Zip::Reader)
      end
    end

    context "when given mode: 'w'" do
      let(:tempfile) { Tempfile.new('ronin-support') }
      let(:path)     { tempfile.path }

      it "must return a Ronin::Support::Archive::Zip::Writer object" do
        expect(subject.zip_open(path, mode: 'w')).to be_kind_of(Ronin::Support::Archive::Zip::Writer)
      end

      context "and when a block is given" do
        it "must yield the new Ronin::Support::Archive::Zip::Writer object" do
          expect { |b|
            subject.zip_open(path, mode: 'w', &b)
          }.to yield_with_args(Ronin::Support::Archive::Zip::Writer)
        end
      end
    end

    context "when given mode: 'a'" do
      let(:tempfile) { Tempfile.new('ronin-support') }
      let(:path)     { tempfile.path }

      it "must return a Ronin::Support::Archive::Zip::Writer object" do
        expect(subject.zip_open(path, mode: 'w')).to be_kind_of(Ronin::Support::Archive::Zip::Writer)
      end

      context "and when a block is given" do
        it "must yield the new Ronin::Support::Archive::Zip::Writer object" do
          expect { |b|
            subject.zip_open(path, mode: 'a', &b)
          }.to yield_with_args(Ronin::Support::Archive::Zip::Writer)
        end
      end
    end
  end

  describe ".unzip" do
    let(:path) { zip_path }

    it "must return a Ronin::Support::Archive::Zip::Reader object" do
      expect(subject.unzip(path)).to be_kind_of(Ronin::Support::Archive::Zip::Reader)
    end

    it "must read zip data from the given path" do
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

  describe ".zip" do
    let(:tempfile) { Tempfile.new('ronin-support') }
    let(:path)     { tempfile.path }

    it "must return a Ronin::Support::Archive::Zip::Writer object" do
      expect(subject.zip(path)).to be_kind_of(Ronin::Support::Archive::Zip::Writer)
    end

    it "must write zip data to the given path" do
      zip = subject.zip(path)
      zip.add_file('file.txt',txt_data)
      zip.close

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
end
