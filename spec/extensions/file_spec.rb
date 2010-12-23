require 'spec_helper'
require 'ronin/extensions/file'

describe File do
  subject { File }

  it "should provide File.escape_path" do
    subject.should respond_to(:escape_path)
  end

  describe "escape_path" do
    it "should remove null-bytes" do
      File.escape_path("hello\0world\0").should == "helloworld"
    end

    it "should escape home-dir expansions" do
      File.escape_path("hello/~world").should == "hello/\\~world"
    end

    it "should remove '.' and '..' directories" do
      File.escape_path("hello/./../world").should == "world"
    end
  end
end
