require 'spec_helper'
require 'ronin/support'

describe Ronin::Support do
  it "must have a version" do
    expect(subject.const_defined?('VERSION')).to be(true)
  end

  it "must include `Ronin::Support::Mixin`" do
    expect(subject).to include(Ronin::Support::Mixin)
  end
end
