require 'spec_helper'
require 'ronin/support/core_ext/string'

describe String do
  subject { "hello" }

  it "must provide String#random_case" do
    expect(subject).to respond_to(:random_case)
  end

  it "must provide String#insert_before" do
    expect(subject).to respond_to(:insert_before)
  end

  it "must provide String#insert_after" do
    expect(subject).to respond_to(:insert_after)
  end

  describe ".ascii" do
    subject { described_class }

    let(:string) { "hello" }

    it "must return a new String" do
      expect(subject.ascii(string)).to eq(string)
      expect(subject.ascii(string)).to_not be(string)
    end

    it "must set the new String's encoding to Encoding::ASCII_8BIT" do
      expect(subject.ascii(string).encoding).to be(Encoding::ASCII_8BIT)
    end
  end

  describe "#to_ascii" do
    it "must return a new String" do
      expect(subject.to_ascii).to eq(subject)
      expect(subject.to_ascii).to_not be(subject)
    end

    it "must set the new String's encoding to Encoding::ASCII_8BIT" do
      expect(subject.to_ascii.encoding).to be(Encoding::ASCII_8BIT)
    end
  end

  describe "#to_utf8" do
    subject { "hello".encode(Encoding::ASCII_8BIT) }

    it "must return a new String" do
      expect(subject.to_utf8).to eq(subject)
      expect(subject.to_utf8).to_not be(subject)
    end

    it "must set the new String's encoding to Encoding::UTF_8" do
      expect(subject.to_utf8.encoding).to be(Encoding::UTF_8)
    end
  end

  describe "#each_substring" do
    it "must enumerate over each sub-string within the String" do
      subject.each_substring do |sub_string|
        expect(subject).to include(sub_string)
      end
    end

    it "must allow passing the string index back" do
      subject.each_substring do |sub_string,index|
        expect(subject[index,sub_string.length]).to eq(sub_string)

        expect(subject).to include(sub_string)
      end
    end

    it "must enumerate over each sub-string of a minimum length" do
      subject.each_substring(2) do |sub_string|
        expect(sub_string.length).to be >= 2

        expect(subject).to include(sub_string)
      end
    end

    it "must return an Enumerator when no block is given" do
      substrings = subject.each_substring

      expect(substrings.all? { |sub_string|
        subject.include?(sub_string)
      }).to be(true)
    end
  end

  describe "#each_unique_substring" do
    subject { 'abablol' }

    it "must enumerate over each unique sub-string within the String" do
      seen = []

      subject.each_unique_substring do |sub_string|
        expect(subject).to  include(sub_string)
        expect(seen).to_not include(sub_string)

        seen << sub_string
      end
    end

    it "must enumerate over each sub-string of a minimum length" do
      seen = []

      subject.each_unique_substring(2) do |sub_string|
        expect(sub_string.length).to be >= 2

        expect(subject).to  include(sub_string)
        expect(seen).to_not include(sub_string)

        seen << sub_string
      end
    end

    it "must return an Enumerator when no block is given" do
      seen = subject.each_unique_substring

      expect(seen.all? { |sub_string|
        subject.include?(sub_string)
      }).to be(true)

      seen = seen.to_a

      expect(seen.uniq).to eq(seen)
    end
  end

  describe "#common_prefix" do
    it "must find the common prefix between two Strings" do
      one = 'What is puzzling you is the nature of my game'
      two = 'What is puzzling you is the nature of my name'
      common = 'What is puzzling you is the nature of my '

      expect(one.common_prefix(two)).to eq(common)
    end

    it "must return the common prefix between two Strings with no uncommon postfix" do
      one = "1234"
      two = "12345"
      common = "1234"

      expect(one.common_prefix(two)).to eq(common)
    end

    it "must return an empty String if there is no common prefix" do
      one = 'Tell me people'
      two = 'Whats my name'

      expect(one.common_prefix(two)).to eq('')
    end

    it "must return an empty String if one of the strings is also empty" do
      one = 'Haha'
      two = ''

      expect(one.common_prefix(two)).to eq('')
    end
  end

  describe "#common_suffix" do
    it "must find the common postfix between two Strings" do
      one = 'Tell me baby whats my name'
      two = "Can't you guess my name"
      common = 's my name'

      expect(one.common_suffix(two)).to eq(common)
    end

    it "must return an empty String if there is no common postfix" do
      one = 'You got to right up, stand up'
      two = 'stand up for your rights'

      expect(one.common_suffix(two)).to eq('')
    end

    it "must return an empty String if one of the strings is also empty" do
      one = 'You and I must fight for our rights'
      two = ''

      expect(one.common_suffix(two)).to eq('')
    end
  end

  describe "#uncommon_substring" do
    it "must find the uncommon substring between two Strings" do
      one = "Tell me baby whats my name"
      two = "Tell me honey whats my name"
      uncommon = 'bab'

      expect(one.uncommon_substring(two)).to eq(uncommon)
    end

    it "must find the uncommon substring between two Strings with a common prefix" do
      one = 'You and I must fight for our rights'
      two = 'You and I must fight to survive'
      uncommon = 'for our rights'

      expect(one.uncommon_substring(two)).to eq(uncommon)
    end

    it "must find the uncommon substring between two Strings with a common postfix" do
      one = 'Tell me baby whats my name'
      two = "Can't you guess my name"
      uncommon = 'Tell me baby what'

      expect(one.uncommon_substring(two)).to eq(uncommon)
    end
  end

  describe "#random_case" do
    it "must capitalize each character when :probability is 1.0" do
      new_string = subject.random_case(probability: 1.0)

      expect(subject.upcase).to eq(new_string)
    end

    it "must not capitalize any characters when :probability is 0.0" do
      new_string = subject.random_case(probability: 0.0)

      expect(subject).to eq(new_string)
    end
  end

  describe "#insert_before" do
    it "must inject data before a matched String" do
      expect(subject.insert_before('ll','x')).to eq("hexllo")
    end

    it "must inject data before a matched Regexp" do
      expect(subject.insert_before(/l+/,'x')).to eq("hexllo")
    end

    it "must not inject data if no matches are found" do
      expect(subject.insert_before(/x/,'x')).to eq(subject)
    end
  end

  describe "#insert_after" do
    it "must inject data after a matched String" do
      expect(subject.insert_after('ll','x')).to eq("hellxo")
    end

    it "must inject data after a matched Regexp" do
      expect(subject.insert_after(/l+/,'x')).to eq("hellxo")
    end

    it "must not inject data if no matches are found" do
      expect(subject.insert_after(/x/,'x')).to eq(subject)
    end
  end

  describe "#pad" do
    it "must append the padding String until the string is the desired length" do
      expect(subject.pad('A',10)).to eq("helloAAAAA")
    end

    context "when padding String does not evenly divide by the desired length" do
      it "must truncate the last appended copy of the padding String" do
        expect(subject.pad('AB',10)).to eq("helloABABA")
      end
    end
  end
end
