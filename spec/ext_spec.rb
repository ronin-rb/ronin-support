require 'ronin/ext/version'

require 'spec_helper'

describe EXT do
  it "should have a version" do
    EXT.const_defined?('VERSION').should == true
  end
end
