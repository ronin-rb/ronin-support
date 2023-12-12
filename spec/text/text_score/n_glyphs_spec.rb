require 'spec_helper'
require 'ronin/support/text/text_score'

describe Ronin::Support::Text do
  describe "NOISE_CONSTANT" do 
    it "must be a negitive constant value" do
      expect(Ronin::Support::Text::NOISE_CONSTANT).to be_a_kind_of(Numeric)
      expect(Ronin::Support::Text::NOISE_CONSTANT).to be < 0
    end
  end
  describe "MONOGLYPH_MAP" do
    it 'must be a hash of the format {glyph(string) => score(numeric), ...}' do
      expect(Ronin::Support::Text::MONOGLYPH_MAP.keys[0]).to be_an_instance_of(String)
      expect(Ronin::Support::Text::MONOGLYPH_MAP.values[0]).to be_a_kind_of(Numeric)
    end
    it "must be a hash of normalized text frequencies ( == 1, but after optimization > 0.8 is acceptable)" do
      expect(Ronin::Support::Text::MONOGLYPH_MAP.values.sum).to be > 0.8
    end
  end
  describe "DIGLYPH_MAP" do
    it 'must be a hash of the format {glyph(string) => score(numeric), ...}' do
      expect(Ronin::Support::Text::DIGLYPH_MAP.keys[0]).to be_an_instance_of(String)
      expect(Ronin::Support::Text::DIGLYPH_MAP.values[0]).to be_a_kind_of(Numeric)
    end
    it "must be a hash of normalized text frequencies ( == 1, but after optimization > 0.8 is acceptable)" do
      expect(Ronin::Support::Text::DIGLYPH_MAP.values.sum).to be > 0.8
    end
  end
  describe "TRIGLYPH_MAP" do
    it 'must be a hash of the format {glyph(string) => score(numeric), ...}' do
      expect(Ronin::Support::Text::TRIGLYPH_MAP.keys[0]).to be_an_instance_of(String)
      expect(Ronin::Support::Text::TRIGLYPH_MAP.values[0]).to be_a_kind_of(Numeric)
    end
    it "must be a hash of normalized text frequencies ( == 1, but after optimization > 0.8 is acceptable)" do
      expect(Ronin::Support::Text::TRIGLYPH_MAP.values.sum).to be > 0.8
    end
  end
end
