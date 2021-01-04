require 'spec_helper'
require 'ronin/extensions/kernel'

describe Kernel do
  it "should provide Kernel#try" do
    expect(Kernel).to respond_to('try')
  end

  describe "#try" do
    it "should return the result of the block if nothing is raised" do
      expect(try { 2 + 2 }).to be(4)
    end

    it "should return nil if an exception is raised" do
      expect(try { 2 + 'a' }).to be_nil
    end

    it "should rescue RuntimeError exceptions" do
      expect {
        try { raise(RuntimeError,"something happened",caller) }
      }.not_to raise_error
    end

    it "should rescue StandardError exceptions" do
      expect {
        try { raise(StandardError,"not allowed to do that",caller) }
      }.not_to raise_error
    end
  end
end
