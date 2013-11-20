require 'spec_helper'
require 'ronin/fuzzing'

describe Fuzzing do
  describe "[]" do
    let(:method) { :bad_strings }

    it "should return Enumerators for fuzzing methods" do
      subject[method].should be_kind_of(Enumerable)
    end

    it "should raise NoMethodError for unknown methods" do
      lambda {
        subject[:foo]
      }.should raise_error(NoMethodError)
    end

    it "should not allow accessing inherited methods" do
      lambda {
        subject[:instance_eval]
      }.should raise_error(NoMethodError)
    end
  end
end
