require 'spec_helper'
require 'ronin/mixin'

module Mixins
  module Test1
  end

  module Test2
  end
end

describe Mixin do
  subject do
    Module.new do
      include Mixin

      mixin Mixins::Test1, Mixins::Test2
      mixin { @var = 1 }
    end
  end

  context "when included" do
    before(:all) do
      @base = Class.new
      @base.send :include, subject
    end

    it "should include the mixed in modules" do
      expect(@base).to include(Mixins::Test1)
      expect(@base).to include(Mixins::Test2)
    end

    it "should evaluate the mixin block" do
      expect(@base.instance_variable_get("@var")).to eq(1)
    end
  end

  context "when extended" do
    before(:all) do
      @base = Object.new
      @base.send :extend, subject
    end

    it "should extend the mixed in modules" do
      expect(@base).to be_kind_of(Mixins::Test1)
      expect(@base).to be_kind_of(Mixins::Test2)
    end

    it "should evaluate the mixin block" do
      expect(@base.instance_variable_get("@var")).to eq(1)
    end
  end
end
