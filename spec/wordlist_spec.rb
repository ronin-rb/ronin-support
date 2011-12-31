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

      wordlist.to_a.should == %w[foo f0o fo0 f00 bar baz]
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
end
