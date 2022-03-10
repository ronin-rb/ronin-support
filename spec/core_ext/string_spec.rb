require 'spec_helper'
require 'ronin/support/core_ext/string'

describe String do
  describe "#each_substring" do
    subject { 'hello' }

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
end
