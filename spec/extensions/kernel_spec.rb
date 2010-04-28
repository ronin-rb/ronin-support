require 'spec_helper'
require 'ronin/extensions/kernel'

describe Kernel do
  it "should provide Kernel#attempt" do
    Kernel.should respond_to('attempt')
  end

  describe "attempt" do
    it "should return the result of the block if nothing is raised" do
      attempt { 2 + 2 }.should == 4
    end

    it "should return nil if an exception is raised" do
      attempt { 2 + 'a' }.should be_nil
    end

    it "should rescue RuntimeError exceptions" do
      lambda {
        attempt { raise(RuntimeError,"something happened",caller) }
      }.should_not raise_error(RuntimeError)
    end

    it "should rescue StandardError exceptions" do
      lambda {
        attempt { raise(StandardError,"not allowed to do that",caller) }
      }.should_not raise_error(StandardError)
    end
  end
end
