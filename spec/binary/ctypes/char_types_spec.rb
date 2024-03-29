require 'spec_helper'
require 'ronin/support/binary/ctypes/char_types'

describe Ronin::Support::Binary::CTypes::CharTypes do
  describe "CHAR" do
    subject { described_class::CHAR }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::CTypes::CharType)
    end

    it "must have a #pack_string of 'Z'" do
      expect(subject.pack_string).to eq('Z')
    end
  end

  describe "UCHAR" do
    subject { described_class::UCHAR }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::CTypes::CharType)
    end

    it "must have a #pack_string of 'a'" do
      expect(subject.pack_string).to eq('a')
    end
  end

  describe "STRING" do
    subject { described_class::STRING }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::CTypes::StringType)
    end

    it "must have a #pack_string of 'Z*'" do
      expect(subject.pack_string).to eq('Z*')
    end
  end
end
