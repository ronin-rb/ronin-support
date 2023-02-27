require 'spec_helper'
require 'ronin/support/archive/tar'

require 'tempfile'

describe Ronin::Support::Archive::Tar do
  let(:fixtures_dir) { File.join(__dir__,'fixtures') }

  let(:txt_path) { File.join(fixtures_dir,'file.txt') }
  let(:txt_data) { File.read(txt_path)                }

  let(:tar_path) { File.join(fixtures_dir,'file.tar') }
  let(:tar_data) { File.binread(tar_path)             }

  describe ".new" do
    context "when given a String" do
      let(:string) { tar_data }

      it "must return a #{described_class}::Reader object" do
        expect(subject.new(string)).to be_kind_of(described_class::Reader)
      end

      context "and when a block is given" do
        it "must yield the new #{described_class}::Reader object" do
          expect { |b|
            subject.new(string,&b)
          }.to yield_with_args(described_class::Reader)
        end
      end

      it "must new the String in a StringIO object" do
        tar   = subject.new(string)
        file  = tar.find { |entry| entry.full_name == 'file.txt' }

        expect(file.read).to eq(txt_data)
      end

      context "when given mode: 'w'" do
        it "must return a #{described_class}::Writer object" do
          expect(subject.new(string, mode: 'w')).to be_kind_of(described_class::Writer)
        end

        context "and when a block is given" do
          it "must yield the new #{described_class}::Writer object" do
            expect { |b|
              subject.new(string, mode: 'w', &b)
            }.to yield_with_args(described_class::Writer)
          end
        end
      end

      context "when given mode: 'a'" do
        it "must return a #{described_class}::Writer object" do
          expect(subject.new(string, mode: 'a')).to be_kind_of(described_class::Writer)
        end

        context "and when a block is given" do
          it "must yield the new #{described_class}::Writer object" do
            expect { |b|
              subject.new(string, mode: 'a', &b)
            }.to yield_with_args(described_class::Writer)
          end
        end
      end

      context "when given an unknown mode String" do
        let(:mode) { 'x' }

        it do
          expect {
            subject.new(string, mode: mode)
          }.to raise_error(ArgumentError,"mode argument must include either 'r', 'w', or 'a': #{mode.inspect}")
        end
      end
    end

    context "when given a StringIO" do
      let(:string_io) { StringIO.new(tar_data) }

      it "must return a #{described_class}::Reader object" do
        expect(subject.new(string_io)).to be_kind_of(described_class::Reader)
      end

      context "and when a block is given" do
        it "must yield the new #{described_class}::Reader object" do
          expect { |b|
            subject.new(string_io,&b)
          }.to yield_with_args(described_class::Reader)
        end
      end

      it "must new the String in a StringIO object" do
        tar   = subject.new(string_io)
        file  = tar.find { |entry| entry.full_name == 'file.txt' }

        expect(file.read).to eq(txt_data)
      end

      context "when given mode: 'w'" do
        it "must return a #{described_class}::Writer object" do
          expect(subject.new(string_io, mode: 'w')).to be_kind_of(described_class::Writer)
        end

        context "and when a block is given" do
          it "must yield the new #{described_class}::Writer object" do
            expect { |b|
              subject.new(string_io, mode: 'w', &b)
            }.to yield_with_args(described_class::Writer)
          end
        end
      end

      context "when given mode: 'a'" do
        it "must return a #{described_class}::Writer object" do
          expect(subject.new(string_io, mode: 'a')).to be_kind_of(described_class::Writer)
        end

        context "and when a block is given" do
          it "must yield the new #{described_class}::Writer object" do
            expect { |b|
              subject.new(string_io, mode: 'a', &b)
            }.to yield_with_args(described_class::Writer)
          end
        end
      end

      context "when given an unknown mode String" do
        let(:mode) { 'x' }

        it do
          expect {
            subject.new(string_io, mode: mode)
          }.to raise_error(ArgumentError,"mode argument must include either 'r', 'w', or 'a': #{mode.inspect}")
        end
      end
    end

    context "when given an IO object" do
      let(:io) { File.open(tar_path,'rb') }

      it "must return a #{described_class}::Reader object" do
        expect(subject.new(io)).to be_kind_of(described_class::Reader)
      end

      context "and when a block is given" do
        it "must yield the new #{described_class}::Reader object" do
          expect { |b|
            subject.new(io,&b)
          }.to yield_with_args(described_class::Reader)
        end
      end

      context "when given mode: 'w'" do
        let(:tempfile) { Tempfile.new('ronin-support') }
        let(:path)     { tempfile.path }
        let(:io)       { File.open(path,'wb') }

        it "must return a #{described_class}::Writer object" do
          expect(subject.new(io, mode: 'w')).to be_kind_of(described_class::Writer)
        end

        context "and when a block is given" do
          it "must yield the new #{described_class}::Writer object" do
            expect { |b|
              subject.new(io, mode: 'w', &b)
            }.to yield_with_args(described_class::Writer)
          end
        end
      end

      context "when given mode: 'a'" do
        let(:tempfile) { Tempfile.new('ronin-support') }
        let(:path)     { tempfile.path }
        let(:io)       { File.open(path,'ab') }

        it "must return a #{described_class}::Writer object" do
          expect(subject.new(io, mode: 'a')).to be_kind_of(described_class::Writer)
        end

        context "and when a block is given" do
          it "must yield the new #{described_class}::Writer object" do
            expect { |b|
              subject.new(io, mode: 'a', &b)
            }.to yield_with_args(described_class::Writer)
          end
        end
      end

      context "when given an unknown mode String" do
        let(:mode) { 'x' }

        it do
          expect {
            subject.new(io, mode: mode)
          }.to raise_error(ArgumentError,"mode argument must include either 'r', 'w', or 'a': #{mode.inspect}")
        end
      end
    end
  end

  describe ".open" do
    let(:path) { tar_path }

    it "must return a #{described_class}::Reader object" do
      expect(subject.open(path)).to be_kind_of(described_class::Reader)
    end

    it "must read tar data from the given path" do
      tar = subject.open(path)

      tar.seek('file.txt') do |entry|
        expect(entry.full_name).to eq('file.txt')
        expect(entry.read).to eq(txt_data)
      end
    end

    context "and when a block is given" do
      it "must yield the new #{described_class}::Reader object" do
        expect { |b|
          subject.open(path,&b)
        }.to yield_with_args(described_class::Reader)
      end
    end

    context "when given mode: 'w'" do
      let(:tempfile) { Tempfile.new('ronin-support') }
      let(:path)     { tempfile.path }

      it "must return a #{described_class}::Writer object" do
        expect(subject.open(path, mode: 'w')).to be_kind_of(described_class::Writer)
      end

      it "must write tar data to the given path" do
        tar = subject.open(path, mode: 'w')
        tar.add_file('file.txt',txt_data)
        tar.close

        tar = Gem::Package::TarReader.new(File.open(path))
        tar.seek('file.txt') do |entry|
          expect(entry.full_name).to eq('file.txt')
          expect(entry.read).to eq(txt_data)
        end
      end

      context "and when a block is given" do
        it "must yield the new #{described_class}::Writer object" do
          expect { |b|
            subject.open(path, mode: 'w', &b)
          }.to yield_with_args(described_class::Writer)
        end
      end
    end

    context "when given mode: 'a'" do
      let(:tempfile) { Tempfile.new('ronin-support') }
      let(:path)     { tempfile.path }

      it "must return a #{described_class}::Writer object" do
        expect(subject.open(path, mode: 'w')).to be_kind_of(described_class::Writer)
      end

      it "must write tar data to the given path" do
        tar = subject.open(path, mode: 'w')
        tar.add_file('file.txt',txt_data)

        tar   = subject.open(path)
        tar.seek('file.txt') do |entry|
          expect(entry.full_name).to eq('file.txt')
          expect(entry.read).to eq(txt_data)
        end
      end

      context "and when a block is given" do
        it "must yield the new #{described_class}::Writer object" do
          expect { |b|
            subject.open(path, mode: 'a', &b)
          }.to yield_with_args(described_class::Writer)
        end
      end
    end
  end
end
