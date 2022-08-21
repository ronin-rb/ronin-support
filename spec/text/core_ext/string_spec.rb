require 'spec_helper'
require 'ronin/support/text/core_ext/string'

describe String do
  subject { "hello" }

  it "must provide String#random_case" do
    expect(subject).to respond_to(:random_case)
  end

  describe "#random_case" do
    it "must capitalize each character when :probability is 1.0" do
      new_string = subject.random_case(probability: 1.0)

      expect(subject.upcase).to eq(new_string)
    end

    it "must not capitalize any characters when :probability is 0.0" do
      new_string = subject.random_case(probability: 0.0)

      expect(subject).to eq(new_string)
    end
  end
end
