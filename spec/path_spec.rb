require 'spec_helper'
require 'ronin/support/path'

describe Ronin::Support::Path do
  subject { described_class }

  let(:n) { 7 }

  it "must inherit from Pathname" do
    expect(subject.superclass).to eq(Pathname)
  end

  describe "#initialize" do
    it "must accept a separator argument" do
      path = described_class.new('foo',"\\")

      expect(path.separator).to eq("\\")
    end

    it "must default the separator to File::SEPARATOR" do
      path = described_class.new('foo')

      expect(path.separator).to eq(File::SEPARATOR)
    end
  end

  describe ".up" do
    it "must be able to traverse up 0 directories" do
      expect(subject.up(0)).to eq(File::SEPARATOR)
    end

    it "must raise an ArgumentError when not passed an Integer or Enumerable" do
      expect {
        subject.up(1.5)
      }.to raise_error(ArgumentError)
    end

    it "must raise an ArgumentError on negative number of directories" do
      expect {
        subject.up(-1)
      }.to raise_error(ArgumentError)
    end

    it "must create directory-escaping paths" do
      expect(subject.up(n).to_s).to eq((['..'] * n).join(File::SEPARATOR))
    end

    it "must create a range of directory-escaping paths" do
      range = 7..10

      expect(subject.up(range)).to eq(range.map { |i| subject.up(i) })
    end

    it "must allow using custom path separators" do
      expect(subject.up(n,'\\').to_s).to eq((['..'] * n).join("\\"))
    end
  end

  describe "#join" do
    subject { described_class.new('base') }

    it "must join with sub-paths" do
      sub_path = File.join('one','two')
      expected = [subject, sub_path].join(File::SEPARATOR)

      expect(subject.join(sub_path).to_s).to eq(expected)
    end

    it "must join with a sub-directory" do
      sub_directory = 'three'
      expected = [subject, sub_directory].join(File::SEPARATOR)

      expect(subject.join(sub_directory).to_s).to eq(expected)
    end

    it "must not collapse directory traversals" do
      traversal = described_class.up(n)
      expected = [subject, traversal].join(File::SEPARATOR)

      expect(subject.join(traversal).to_s).to eq(expected)
    end

    it "must filter out leading directory separators" do
      expected = [subject, 'sub'].join(File::SEPARATOR)

      expect(subject.join('/','sub','/').to_s).to eq(expected)
    end

    it "must filter out extra directory separators" do
      expected = [subject, 'sub'].join(File::SEPARATOR)

      expect(subject.join('/sub').to_s).to eq(expected)
    end

    it "must join with the root path" do
      path = described_class.root.join('etc','passwd')

      expect(path.to_s).to eq('/etc/passwd')
    end

    context "with a custom path seperator" do
      let(:separator) { "\\" }

      subject { described_class.new('foo',separator) }

      it "must pass the path separator to the new path" do
        new_path = subject.join('bar','baz')

        expect(new_path.separator).to eq(separator)
      end
    end
  end
end
