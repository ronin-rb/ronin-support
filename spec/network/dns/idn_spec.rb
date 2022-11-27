require 'spec_helper'
require 'ronin/support/network/dns/idn'

describe "Ronin::Support::Network::DNS::IDN" do
  subject { Ronin::Support::Network::DNS::IDN }

  it "must equal Addressable::IDNA" do
    expect(subject).to be(Addressable::IDNA)
  end
end
