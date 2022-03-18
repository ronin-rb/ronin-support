require 'spec_helper'
require 'ronin/support/binary/types/char_types'

describe Ronin::Support::Binary::Types::CharTypes do
  describe "Char" do
    subject { described_class::Char }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::CharType)
    end

    it "must have a #pack_string of 'Z'" do
      expect(subject.pack_string).to eq('Z')
    end
  end

  describe "UChar" do
    subject { described_class::UChar }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::CharType)
    end

    it "must have a #pack_string of 'a'" do
      expect(subject.pack_string).to eq('a')
    end
  end

  describe "CString" do
    subject { described_class::CString }

    it do
      expect(subject).to be_kind_of(Ronin::Support::Binary::Types::StringType)
    end

    it "must have a #type of Char" do
      expect(subject.type).to be(described_class::Char)
    end
  end
end
