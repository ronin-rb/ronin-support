require 'spec_helper'
require 'ronin/extensions/uri'

describe URI::HTTP do
  it "should include QueryParams" do
    URI::HTTP.should include(URI::QueryParams)
  end
end
