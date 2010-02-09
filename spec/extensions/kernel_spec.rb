require 'ronin/extensions/kernel'

require 'spec_helper'

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

  describe "catch_all" do
    it "should run a block" do
      var = 1

      catch_all { var += 1 }

      var.should == 2
    end

    it "should catch SyntaxError exceptions" do
      lambda {
        catch_all(false) { raise(SyntaxError,"horrible code",caller) }
      }.should_not raise_error(SyntaxError)
    end

    it "should catch RuntimeError exceptions" do
      lambda {
        catch_all(false) { raise(RuntimeError,"something happened",caller) }
      }.should_not raise_error(RuntimeError)
    end

    it "should catch StandardError exceptions" do
      lambda {
        catch_all(false) { raise(StandardError,"not allowed to do that",caller) }
      }.should_not raise_error(StandardError)
    end
  end

  describe "require_const" do
    before(:all) do
      @directory = File.join('extensions','classes')
    end

    it "should return nil for missing paths" do
      require_const(File.join(@directory,'bla')).should be_nil
    end

    it "should return nil when loading misnamed constants" do
      require_const(File.join(@directory,'misnamed_class')).should be_nil
    end

    it "should not return nil when loading correctly named constants" do
      require_const(File.join(@directory,'a_class')).should_not be_nil
    end
  end

  describe "require_within" do
    before(:all) do
      @directory = File.join('extensions','classes')
    end

    it "should require paths from within a directory" do
      require_within(@directory,'some_class').should_not be_nil
    end

    it "should prevent directory traversal" do
      bad = File.join('..','classes','some_class')

      require_within(@directory,bad).should be_nil
    end
  end
end
