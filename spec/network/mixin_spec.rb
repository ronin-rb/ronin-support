require 'spec_helper'
require 'ronin/support/network/mixin'

describe Ronin::Support::Network::Mixin do
  it "must include `Ronin::Support::Network::IP::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::IP::Mixin)
  end

  it "must include `Ronin::Support::Network::DNS::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::DNS::Mixin)
  end

  it "must include `Ronin::Support::Network::TCP::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::TCP::Mixin)
  end

  it "must include `Ronin::Support::Network::UDP::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::UDP::Mixin)
  end

  it "must include `Ronin::Support::Network::SSL::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::SSL::Mixin)
  end

  it "must include `Ronin::Support::Network::UNIX::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::UNIX::Mixin)
  end

  it "must include `Ronin::Support::Network::HTTP::Mixin`" do
    expect(subject).to include(Ronin::Support::Network::HTTP::Mixin)
  end
end
