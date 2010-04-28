require 'spec_helper'
require 'ronin/scanner/extensions'

describe Scanner do
  it "should include Scanner into IPAddr" do
    IPAddr.ancestors.should include(Scanner)
  end

  it "should include Scanner into URI::HTTP" do
    URI::HTTP.ancestors.should include(Scanner)
  end
end
