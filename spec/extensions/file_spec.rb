require 'spec_helper'
require 'ronin/extensions/file'

describe File do
  subject { File }

  it "should provide File.escape_name" do
    subject.should respond_to(:escape_name)
  end

  describe "escape_filename" do
    it "should remove null-bytes" do
      File.escape_name("hello\0world\0").should == "helloworld"
    end

    it "should escape directory separators" do
      File.escape_name("hello/world").should == "hello\\/world"
    end
  end
end
