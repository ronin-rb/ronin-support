require 'spec_helper'
require 'ronin/extensions/file'

require 'tempfile'

describe File do
  subject { described_class }

  it "should provide File.escape_path" do
    subject.should respond_to(:escape_path)
  end

  describe "each_line" do
    before(:all) do
      @lines = %w[one two three]

      @file = Tempfile.new('ronin-support')
      @file.puts(*@lines)
      @file.close
    end

    it "should enumerate over each line in the file" do
      subject.each_line(@file.path).to_a.should == @lines
    end
  end

  describe "each_row" do
    before(:all) do
      @rows = [
        %w[one two three],
        %w[four five six]
      ]

      @separator = '|'
      @newline   = "\r\n"
      @lines     = @rows.map { |row| row.join(@separator) }.join(@newline)

      @file = Tempfile.new('ronin-support')
      @file.write(@lines)
      @file.close
    end

    it "should enumerate over each row from each line" do
      subject.each_row(@file.path,@separator).to_a.should == @rows
    end
  end

  describe "escape_path" do
    it "should remove null-bytes" do
      subject.escape_path("hello\0world\0").should == "helloworld"
    end

    it "should escape home-dir expansions" do
      subject.escape_path("hello/~world").should == "hello/\\~world"
    end

    it "should remove '.' and '..' directories" do
      subject.escape_path("hello/./../world").should == "world"
    end
  end
end
