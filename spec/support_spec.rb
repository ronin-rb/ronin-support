require 'spec_helper'
require 'ronin/support'

describe Ronin::Support do
  it "must have a version" do
    expect(subject.const_defined?('VERSION')).to be(true)
  end
end
