require 'spec_helper'
require 'ronin/support/text/mixin'

describe Ronin::Support::Text::Mixin do
  it "must include `Ronin::Support::Text::Random::Mixin`" do
    expect(subject).to include(Ronin::Support::Text::Random::Mixin)
  end

  it "must include `Ronin::Support::Text::ERB::Mixin`" do
    expect(subject).to include(Ronin::Support::Text::ERB::Mixin)
  end
end
