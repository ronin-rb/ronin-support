require 'spec_helper'
require 'ronin/support/version'

describe Support do
  it "should have a version" do
    expect(subject.const_defined?('VERSION')).to be(true)
  end
end
