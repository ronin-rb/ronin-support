require 'spec_helper'
require 'ronin/ext/version'

describe EXT do
  it "should have a version" do
    EXT.const_defined?('VERSION').should == true
  end
end
