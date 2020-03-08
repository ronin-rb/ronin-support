require 'spec_helper'
require 'ronin/support/inflector'

describe "Ronin::Support::Inflector" do
  subject { Ronin::Support::Inflector }

  it "should not be nil" do
    expect(subject).not_to be_nil
  end

  it "should support pluralizing words" do
    expect(subject.pluralize('word')).to eq('words')
  end

  it "should support singularizing words" do
    expect(subject.singularize('words')).to eq('word')
  end

  it "should support humanizing words" do
    expect(subject.humanize('word_id')).to eq('Word')
  end
end
