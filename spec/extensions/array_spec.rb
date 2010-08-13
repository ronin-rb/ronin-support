require 'spec_helper'
require 'ronin/extensions/array'

describe Array do
  it "should provide Array#power_set" do
    [].should respond_to(:power_set)
  end

  describe "power_set" do
    let(:array) { [1,2,3] }

    subject { array.power_set }

    it "should contain an empty set" do
      should include([])
    end

    it "should contain singleton sets of all the elements" do
      should include([1])
      should include([2])
      should include([3])
    end

    it "should include the sub-sets of the original set" do
      should include([1,2])
      should include([1,3])
      should include([2,3])
    end

    it "should include the original set itself" do
      should include(array)
    end
  end
end
