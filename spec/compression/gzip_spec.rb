require 'spec_helper'
require 'ronin/support/compression/gzip'

require 'tempfile'

describe Ronin::Support::Compression::GZip do
  let(:fixtures_dir) { File.join(__dir__,'fixtures') }

  let(:txt_path) { File.join(fixtures_dir,'file.txt') }
  let(:txt_data) { File.read(txt_path)                }

  let(:gzip_path) { File.join(fixtures_dir,'file.gz') }
  let(:gzip_data) { File.binread(gzip_path)           }

  describe "Reader" do
    subject { described_class::Reader }

    it "must equal Zlib::GzipReader" do
      expect(subject).to be(Zlib::GzipReader)
    end
  end

  describe "Writer" do
    subject { described_class::Writer }

    it "must equal Zlib::GzipWriter" do
      expect(subject).to be(Zlib::GzipWriter)
    end
  end

  describe ".wrap" do
    context "when given a String" do
      let(:string) { gzip_data }

      it "must return a Zlib::GzipReader object" do
        expect(subject.wrap(string)).to be_kind_of(Zlib::GzipReader)
      end

      context "and when a block is given" do
        it "must yield the new Zlib::GzipReader object" do
          expect { |b|
            subject.wrap(string,&b)
          }.to yield_with_args(Zlib::GzipReader)
        end
      end

      it "must wrap the String in a StringIO object" do
        gz = subject.wrap(string)

        expect(gz.read).to eq(txt_data)
      end

      context "when given mode: 'w'" do
        let(:tempfile) { Tempfile.new('ronin-support') }
        let(:path)     { tempfile.path }

        it "must return a Zlib::GzipWriter object" do
          expect(subject.wrap(string, mode: 'w')).to be_kind_of(Zlib::GzipWriter)
        end

        context "and when a block is given" do
          it "must yield the new Zlib::GzipWriter object" do
            expect { |b|
              subject.wrap(string, mode: 'w', &b)
            }.to yield_with_args(Zlib::GzipWriter)
          end
        end
      end

      context "when given mode: 'a'" do
        let(:tempfile) { Tempfile.new('ronin-support') }
        let(:path)     { tempfile.path }

        it "must return a Zlib::GzipWriter object" do
          expect(subject.wrap(string, mode: 'a')).to be_kind_of(Zlib::GzipWriter)
        end

        context "and when a block is given" do
          it "must yield the new Zlib::GzipWriter object" do
            expect { |b|
              subject.wrap(string, mode: 'a', &b)
            }.to yield_with_args(Zlib::GzipWriter)
          end
        end
      end

      context "when given an unknown mode String" do
        let(:mode) { 'x' }

        it do
          expect {
            subject.wrap(string, mode: mode)
          }.to raise_error(ArgumentError,"mode argument must include either 'r', 'w', or 'a': #{mode.inspect}")
        end
      end
    end

    context "when given a StringIO" do
      let(:string_io) { StringIO.new(gzip_data) }

      it "must return a Zlib::GzipReader object" do
        expect(subject.wrap(string_io)).to be_kind_of(Zlib::GzipReader)
      end

      context "and when a block is given" do
        it "must yield the new Zlib::GzipReader object" do
          expect { |b|
            subject.wrap(string_io,&b)
          }.to yield_with_args(Zlib::GzipReader)
        end
      end

      it "must wrap the String in a StringIO object" do
        gz = subject.wrap(string_io)

        expect(gz.read).to eq(txt_data)
      end

      context "when given mode: 'w'" do
        let(:tempfile) { Tempfile.new('ronin-support') }
        let(:path)     { tempfile.path }

        it "must return a Zlib::GzipWriter object" do
          expect(subject.wrap(string_io, mode: 'w')).to be_kind_of(Zlib::GzipWriter)
        end

        context "and when a block is given" do
          it "must yield the new Zlib::GzipWriter object" do
            expect { |b|
              subject.wrap(string_io, mode: 'w', &b)
            }.to yield_with_args(Zlib::GzipWriter)
          end
        end
      end

      context "when given mode: 'a'" do
        let(:tempfile) { Tempfile.new('ronin-support') }
        let(:path)     { tempfile.path }

        it "must return a Zlib::GzipWriter object" do
          expect(subject.wrap(string_io, mode: 'a')).to be_kind_of(Zlib::GzipWriter)
        end

        context "and when a block is given" do
          it "must yield the new Zlib::GzipWriter object" do
            expect { |b|
              subject.wrap(string_io, mode: 'a', &b)
            }.to yield_with_args(Zlib::GzipWriter)
          end
        end
      end

      context "when given an unknown mode String" do
        let(:mode) { 'x' }

        it do
          expect {
            subject.wrap(string_io, mode: mode)
          }.to raise_error(ArgumentError,"mode argument must include either 'r', 'w', or 'a': #{mode.inspect}")
        end
      end
    end

    context "when given an IO object" do
      let(:io) { File.open(gzip_path,'rb') }

      it "must return a Zlib::GzipReader object" do
        expect(subject.wrap(io)).to be_kind_of(Zlib::GzipReader)
      end

      context "and when a block is given" do
        it "must yield the new Zlib::GzipReader object" do
          expect { |b|
            subject.wrap(io,&b)
          }.to yield_with_args(Zlib::GzipReader)
        end
      end

      context "when given mode: 'w'" do
        let(:tempfile) { Tempfile.new('ronin-support') }

        it "must return a Zlib::GzipWriter object" do
          expect(subject.wrap(tempfile, mode: 'w')).to be_kind_of(Zlib::GzipWriter)
        end

        context "and when a block is given" do
          let(:io) { File.open(tempfile.path,'w') }

          it "must yield the new Zlib::GzipWriter object" do
            expect { |b|
              subject.wrap(io, mode: 'w', &b)
            }.to yield_with_args(Zlib::GzipWriter)
          end
        end
      end

      context "when given mode: 'a'" do
        let(:tempfile) { Tempfile.new('ronin-support') }
        let(:path)     { tempfile.path }

        it "must return a Zlib::GzipWriter object" do
          expect(subject.wrap(io, mode: 'a')).to be_kind_of(Zlib::GzipWriter)
        end

        context "and when a block is given" do
          let(:io) { File.open(tempfile.path,'w') }

          it "must yield the new Zlib::GzipWriter object" do
            expect { |b|
              subject.wrap(io, mode: 'a', &b)
            }.to yield_with_args(Zlib::GzipWriter)
          end
        end
      end

      context "when given an unknown mode String" do
        let(:mode) { 'x' }

        it do
          expect {
            subject.wrap(io, mode: mode)
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

      it "must return a Zlib::GzipReader object" do
        expect(subject.wrap(tempfile)).to be_kind_of(Zlib::GzipReader)
      end

      context "and when a block is given" do
        it "must yield the new Zlib::GzipReader object" do
          expect { |b|
            subject.wrap(tempfile,&b)
          }.to yield_with_args(Zlib::GzipReader)
        end
      end

      it "must wrap the String in a Tempfile object" do
        gz = subject.wrap(tempfile)

        expect(gz.read).to eq(txt_data)
      end

      context "when given mode: 'w'" do
        it "must return a Zlib::GzipWriter object" do
          expect(subject.wrap(tempfile, mode: 'w')).to be_kind_of(Zlib::GzipWriter)
        end

        context "and when a block is given" do
          it "must yield the new Zlib::GzipWriter object" do
            expect { |b|
              subject.wrap(tempfile, mode: 'w', &b)
            }.to yield_with_args(Zlib::GzipWriter)
          end
        end
      end

      context "when given mode: 'a'" do
        it "must return a Zlib::GzipWriter object" do
          expect(subject.wrap(tempfile, mode: 'a')).to be_kind_of(Zlib::GzipWriter)
        end

        context "and when a block is given" do
          it "must yield the new Zlib::GzipWriter object" do
            expect { |b|
              subject.wrap(tempfile, mode: 'a', &b)
            }.to yield_with_args(Zlib::GzipWriter)
          end
        end
      end

      context "when given an unknown mode String" do
        let(:mode) { 'x' }

        it do
          expect {
            subject.wrap(tempfile, mode: mode)
          }.to raise_error(ArgumentError,"mode argument must include either 'r', 'w', or 'a': #{mode.inspect}")
        end
      end
    end
  end

  describe ".open" do
    let(:path) { gzip_path }

    it "must return a Zlib::GzipReader object" do
      expect(subject.open(path)).to be_kind_of(Zlib::GzipReader)
    end

    context "and when a block is given" do
      it "must yield the new Zlib::GzipReader object" do
        expect { |b|
          subject.open(path,&b)
        }.to yield_with_args(Zlib::GzipReader)
      end
    end

    context "when given mode: 'w'" do
      let(:tempfile) { Tempfile.new('ronin-support') }
      let(:path)     { tempfile.path }

      it "must return a Zlib::GzipWriter object" do
        expect(subject.open(path, mode: 'w')).to be_kind_of(Zlib::GzipWriter)
      end

      context "and when a block is given" do
        it "must yield the new Zlib::GzipWriter object" do
          expect { |b|
            subject.open(path, mode: 'w', &b)
          }.to yield_with_args(Zlib::GzipWriter)
        end
      end
    end

    context "when given mode: 'a'" do
      let(:tempfile) { Tempfile.new('ronin-support') }
      let(:path)     { tempfile.path }

      it "must return a Zlib::GzipWriter object" do
        expect(subject.open(path, mode: 'w')).to be_kind_of(Zlib::GzipWriter)
      end

      context "and when a block is given" do
        it "must yield the new Zlib::GzipWriter object" do
          expect { |b|
            subject.open(path, mode: 'a', &b)
          }.to yield_with_args(Zlib::GzipWriter)
        end
      end
    end
  end
end
