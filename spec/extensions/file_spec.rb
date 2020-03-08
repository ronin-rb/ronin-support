require 'spec_helper'
require 'ronin/extensions/file'

require 'tempfile'

describe File do
  subject { File }

  it "should provide File.escape_path" do
    expect(subject).to respond_to(:escape_path)
  end

  describe "each_line" do
    let(:lines) { %w[one two three] }

    before(:all) do
      @file = Tempfile.new('ronin-support')
      @file.puts(*lines)
      @file.close
    end

    it "should enumerate over each line in the file" do
      expect(File.each_line(@file.path).to_a).to eq(lines)
    end
  end

  describe "each_row" do
    let(:rows) do
      [
        %w[one two three],
        %w[four five six]
      ]
    end

    let(:separator) { '|' }
    let(:newline)   { "\r\n" }
    let(:lines)     { rows.map { |row| row.join(separator) }.join(newline) }

    before(:all) do
      @file = Tempfile.new('ronin-support')
      @file.write(lines)
      @file.close
    end

    it "should enumerate over each row from each line" do
      expect(File.each_row(@file.path,separator).to_a).to eq(rows)
    end
  end

  describe "escape_path" do
    it "should remove null-bytes" do
      expect(File.escape_path("hello\0world\0")).to eq("helloworld")
    end

    it "should escape home-dir expansions" do
      expect(File.escape_path("hello/~world")).to eq("hello/\\~world")
    end

    it "should remove '.' and '..' directories" do
      expect(File.escape_path("hello/./../world")).to eq("world")
    end
  end
end
