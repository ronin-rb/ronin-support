require 'spec_helper'
require 'ronin/extensions/kernel'

describe Kernel do
  it "should provide Kernel#try" do
    Kernel.should respond_to('try')
  end

  describe "#try" do
    it "should return the result of the block if nothing is raised" do
      try { 2 + 2 }.should == 4
    end

    it "should return nil if an exception is raised" do
      try { 2 + 'a' }.should be_nil
    end

    it "should rescue RuntimeError exceptions" do
      lambda {
        try { raise(RuntimeError,"something happened",caller) }
      }.should_not raise_error
    end

    it "should rescue StandardError exceptions" do
      lambda {
        try { raise(StandardError,"not allowed to do that",caller) }
      }.should_not raise_error
    end
  end
end
