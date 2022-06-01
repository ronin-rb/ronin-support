require 'spec_helper'
require 'ronin/support/archive/zip/reader'

describe Ronin::Support::Archive::Zip::Reader do
  let(:fixtures_dir) { File.join(__dir__,'..','fixtures') }

  let(:txt_path) { File.join(fixtures_dir,'file.txt') }
  let(:txt_data) { File.read(txt_path)                }

  let(:zip_path) { File.join(fixtures_dir,'file.zip') }
  let(:zip_data) { File.binread(zip_path)             }

  describe "#initialize" do
    let(:path) { zip_path }

    subject { described_class.new(path) }

    it "must expand and set #path" do
      expect(subject.path).to eq(File.expand_path(path))
    end

    it "must default #password to nil" do
      expect(subject.password).to be(nil)
    end

    context "when given the password: keyword argument" do
      let(:password) { 'secret' }

      subject { described_class.new(path, password: password) }

      it "it must set #password" do
        expect(subject.password).to eq(password)
      end
    end
  end

  describe ".open" do
    subject { described_class }

    let(:path) { zip_path }

    it "must return a #{described_class} object" do
      expect(subject.open(path)).to be_kind_of(described_class)
    end

    it "must set #path to the given path" do
      zip = subject.open(path)

      expect(zip.path).to eq(File.expand_path(path))
    end

    context "and when a block is given" do
      it "must yield the new #{described_class} object" do
        expect { |b|
          subject.open(path,&b)
        }.to yield_with_args(described_class)
      end
    end
  end

  subject { described_class.new(zip_path) }

  describe "#each" do
    context "when given a block" do
      it "must yield #{described_class}::Entry objects for each entry" do
        yielded_entries = []

        subject.each do |entry|
          yielded_entries << entry
        end

        expect(yielded_entries).to_not be_empty
        expect(yielded_entries).to all(be_kind_of(described_class::Entry))

        expect(yielded_entries[0].length).to eq(11)
        expect(yielded_entries[0].method).to eq(:stored)
        expect(yielded_entries[0].size).to eq(11)
        expect(yielded_entries[0].compression).to eq(0)
        expect(yielded_entries[0].time).to eq(Time.strptime("05-31-2022 03:41 UTC","%m-%d-%Y %H:%M %Z"))
        expect(yielded_entries[0].date).to eq(yielded_entries[0].time.to_date)
        expect(yielded_entries[0].crc32).to eq("f5e69f02")
        expect(yielded_entries[0].name).to eq("aaa.txt")

        expect(yielded_entries[1].length).to eq(12)
        expect(yielded_entries[1].method).to eq(:stored)
        expect(yielded_entries[1].size).to eq(12)
        expect(yielded_entries[1].compression).to eq(0)
        expect(yielded_entries[1].time).to eq(Time.strptime("05-31-2022 06:01 UTC","%m-%d-%Y %H:%M %Z"))
        expect(yielded_entries[1].date).to eq(yielded_entries[1].time.to_date)
        expect(yielded_entries[1].crc32).to eq("af083b2d")
        expect(yielded_entries[1].name).to eq("file.txt")

        expect(yielded_entries[2].length).to eq(11)
        expect(yielded_entries[2].method).to eq(:stored)
        expect(yielded_entries[2].size).to eq(11)
        expect(yielded_entries[2].compression).to eq(0)
        expect(yielded_entries[2].time).to eq(Time.strptime("05-31-2022 03:41 UTC","%m-%d-%Y %H:%M %Z"))
        expect(yielded_entries[2].date).to eq(yielded_entries[2].time.to_date)
        expect(yielded_entries[2].crc32).to eq("f5e69f02")
        expect(yielded_entries[2].name).to eq("zzz.txt")
      end

      it "must return a #{described_class}::Statistics object" do
        statistics = subject.each { |entry| }

        expect(statistics).to be_kind_of(described_class::Statistics)
        expect(statistics.length).to eq(34)
        expect(statistics.size).to eq(34)
        expect(statistics.compression).to eq(0)
        expect(statistics.files).to eq(3)
      end
    end

    context "when no block is given" do
      it "must return an Enumerator for #each" do
        expect(subject.each.to_a).to all(be_kind_of(described_class::Entry))
      end
    end
  end

  describe "#[]" do
    context "when given the name of an entry in the archive" do
      let(:name) { 'file.txt' }

      it "must return the entry with the matching #name" do
        entry = subject[name]

        expect(entry).to_not be(nil)
        expect(entry.name).to eq(name)
      end
    end

    context "when no entry in the tar archive has the matching name" do
      let(:name) { "foo" }

      it "must return nil" do
        expect(subject[name]).to be(nil)
      end
    end
  end

  describe "#read" do
    let(:name) { 'file.txt' }

    it "must read the the full contents of the file within the archive" do
      expect(subject.read(name)).to eq(txt_data)
    end

    context "when the length: keyword argument is given" do
      let(:length) { 3 }

      it "must only read length number of bytes" do
        expect(subject.read(name, length: length)).to eq(txt_data[0,length])
      end
    end

    context "when the zip archive was encrypted" do
      context "and when initialized with the password: keyword argument" do
        let(:zip_path) { File.join(fixtures_dir,'encrypted.zip') }
        let(:password) { 'secret' }

        subject { described_class.new(zip_path, password: password) }

        it "must use the password to decrypt the file's contents" do
          expect(subject.read(name)).to eq(txt_data)
        end
      end
    end
  end

  describe described_class::Entry do
    let(:length)      { 12 }
    let(:method)      { :stored }
    let(:size)        { 12 }
    let(:compression) { 0 }
    let(:time) { Time.strptime("05-30-2022 23:01 UTC","%m-%d-%Y %H:%M %Z") }
    let(:date) { time.to_date }
    let(:crc32) { "af083b2d" }
    let(:name)  { 'file.txt' }

    let(:reader) { Ronin::Support::Archive::Zip::Reader.new(zip_path) }

    subject do
      described_class.new(reader, length: length,
                                  method: method,
                                  size:   size,
                                  compression: compression,
                                  date:  date,
                                  time:  time,
                                  crc32: crc32,
                                  name:  name)
    end

    describe "#initialize" do
      it "must set #length" do
        expect(subject.length).to eq(length)
      end

      it "must set #method" do
        expect(subject.method).to eq(method)
      end

      it "must set #size" do
        expect(subject.size).to eq(size)
      end

      it "must set #compression" do
        expect(subject.compression).to eq(compression)
      end

      it "must set #date" do
        expect(subject.date).to eq(date)
      end

      it "must set #time" do
        expect(subject.time).to eq(time)
      end

      it "must set #crc32" do
        expect(subject.crc32).to eq(crc32)
      end

      it "must set #name" do
        expect(subject.name).to eq(name)
      end
    end

    describe "#read" do
      it "must read the the full contents of the file within the archive" do
        expect(subject.read).to eq(txt_data)
      end

      context "when the length: keyword argument is given" do
        let(:length) { 3 }

        it "must only read length number of bytes" do
          expect(subject.read(length)).to eq(txt_data[0,length])
        end
      end
    end
  end

  describe described_class::Statistics do
    let(:length)      { 34 }
    let(:size)        { 34 }
    let(:compression) { 0  }
    let(:files)       { 3  }

    subject do
      described_class.new(
        length:      length,
        size:        size,
        compression: compression,
        files:       files
      )
    end

    describe "#initialize" do
      it "must set #length" do
        expect(subject.length).to eq(length)
      end

      it "must set #size" do
        expect(subject.size).to eq(size)
      end

      it "must set #compression" do
        expect(subject.compression).to eq(compression)
      end

      it "must set #files" do
        expect(subject.files).to eq(files)
      end
    end
  end
end
