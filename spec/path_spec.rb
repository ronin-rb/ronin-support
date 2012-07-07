require 'spec_helper'
require 'ronin/path'

describe Path do
  subject { described_class }

  let(:n) { 7 }

  it "should inherit from Pathname" do
    subject.superclass.should == Pathname
  end

  describe "#initialize" do
    it "should accept a separator argument" do
      path = described_class.new('foo',"\\")

      path.separator.should == "\\"
    end

    it "should default the separator to File::SEPARATOR" do
      path = described_class.new('foo')

      path.separator.should == File::SEPARATOR
    end
  end

  describe "up" do
    it "should be able to traverse up 0 directories" do
      subject.up(0).should == File::SEPARATOR
    end

    it "should raise an ArgumentError when not passed an Integer or Enumerable" do
      lambda {
        subject.up(1.5)
      }.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError on negative number of directories" do
      lambda {
        subject.up(-1)
      }.should raise_error(ArgumentError)
    end

    it "should create directory-escaping paths" do
      subject.up(n).to_s.should == (['..'] * n).join(File::SEPARATOR)
    end

    it "should create a range of directory-escaping paths" do
      range = 7..10

      subject.up(range).should == range.map { |i| Path.up(i) }
    end

    it "should allow using custom path separators" do
      subject.up(n,'\\').to_s.should == (['..'] * n).join("\\")
    end
  end

  describe "#join" do
    subject { Path.new('base') }

    it "should join with sub-paths" do
      sub_path = File.join('one','two')
      expected = [subject, sub_path].join(File::SEPARATOR)

      subject.join(sub_path).to_s.should == expected
    end

    it "should join with a sub-directory" do
      sub_directory = 'three'
      expected = [subject, sub_directory].join(File::SEPARATOR)

      subject.join(sub_directory).to_s.should == expected
    end

    it "should not collapse directory traversals" do
      traversal = Path.up(n)
      expected = [subject, traversal].join(File::SEPARATOR)

      subject.join(traversal).to_s.should == expected
    end

    it "should filter out extra directory separators" do
      expected = [subject, 'sub'].join(File::SEPARATOR)

      subject.join('/','sub','/').to_s.should == expected
    end

    it "should join with the root path" do
      Path.root.join('etc','passwd').to_s.should == '/etc/passwd'
    end

    context "with a custom path seperator" do
      let(:separator) { "\\" }

      subject { described_class.new('foo',separator) }

      it "should pass the path separator to the new path" do
        new_path = subject.join('bar','baz')

        new_path.separator.should == separator
      end
    end
  end
end
