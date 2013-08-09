require 'spec_helper'
require 'ronin/wordlist'

require 'tmpdir'

describe Wordlist do
  before(:all) do
    @words = %w[foo bar baz]
    @path  = File.join(Dir.tmpdir,'ronin-support-wordlist')

    File.open(@path,'w') do |file|
      file.puts(*@words)
    end
  end

  subject { described_class.new(@words) }

  describe "parse" do
    subject { described_class }

    before(:all) do
      @words = ('aa'..'zz').to_a
      @text  = @words.each_slice(100).map { |w| w.shuffle.join(' ') }.join("\n")
    end

    it "should parse unique words" do
      subject.parse(@text).to_a =~ @words
    end

    it "should sort the unique words" do
      subject.parse(@text).to_a == @words.sort
    end

    it "should yield unique words when they are seen" do
      seen = []

      subject.parse(@text) { |word| seen << word }

      seen.should =~ @words
    end
  end

  describe "create" do
    before(:all) do
      @text         = @words.join(' ')
      @created_path = File.join(Dir.tmpdir,'ronin-support-created-wordlist')
    end

    it "should return the new Wordlist object" do
      wordlist = described_class.create(@created_path,@text)

      wordlist.to_a.should =~ @words
    end

    it "should create a wordlist file from text" do
      described_class.create(@created_path,@text)

      saved_words = File.open(@created_path).each_line.map(&:chomp)

      saved_words.should =~ @words
    end

    it "should apply mutations to the created wordlist" do
      described_class.create(@created_path,@text, 'o' => ['0'])

      saved_words = File.open(@created_path).each_line.map(&:chomp)

      saved_words.should =~ %w[foo f0o fo0 f00 bar baz]
    end

    after(:all) { FileUtils.rm(@created_path) }
  end

  describe "#initialize" do
    it "should accept a list of words" do
      wordlist = described_class.new(@path)

      wordlist.to_a.should == @words
    end

    it "should accept a path to a wordlist file" do
      wordlist = described_class.new(@path)

      wordlist.to_a.should == @words
    end

    it "should raise a TypeError for non-String / non-Enumerable objects" do
      lambda {
        described_class.new(Object.new)
      }.should raise_error(TypeError)
    end
  end

  describe "#each_word" do
    context "with wordlist file" do
      subject { described_class.new(@path) }

      it "should enumerate over the words" do
        subject.each_word.to_a.should == @words
      end
    end

    context "with words" do
      subject { described_class.new(@words) }

      it "should enumerate over the words" do
        subject.each_word.to_a.should == @words
      end
    end
  end

  describe "#each" do
    it "should rewind file lists" do
      subject.each { |word| }

      subject.to_a.should == @words
    end

    it "should apply additional mutation rules" do
      wordlist = described_class.new(@words)
      wordlist.mutations['o'] = ['0']

      wordlist.to_a.should =~ %w[foo f0o fo0 f00 bar baz]
    end
  end

  describe "#each_n_words" do
    it "should enumerate over every combination of N words" do
      subject.each_n_words(2).to_a.should == %w[
        foofoo foobar foobaz
        barfoo barbar barbaz
        bazfoo bazbar bazbaz
      ]
    end
  end

  describe "#save" do
    before(:all) do
      @saved_path = File.join(Dir.tmpdir,'ronin-support-saved-wordlist')
    end

    it "should save the words with mutations to a file" do
      subject.save(@saved_path)

      saved_words    = File.open(@saved_path).each_line.map(&:chomp)
      expected_words = subject.to_a

      saved_words.should == expected_words
    end

    after(:all) { FileUtils.rm(@saved_path) }
  end

  after(:all) { FileUtils.rm(@path) }
end
