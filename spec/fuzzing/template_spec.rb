require 'spec_helper'
require 'ronin/fuzzing/template'

describe Fuzzing::Template do
  subject { described_class }

  it "should generate Strings from CharSets" do
    strings = subject.new([:lowercase_hexadecimal, :numeric]).to_a

    strings.grep(/^[0-9a-f][0-9]$/).should == strings
  end

  it "should generate Strings from lengths of CharSets" do
    strings = subject.new([[:numeric, 2]]).to_a

    strings.grep(/^[0-9]{2}$/).should == strings
  end

  it "should generate Strings from varying lengths of CharSets" do
    strings = subject.new([[:numeric, 1..2]]).to_a

    strings.grep(/^[0-9]{1,2}$/).should == strings
  end

  it "should generate Strings from custom CharSets" do
    strings = subject.new([[%w[a b c], 2]]).to_a

    strings.grep(/^[abc]{2}$/).should == strings
  end

  it "should generate Strings containing known Strings" do
    strings = subject.new(['foo', [%w[a b c], 2]]).to_a

    strings.grep(/^foo[abc]{2}$/).should == strings
  end

  it "should raise a TypeError for non String, Symbol, Enumerable CharSets" do
    lambda {
      subject.new([[Object.new, 2]]).to_a
    }.should raise_error(TypeError)
  end

  it "should raise an ArgumentError for unknown CharSets" do
    lambda {
      subject.new([[:foo_bar, 2]]).to_a
    }.should raise_error(ArgumentError)
  end

  it "should raise a TypeError for non Integer,Array,Range lengths" do
    lambda {
      subject.new([[:numeric, 'foo']]).to_a
    }.should raise_error(TypeError)
  end
end
