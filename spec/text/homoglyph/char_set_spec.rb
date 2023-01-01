require 'spec_helper'
require 'ronin/support/text/homoglyph/table'

describe Ronin::Support::Text::Homoglyph::Table do
  let(:data_dir) do
    File.join(__dir__,'..','..','..','data','text','homoglyphs')
  end
  let(:path) { File.join(data_dir,'greek.txt') }

  describe "#initialize" do
    subject { described_class.new }

    it "must intialize #table to an empty-Hash" do
      expect(subject.table).to eq({})
    end
  end

  subject { described_class.load_file(path) }

  describe ".load_file" do
    it "must return a #{described_class}" do
      expect(subject).to be_kind_of(described_class)
    end

    it "must parse the file and populate #table" do
      expect(subject.table.map { |char,substitutes|
        "#{char} #{substitutes[0]}"
      }).to eq(File.readlines(path, chomp: true))
    end
  end

  describe "#[]" do
    context "when the character is in #table" do
      it "must return the substitutes for the given character" do
        expect(subject['A']).to eq(["Α"])
      end
    end

    context "when the character is not in #table" do
      it "must return nil" do
        expect(subject['0']).to be(nil)
      end
    end
  end

  describe "#[]=" do
    subject { described_class.new }

    context "when the character is already in #table" do
      before do
        subject['A'] = 'B'
        subject['A'] = 'C'
      end

      it "must append the new substitute to the Array of substitute characters for the character" do
        expect(subject['A']).to eq(['B', 'C'])
      end

      it "must also append the substitute character to #homoeglyphs" do
        expect(subject.homoglyphs[-2..]).to eq(['B', 'C'])
      end
    end

    context "when the character is not yet in #table" do
      before { subject['A'] = 'B' }

      it "must set the #table value to an Array containing the substitute character" do
        expect(subject['A']).to eq(['B'])
      end

      it "must also append the substitute character to #homoeglyphs" do
        expect(subject.homoglyphs[-1]).to eq('B')
      end
    end
  end

  describe "#each" do
    subject { described_class.new }

    before do
      subject['A'] = 'B'
      subject['B'] = 'C'
      subject['B'] = 'D'
      subject['C'] = 'E'
    end

    context "when a block is given" do
      it "must yield each character and substitute character" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(
          ['A', 'B'],
          ['B', 'C'],
          ['B', 'D'],
          ['C', 'E']
        )
      end
    end

    context "when no block is given" do
      it "must return an Enumerator for the #each method" do
        expect(subject.each.to_a).to eq(
          [
            ['A', 'B'],
            ['B', 'C'],
            ['B', 'D'],
            ['C', 'E']
          ]
        )
      end
    end
  end

  describe "#merge" do
    subject { described_class.new }
    let(:other) { described_class.new }

    before do
      subject['A'] = 'B'
      subject['B'] = 'C'
      subject['B'] = 'D'

      other['A'] = 'X'
      other['B'] = 'Y'
      other['B'] = 'Z'
      other['C'] = 'W'
    end

    it "must return a new #{described_class}" do
      expect(subject.merge(other)).to be_kind_of(described_class)
      expect(subject.merge(other)).to_not be(subject)
      expect(subject.merge(other)).to_not be(other)
    end

    it "must merge the keys and values of #table together" do
      expect(subject.merge(other).table).to eq(
        {
          'A' => ['B', 'X'],
          'B' => ['C', 'D', 'Y', 'Z'],
          'C' => ['W']
        }
      )
    end
  end

  let(:word) { 'CEO' }

  describe "#substitute" do
    context "when the given String shares characters in the table" do
      it "must return a random String with one of the characters from the table replaced with one of the substitute characters" do
        expect(subject.substitute(word)).to eq("ϹEO").or(eq('CΕO')).or(eq('CEΟ'))
      end
    end

    context "when the given String does not share characters in the table" do
      subject { described_class.new }

      before do
        subject['A'] = 'X'
      end

      it do
        expect {
          subject.substitute(word)
        }.to raise_error(Ronin::Support::Text::Homoglyph::NotViable,"no homoglyph replaceable characters found in String (#{word.inspect})")
      end
    end
  end

  describe "#each_substitute" do
    context "when the given String shares characters in the table" do
      context "and when given a block" do
        it "must iterate over every possible individual substitution of the String" do
          expect { |b|
            subject.each_substitution(word,&b)
          }.to yield_successive_args("ϹEO", 'CΕO', 'CEΟ')
        end
      end

      context "and when no block is given" do
        it "must return an Enumerator for #each_substition" do
          expect(subject.each_substitution(word).to_a).to eq(
            ["ϹEO", 'CΕO', 'CEΟ']
          )
        end
      end
    end

    context "when the given String does not share characters in the table" do
      subject { described_class.new }

      before do
        subject['A'] = 'X'
      end

      context "and when given a block" do
        it "must not yield any Strings" do
          expect { |b|
            subject.each_substitution(word,&b)
          }.to_not yield_control
        end
      end

      context "and when no block is given" do
        it "must return an Enumerator for #each_substition" do
          expect(subject.each_substitution(word).to_a).to eq([])
        end
      end
    end
  end
end
