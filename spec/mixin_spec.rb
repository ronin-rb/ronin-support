require 'spec_helper'
require 'ronin/mixin'

describe Mixin do
  module Mixins
    module Test1
    end

    module Test2
    end
  end

  module MixinModule
    include Ronin::Mixin

    mixin Mixins::Test1, Mixins::Test2
    mixin { @var = 1 }
  end

  context "when included" do
    subject do
      Class.new.tap do |base|
        base.send :include, MixinModule
      end
    end

    it "should include the mixed in modules" do
      subject.should include(Mixins::Test1)
      subject.should include(Mixins::Test2)
    end

    it "should evaluate the mixin block" do
      subject.instance_variable_get("@var").should == 1
    end
  end

  context "when extended" do
    subject do
      Class.new.tap do |base|
        base.send :extend, MixinModule
      end
    end

    it "should extend the mixed in modules" do
      subject.should be_kind_of(Mixins::Test1)
      subject.should be_kind_of(Mixins::Test2)
    end

    it "should evaluate the mixin block" do
      subject.instance_variable_get("@var").should == 1
    end
  end
end
