require 'spec_helper'
require 'ronin/support/text/random'

describe Ronin::Support::Text::Random do
  let(:string) { "hello" }

  describe ".swapcase" do
    it "must capitalize each character when :probability is 1.0" do
      new_string = subject.swapcase(string, probability: 1.0)

      expect(string.upcase).to eq(new_string)
    end

    it "must not capitalize any characters when :probability is 0.0" do
      new_string = subject.swapcase(string, probability: 0.0)

      expect(string).to eq(new_string)
    end
  end
end
