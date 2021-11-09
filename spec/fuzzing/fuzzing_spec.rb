require 'spec_helper'
require 'ronin/fuzzing'

describe Fuzzing do
  describe "[]" do
    let(:method) { :bad_strings }

    it "should return Enumerators for fuzzing methods" do
      expect(subject[method]).to be_kind_of(Enumerable)
    end

    it "should raise NoMethodError for unknown methods" do
      expect {
        subject[:foo]
      }.to raise_error(NoMethodError)
    end

    it "should not allow accessing inherited methods" do
      expect {
        subject[:instance_eval]
      }.to raise_error(NoMethodError)
    end
  end
end
