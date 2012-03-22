require 'spec_helper'
require 'ronin/wordlist'

require 'tempfile'

describe Wordlist do
  let(:words) { %w[foo bar baz] }

  before(:all) do
    Tempfile.open('ronin-support-wordlist') do |file|
      words.each { |word| file.puts word }

      @path = file.path
    end
  end

  subject { described_class.new(words) }

  describe "parse" do
    subject { described_class }

    let(:words) { ('aa'..'zz').to_a }
    let(:text)  {
      words.each_slice(100).map { |w| w.shuffle.join(' ') }.join("\n")
    }

    it "should parse unique words" do
      subject.parse(text).to_a =~ words
    end

    it "should sort the unique words" do
      subject.parse(text).to_a == words.sort
    end

    it "should yield unique words when they are seen" do
      seen = []

      subject.parse(text) { |word| seen << word }

      seen.should =~ words
    end
  end

  describe "create" do
    let(:path) { Tempfile.new('ronin-support-saved-wordlist').path }
    let(:text) { words.join(' ') }

    it "should return the new Wordlist object" do
      wordlist = described_class.create(path,text)

      wordlist.to_a.should =~ words
    end

    it "should create a wordlist file from text" do
      described_class.create(path,text)

      saved_words = File.open(path).each_line.map { |line| line.chomp }

      saved_words.should =~ words
    end

    it "should apply mutations to the created wordlist" do
      described_class.create(path,text, 'o' => ['0'])

      saved_words = File.open(path).each_line.map { |line| line.chomp }

      saved_words.should =~ %w[foo f0o fo0 f00 bar baz]
    end
  end

  describe "#initialize" do
    it "should accept a list of words" do
      subject.to_a.should == words
    end

    it "should accept a path to a wordlist file" do
      file = described_class.new(@path)

      file.to_a.should == words
    end
  end

  describe "#each_word" do
    it "should raise a TypeError for non-String / non-Enumerable objects" do
      wordlist = described_class.new(Object.new)

      lambda {
        wordlist.each_word { |word| }
      }.should raise_error(TypeError)
    end
  end

  describe "#each" do
    it "should rewind file lists" do
      subject.each { |word| }

      subject.to_a.should == words
    end

    it "should apply additional mutation rules" do
      wordlist = described_class.new(words)
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
    let(:path) { Tempfile.new('ronin-support-saved-wordlist').path }

    it "should save the words with mutations to a file" do
      subject.save(path)

      saved_words    = File.open(path).each_line.map { |line| line.chomp }
      expected_words = subject.to_a

      saved_words.should == expected_words
    end
  end
end
