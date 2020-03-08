require 'spec_helper'
require 'ronin/fuzzing/template'

describe Fuzzing::Template do
  subject { described_class }

  it "should generate Strings from CharSets" do
    strings = subject.new([:lowercase_hexadecimal, :numeric]).to_a

    expect(strings.grep(/^[0-9a-f][0-9]$/)).to eq(strings)
  end

  it "should generate Strings from lengths of CharSets" do
    strings = subject.new([[:numeric, 2]]).to_a

    expect(strings.grep(/^[0-9]{2}$/)).to eq(strings)
  end

  it "should generate Strings from varying lengths of CharSets" do
    strings = subject.new([[:numeric, 1..2]]).to_a

    expect(strings.grep(/^[0-9]{1,2}$/)).to eq(strings)
  end

  it "should generate Strings from custom CharSets" do
    strings = subject.new([[%w[a b c], 2]]).to_a

    expect(strings.grep(/^[abc]{2}$/)).to eq(strings)
  end

  it "should generate Strings containing known Strings" do
    strings = subject.new(['foo', [%w[a b c], 2]]).to_a

    expect(strings.grep(/^foo[abc]{2}$/)).to eq(strings)
  end

  it "should raise a TypeError for non String, Symbol, Enumerable CharSets" do
    expect {
      subject.new([[Object.new, 2]]).to_a
    }.to raise_error(TypeError)
  end

  it "should raise an ArgumentError for unknown CharSets" do
    expect {
      subject.new([[:foo_bar, 2]]).to_a
    }.to raise_error(ArgumentError)
  end

  it "should raise a TypeError for non Integer,Array,Range lengths" do
    expect {
      subject.new([[:numeric, 'foo']]).to_a
    }.to raise_error(TypeError)
  end
end
