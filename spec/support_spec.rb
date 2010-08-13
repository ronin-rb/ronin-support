require 'spec_helper'
require 'ronin/support/version'

describe Support do
  it "should have a version" do
    subject.const_defined?('VERSION').should == true
  end
end
