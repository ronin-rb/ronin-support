require 'spec_helper'
require 'ronin/support/compression/mixin'

require 'tempfile'

describe Ronin::Support::Compression::Mixin do
  subject do
    obj = Object.new
    obj.extend described_class
    obj
  end

  let(:fixtures_dir) { File.join(__dir__,'fixtures') }

  let(:txt_path) { File.join(fixtures_dir,'file.txt') }
  let(:txt_data) { File.read(txt_path)                }

  let(:gzip_path) { File.join(fixtures_dir,'file.gz') }
  let(:gzip_data) { File.binread(gzip_path)           }

  let(:zlib_uncompressed) { "hello" }
  let(:zlib_compressed) do
    "x\x9C\xCBH\xCD\xC9\xC9\a\x00\x06,\x02\x15".force_encoding(Encoding::ASCII_8BIT)
  end

  describe "#zlib_inflate" do
    it "must inflate a zlib deflated String" do
      expect(subject.zlib_inflate(zlib_compressed)).to eq(zlib_uncompressed)
    end
  end

  describe "#zlib_deflate" do
    it "must zlib deflate a String" do
      expect(subject.zlib_deflate(zlib_uncompressed)).to eq(zlib_compressed)
    end
  end

  describe "#gzip_stream" do
    context "when given a String" do
      let(:string) { gzip_data }

      it "must return a Ronin::Support::Compression::Gzip::Reader object" do
        expect(subject.gzip_stream(string)).to be_kind_of(Ronin::Support::Compression::Gzip::Reader)
      end

      context "and when a block is given" do
        it "must yield the new Ronin::Support::Compression::Gzip::Reader object" do
          expect { |b|
            subject.gzip_stream(string,&b)
          }.to yield_with_args(Ronin::Support::Compression::Gzip::Reader)
        end
      end

      it "must gzip_stream the String in a StringIO object" do
        gz = subject.gzip_stream(string)

        expect(gz.read).to eq(txt_data)
      end

      context "when given mode: 'w'" do
        let(:tempfile) { Tempfile.new('ronin-support') }
        let(:path)     { tempfile.path }

        it "must return a Ronin::Support::Compression::Gzip::Writer object" do
          expect(subject.gzip_stream(string, mode: 'w')).to be_kind_of(Ronin::Support::Compression::Gzip::Writer)
        end

        context "and when a block is given" do
          it "must yield the new Ronin::Support::Compression::Gzip::Writer object" do
            expect { |b|
              subject.gzip_stream(string, mode: 'w', &b)
            }.to yield_with_args(Ronin::Support::Compression::Gzip::Writer)
          end
        end
      end

      context "when given mode: 'a'" do
        let(:tempfile) { Tempfile.new('ronin-support') }
        let(:path)     { tempfile.path }

        it "must return a Ronin::Support::Compression::Gzip::Writer object" do
          expect(subject.gzip_stream(string, mode: 'a')).to be_kind_of(Ronin::Support::Compression::Gzip::Writer)
        end

        context "and when a block is given" do
          it "must yield the new Ronin::Support::Compression::Gzip::Writer object" do
            expect { |b|
              subject.gzip_stream(string, mode: 'a', &b)
            }.to yield_with_args(Ronin::Support::Compression::Gzip::Writer)
          end
        end
      end

      context "when given an unknown mode String" do
        let(:mode) { 'x' }

        it do
          expect {
            subject.gzip_stream(string, mode: mode)
          }.to raise_error(ArgumentError,"mode argument must include either 'r', 'w', or 'a': #{mode.inspect}")
        end
      end
    end

    context "when given a StringIO" do
      let(:string_io) { StringIO.new(gzip_data) }

      it "must return a Ronin::Support::Compression::Gzip::Reader object" do
        expect(subject.gzip_stream(string_io)).to be_kind_of(Ronin::Support::Compression::Gzip::Reader)
      end

      context "and when a block is given" do
        it "must yield the new Ronin::Support::Compression::Gzip::Reader object" do
          expect { |b|
            subject.gzip_stream(string_io,&b)
          }.to yield_with_args(Ronin::Support::Compression::Gzip::Reader)
        end
      end

      it "must gzip_stream the String in a StringIO object" do
        gz = subject.gzip_stream(string_io)

        expect(gz.read).to eq(txt_data)
      end

      context "when given mode: 'w'" do
        let(:tempfile) { Tempfile.new('ronin-support') }
        let(:path)     { tempfile.path }

        it "must return a Ronin::Support::Compression::Gzip::Writer object" do
          expect(subject.gzip_stream(string_io, mode: 'w')).to be_kind_of(Ronin::Support::Compression::Gzip::Writer)
        end

        context "and when a block is given" do
          it "must yield the new Ronin::Support::Compression::Gzip::Writer object" do
            expect { |b|
              subject.gzip_stream(string_io, mode: 'w', &b)
            }.to yield_with_args(Ronin::Support::Compression::Gzip::Writer)
          end
        end
      end

      context "when given mode: 'a'" do
        let(:tempfile) { Tempfile.new('ronin-support') }
        let(:path)     { tempfile.path }

        it "must return a Ronin::Support::Compression::Gzip::Writer object" do
          expect(subject.gzip_stream(string_io, mode: 'a')).to be_kind_of(Ronin::Support::Compression::Gzip::Writer)
        end

        context "and when a block is given" do
          it "must yield the new Ronin::Support::Compression::Gzip::Writer object" do
            expect { |b|
              subject.gzip_stream(string_io, mode: 'a', &b)
            }.to yield_with_args(Ronin::Support::Compression::Gzip::Writer)
          end
        end
      end

      context "when given an unknown mode String" do
        let(:mode) { 'x' }

        it do
          expect {
            subject.gzip_stream(string_io, mode: mode)
          }.to raise_error(ArgumentError,"mode argument must include either 'r', 'w', or 'a': #{mode.inspect}")
        end
      end
    end

    context "when given an IO object" do
      let(:io) { File.open(gzip_path,'rb') }

      it "must return a Ronin::Support::Compression::Gzip::Reader object" do
        expect(subject.gzip_stream(io)).to be_kind_of(Ronin::Support::Compression::Gzip::Reader)
      end

      context "and when a block is given" do
        it "must yield the new Ronin::Support::Compression::Gzip::Reader object" do
          expect { |b|
            subject.gzip_stream(io,&b)
          }.to yield_with_args(Ronin::Support::Compression::Gzip::Reader)
        end
      end

      context "when given mode: 'w'" do
        let(:tempfile) { Tempfile.new('ronin-support') }

        it "must return a Ronin::Support::Compression::Gzip::Writer object" do
          expect(subject.gzip_stream(tempfile, mode: 'w')).to be_kind_of(Ronin::Support::Compression::Gzip::Writer)
        end

        context "and when a block is given" do
          let(:io) { File.open(tempfile.path,'w') }

          it "must yield the new Ronin::Support::Compression::Gzip::Writer object" do
            expect { |b|
              subject.gzip_stream(io, mode: 'w', &b)
            }.to yield_with_args(Ronin::Support::Compression::Gzip::Writer)
          end
        end
      end

      context "when given mode: 'a'" do
        let(:tempfile) { Tempfile.new('ronin-support') }
        let(:path)     { tempfile.path }

        it "must return a Ronin::Support::Compression::Gzip::Writer object" do
          expect(subject.gzip_stream(io, mode: 'a')).to be_kind_of(Ronin::Support::Compression::Gzip::Writer)
        end

        context "and when a block is given" do
          let(:io) { File.open(tempfile.path,'w') }

          it "must yield the new Ronin::Support::Compression::Gzip::Writer object" do
            expect { |b|
              subject.gzip_stream(io, mode: 'a', &b)
            }.to yield_with_args(Ronin::Support::Compression::Gzip::Writer)
          end
        end
      end

      context "when given an unknown mode String" do
        let(:mode) { 'x' }

        it do
          expect {
            subject.gzip_stream(io, mode: mode)
          }.to raise_error(ArgumentError,"mode argument must include either 'r', 'w', or 'a': #{mode.inspect}")
        end
      end
    end

    context "when given a Tempfile" do
      let(:tempfile) { Tempfile.new('ronin-support') }

      before do
        tempfile.write(gzip_data)
        tempfile.flush
        tempfile.rewind
      end

      it "must return a Ronin::Support::Compression::Gzip::Reader object" do
        expect(subject.gzip_stream(tempfile)).to be_kind_of(Ronin::Support::Compression::Gzip::Reader)
      end

      context "and when a block is given" do
        it "must yield the new Ronin::Support::Compression::Gzip::Reader object" do
          expect { |b|
            subject.gzip_stream(tempfile,&b)
          }.to yield_with_args(Ronin::Support::Compression::Gzip::Reader)
        end
      end

      it "must gzip_stream the String in a Tempfile object" do
        gz = subject.gzip_stream(tempfile)

        expect(gz.read).to eq(txt_data)
      end

      context "when given mode: 'w'" do
        it "must return a Ronin::Support::Compression::Gzip::Writer object" do
          expect(subject.gzip_stream(tempfile, mode: 'w')).to be_kind_of(Ronin::Support::Compression::Gzip::Writer)
        end

        context "and when a block is given" do
          it "must yield the new Ronin::Support::Compression::Gzip::Writer object" do
            expect { |b|
              subject.gzip_stream(tempfile, mode: 'w', &b)
            }.to yield_with_args(Ronin::Support::Compression::Gzip::Writer)
          end
        end
      end

      context "when given mode: 'a'" do
        it "must return a Ronin::Support::Compression::Gzip::Writer object" do
          expect(subject.gzip_stream(tempfile, mode: 'a')).to be_kind_of(Ronin::Support::Compression::Gzip::Writer)
        end

        context "and when a block is given" do
          it "must yield the new Ronin::Support::Compression::Gzip::Writer object" do
            expect { |b|
              subject.gzip_stream(tempfile, mode: 'a', &b)
            }.to yield_with_args(Ronin::Support::Compression::Gzip::Writer)
          end
        end
      end

      context "when given an unknown mode String" do
        let(:mode) { 'x' }

        it do
          expect {
            subject.gzip_stream(tempfile, mode: mode)
          }.to raise_error(ArgumentError,"mode argument must include either 'r', 'w', or 'a': #{mode.inspect}")
        end
      end
    end
  end

  describe "#gzip_open" do
    let(:path) { gzip_path }

    it "must return a Ronin::Support::Compression::Gzip::Reader object" do
      expect(subject.gzip_open(path)).to be_kind_of(Ronin::Support::Compression::Gzip::Reader)
    end

    context "and when a block is given" do
      it "must yield the new Ronin::Support::Compression::Gzip::Reader object" do
        expect { |b|
          subject.gzip_open(path,&b)
        }.to yield_with_args(Ronin::Support::Compression::Gzip::Reader)
      end
    end

    context "when given mode: 'w'" do
      let(:tempfile) { Tempfile.new('ronin-support') }
      let(:path)     { tempfile.path }

      it "must return a Ronin::Support::Compression::Gzip::Writer object" do
        expect(subject.gzip_open(path, mode: 'w')).to be_kind_of(Ronin::Support::Compression::Gzip::Writer)
      end

      context "and when a block is given" do
        it "must yield the new Ronin::Support::Compression::Gzip::Writer object" do
          expect { |b|
            subject.gzip_open(path, mode: 'w', &b)
          }.to yield_with_args(Ronin::Support::Compression::Gzip::Writer)
        end
      end
    end

    context "when given mode: 'a'" do
      let(:tempfile) { Tempfile.new('ronin-support') }
      let(:path)     { tempfile.path }

      it "must return a Ronin::Support::Compression::Gzip::Writer object" do
        expect(subject.gzip_open(path, mode: 'w')).to be_kind_of(Ronin::Support::Compression::Gzip::Writer)
      end

      context "and when a block is given" do
        it "must yield the new Ronin::Support::Compression::Gzip::Writer object" do
          expect { |b|
            subject.gzip_open(path, mode: 'a', &b)
          }.to yield_with_args(Ronin::Support::Compression::Gzip::Writer)
        end
      end
    end
  end

  describe "#gunzip" do
    let(:path) { gzip_path }

    it "must return a Ronin::Support::Compression::Gzip::Reader object" do
      expect(subject.gunzip(path)).to be_kind_of(Ronin::Support::Compression::Gzip::Reader)
    end

    context "and when a block is given" do
      it "must yield the new Ronin::Support::Compression::Gzip::Reader object" do
        expect { |b|
          subject.gunzip(path,&b)
        }.to yield_with_args(Ronin::Support::Compression::Gzip::Reader)
      end
    end
  end

  describe "#gzip" do
    let(:tempfile) { Tempfile.new('ronin-support') }
    let(:path)     { tempfile.path }

    it "must return a Ronin::Support::Compression::Gzip::Writer object" do
      expect(subject.gzip(path)).to be_kind_of(Ronin::Support::Compression::Gzip::Writer)
    end

    context "and when a block is given" do
      it "must yield the new Ronin::Support::Compression::Gzip::Writer object" do
        expect { |b|
          subject.gzip(path,&b)
        }.to yield_with_args(Ronin::Support::Compression::Gzip::Writer)
      end
    end
  end
end
