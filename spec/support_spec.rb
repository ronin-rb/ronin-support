require 'spec_helper'
require 'ronin/support'

describe Ronin::Support do
  it "must have a version" do
    expect(subject.const_defined?('VERSION')).to be(true)
  end

  it "must include `Ronin::Support::Network::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::Mixin)
  end

  it "must include `Ronin::Support::CLI::Printing`" do
    expect(subject).to include(Ronin::Support::CLI::Printing)
  end
end
