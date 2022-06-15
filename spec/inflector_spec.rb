require 'spec_helper'
require 'ronin/support/inflector'

describe Ronin::Support::Inflector do
  ascii   = (0..255).map(&:chr)
  alpha   = ('a'..'z').to_a + ('A'..'Z').to_a
  numeric = ('0'..'9').to_a

  describe ".underscore" do
    it "must convert CamelCase to camel_case" do
      expect(subject.underscore('CamelCase')).to eq('camel_case')
    end

    it "must convert camelCase to camel_case" do
      expect(subject.underscore('camelCase')).to eq('camel_case')
    end

    it "must convert Camelcase to camelcase" do
      expect(subject.underscore('Camelcase')).to eq('camelcase')
    end

    it "must convert CAMELCASE to camelcase" do
      expect(subject.underscore('CAMELCASE')).to eq('camelcase')
    end

    it "must convert CAMELCase to camel_case" do
      expect(subject.underscore('CAMELCase')).to eq('camel_case')
    end

    it "must convert CamelCASE to camel_case" do
      expect(subject.underscore('CAMELCase')).to eq('camel_case')
    end

    it "must convert FooBARBaz to foo_bar_baz" do
      expect(subject.underscore('FooBARBaz')).to eq('foo_bar_baz')
    end

    it "must convert foo_bar_baz to foo_bar_baz" do
      expect(subject.underscore('foo_bar_baz')).to eq('foo_bar_baz')
    end

    it "must convert foo___bar___baz to foo___bar___baz" do
      expect(subject.underscore('foo___bar___baz')).to eq('foo___bar___baz')
    end

    it "must convert foo-bar-baz to foo_bar_baz" do
      expect(subject.underscore('foo-bar-baz')).to eq('foo_bar_baz')
    end

    it "must convert foo---bar---baz to foo___bar___baz" do
      expect(subject.underscore('foo---bar---baz')).to eq('foo___bar___baz')
    end

    it "must convert foo_BAR_baz to foo_bar_baz" do
      expect(subject.underscore('foo_BAR_baz')).to eq('foo_bar_baz')
    end

    it "must convert foo-BAR-baz to foo_bar_baz" do
      expect(subject.underscore('foo-BAR-baz')).to eq('foo_bar_baz')
    end

    context "when given a non-String" do
      it "must convert it to a String" do
        expect(subject.underscore(:CamelCase)).to eq('camel_case')
      end
    end

    separators = %w[_ -]

    (ascii - alpha - numeric - separators).each do |char|
      context "when the given String contains a #{char.inspect} character" do
        let(:string) { "Foo#{char}Bar" }

        it do
          expect {
            subject.underscore(string)
          }.to raise_error(ArgumentError,"cannot convert string to underscored: #{string.inspect}")
        end
      end
    end
  end

  describe ".camelcase" do
    context "when given a string with no underscores" do
      it "must capitalize the string" do
        expect(subject.camelcase('foo')).to eq('Foo')
      end
    end

    context "when given a string with underscores" do
      it "must capitalize each word and remove all underscores" do
        expect(subject.camelcase('foo_bar')).to eq('FooBar')
      end
    end

    context "when given a string with dashes" do
      it "must capitalize each word and remove all dashes" do
        expect(subject.camelcase('foo-bar')).to eq('FooBar')
      end
    end

    context "when given a string containing '/' characters" do
      it "must replace the '/' characters with '::' strings" do
        expect(subject.camelcase('foo_bar/baz_quox')).to eq('FooBar::BazQuox')
      end
    end

    context "when given a non-String" do
      it "must convert it to a String" do
        expect(subject.camelcase(:foo_bar)).to eq('FooBar')
      end
    end

    separators = %w[_ - /]

    (ascii - alpha - numeric - separators).each do |char|
      context "when the given String contains a #{char.inspect} character" do
        let(:string) { "foo#{char}bar" }

        it do
          expect {
            subject.camelcase(string)
          }.to raise_error(ArgumentError,"cannot convert string to CamelCase: #{string.inspect}")
        end
      end
    end
  end
end
