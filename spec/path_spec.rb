require 'spec_helper'
require 'ronin/path'

describe Path do
  let(:n) { 7 }

  it "should inherit from Pathname" do
    Path.superclass.should == Pathname
  end

  it "should provide the root path" do
    path = Path.root

    path.should.class == Path
    path.to_s.should == '/'
  end

  describe "up" do
    subject { Path }

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
    let(:base_path) { Path.new('base') }

    it "should join with sub-paths" do
      sub_path = File.join('one','two')
      expected = [base_path, sub_path].join(File::SEPARATOR)

      base_path.join(sub_path).to_s.should == expected
    end

    it "should join with a sub-directory" do
      sub_directory = 'three'
      expected = [base_path, sub_directory].join(File::SEPARATOR)

      base_path.join(sub_directory).to_s.should == expected
    end

    it "should not collapse directory traversals" do
      traversal = Path.up(n)
      expected = [base_path, traversal].join(File::SEPARATOR)

      base_path.join(traversal).to_s.should == expected
    end

    it "should filter out extra directory separators" do
      expected = [base_path, 'sub'].join(File::SEPARATOR)

      base_path.join('/','sub','/').to_s.should == expected
    end

    it "should join with the root path" do
      Path.root.join('etc','passwd').to_s.should == '/etc/passwd'
    end
  end
end
