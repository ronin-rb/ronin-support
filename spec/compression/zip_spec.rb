require 'spec_helper'
require 'ronin/support/compression/zip'

require 'tempfile'

describe Ronin::Support::Compression::Zip do
  let(:fixtures_dir) { File.join(__dir__,'fixtures') }

  let(:txt_path) { File.join(fixtures_dir,'file.txt') }
  let(:txt_data) { File.read(txt_path)                }

  let(:zip_path) { File.join(fixtures_dir,'file.zip') }

  describe ".new" do
    let(:path) { zip_path }

    it "must return a #{described_class}::Reader object" do
      expect(subject.new(path)).to be_kind_of(described_class::Reader)
    end

    context "and when a block is given" do
      it "must yield the new #{described_class}::Reader object" do
        expect { |b|
          subject.new(path,&b)
        }.to yield_with_args(described_class::Reader)
      end
    end

    context "when given mode: 'w'" do
      it "must return a #{described_class}::Writer object" do
        expect(subject.new(path, mode: 'w')).to be_kind_of(described_class::Writer)
      end

      context "and when a block is given" do
        it "must yield the new #{described_class}::Writer object" do
          expect { |b|
            subject.new(path, mode: 'w', &b)
          }.to yield_with_args(described_class::Writer)
        end
      end
    end

    context "when given mode: 'a'" do
      it "must return a #{described_class}::Writer object" do
        expect(subject.new(path, mode: 'a')).to be_kind_of(described_class::Writer)
      end

      context "and when a block is given" do
        it "must yield the new #{described_class}::Writer object" do
          expect { |b|
            subject.new(path, mode: 'a', &b)
          }.to yield_with_args(described_class::Writer)
        end
      end
    end

    context "when given an unknown mode String" do
      let(:mode) { 'x' }

      it do
        expect {
          subject.new(path, mode: mode)
        }.to raise_error(ArgumentError,"mode argument must include either 'r', 'w', or 'a': #{mode.inspect}")
      end
    end
  end

  describe ".open" do
    let(:path) { zip_path }

    it "must return a #{described_class}::Reader object" do
      expect(subject.open(path)).to be_kind_of(described_class::Reader)
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
