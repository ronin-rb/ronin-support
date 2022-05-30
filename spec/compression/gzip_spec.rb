require 'spec_helper'
require 'ronin/support/compression/gzip'

require 'tempfile'

describe Ronin::Support::Compression::Gzip do
  let(:fixtures_dir) { File.join(__dir__,'fixtures') }

  let(:txt_path) { File.join(fixtures_dir,'file.txt') }
  let(:txt_data) { File.read(txt_path)                }

  let(:gzip_path) { File.join(fixtures_dir,'file.gz') }
  let(:gzip_data) { File.binread(gzip_path)           }

  describe ".wrap" do
    context "when given a String" do
      let(:string) { gzip_data }

      it "must return a described_class::Reader object" do
        expect(subject.wrap(string)).to be_kind_of(described_class::Reader)
      end

      context "and when a block is given" do
        it "must yield the new described_class::Reader object" do
          expect { |b|
            subject.wrap(string,&b)
          }.to yield_with_args(described_class::Reader)
        end
      end

      it "must wrap the String in a StringIO object" do
        gz = subject.wrap(string)

        expect(gz.read).to eq(txt_data)
      end

      context "when given mode: 'w'" do
        it "must return a described_class::Writer object" do
          expect(subject.wrap(string, mode: 'w')).to be_kind_of(described_class::Writer)
        end

        context "and when a block is given" do
          it "must yield the new described_class::Writer object" do
            expect { |b|
              subject.wrap(string, mode: 'w', &b)
            }.to yield_with_args(described_class::Writer)
          end
        end
      end

      context "when given mode: 'a'" do
        it "must return a described_class::Writer object" do
          expect(subject.wrap(string, mode: 'a')).to be_kind_of(described_class::Writer)
        end

        context "and when a block is given" do
          it "must yield the new described_class::Writer object" do
            expect { |b|
              subject.wrap(string, mode: 'a', &b)
            }.to yield_with_args(described_class::Writer)
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

      it "must return a described_class::Reader object" do
        expect(subject.wrap(string_io)).to be_kind_of(described_class::Reader)
      end

      context "and when a block is given" do
        it "must yield the new described_class::Reader object" do
          expect { |b|
            subject.wrap(string_io,&b)
          }.to yield_with_args(described_class::Reader)
        end
      end

      it "must wrap the String in a StringIO object" do
        gz = subject.wrap(string_io)

        expect(gz.read).to eq(txt_data)
      end

      context "when given mode: 'w'" do
        it "must return a described_class::Writer object" do
          expect(subject.wrap(string_io, mode: 'w')).to be_kind_of(described_class::Writer)
        end

        context "and when a block is given" do
          it "must yield the new described_class::Writer object" do
            expect { |b|
              subject.wrap(string_io, mode: 'w', &b)
            }.to yield_with_args(described_class::Writer)
          end
        end
      end

      context "when given mode: 'a'" do
        it "must return a described_class::Writer object" do
          expect(subject.wrap(string_io, mode: 'a')).to be_kind_of(described_class::Writer)
        end

        context "and when a block is given" do
          it "must yield the new described_class::Writer object" do
            expect { |b|
              subject.wrap(string_io, mode: 'a', &b)
            }.to yield_with_args(described_class::Writer)
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

      it "must return a described_class::Reader object" do
        expect(subject.wrap(io)).to be_kind_of(described_class::Reader)
      end

      context "and when a block is given" do
        it "must yield the new described_class::Reader object" do
          expect { |b|
            subject.wrap(io,&b)
          }.to yield_with_args(described_class::Reader)
        end
      end

      context "when given mode: 'w'" do
        let(:tempfile) { Tempfile.new('ronin-support') }
        let(:path)     { tempfile.path }
        let(:io)       { File.open(path,'wb') }

        it "must return a described_class::Writer object" do
          expect(subject.wrap(io, mode: 'w')).to be_kind_of(described_class::Writer)
        end

        context "and when a block is given" do
          it "must yield the new described_class::Writer object" do
            expect { |b|
              subject.wrap(io, mode: 'w', &b)
            }.to yield_with_args(described_class::Writer)
          end
        end
      end

      context "when given mode: 'a'" do
        let(:tempfile) { Tempfile.new('ronin-support') }
        let(:path)     { tempfile.path }
        let(:io)       { File.open(path,'ab') }

        it "must return a described_class::Writer object" do
          expect(subject.wrap(io, mode: 'a')).to be_kind_of(described_class::Writer)
        end

        context "and when a block is given" do
          it "must yield the new described_class::Writer object" do
            expect { |b|
              subject.wrap(io, mode: 'a', &b)
            }.to yield_with_args(described_class::Writer)
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
  end

  describe ".open" do
    let(:path) { gzip_path }

    it "must return a described_class::Reader object" do
      expect(subject.open(path)).to be_kind_of(described_class::Reader)
    end

    context "and when a block is given" do
      it "must yield the new described_class::Reader object" do
        expect { |b|
          subject.open(path,&b)
        }.to yield_with_args(described_class::Reader)
      end
    end

    context "when given mode: 'w'" do
      let(:tempfile) { Tempfile.new('ronin-support') }
      let(:path)     { tempfile.path }

      it "must return a described_class::Writer object" do
        expect(subject.open(path, mode: 'w')).to be_kind_of(described_class::Writer)
      end

      context "and when a block is given" do
        it "must yield the new described_class::Writer object" do
          expect { |b|
            subject.open(path, mode: 'w', &b)
          }.to yield_with_args(described_class::Writer)
        end
      end
    end

    context "when given mode: 'a'" do
      let(:tempfile) { Tempfile.new('ronin-support') }
      let(:path)     { tempfile.path }

      it "must return a described_class::Writer object" do
        expect(subject.open(path, mode: 'w')).to be_kind_of(described_class::Writer)
      end

      context "and when a block is given" do
        it "must yield the new described_class::Writer object" do
          expect { |b|
            subject.open(path, mode: 'a', &b)
          }.to yield_with_args(described_class::Writer)
        end
      end
    end
  end
end
