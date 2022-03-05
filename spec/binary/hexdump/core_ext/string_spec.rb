require 'spec_helper'
require 'ronin/support/binary/hexdump/core_ext/string'

describe String do
  it "should provide String#unhexdump" do
    expect(subject).to respond_to(:unhexdump)
  end

  describe "#unhexdump" do
    subject { "00000000  23 20 52 6f 6e 69 6e 20  53 75 70 70 6f 72 74 0a  |# Ronin Support.|\n00000010\n" }

    let(:raw) { "# Ronin Support\n" }

    it "should unhexdump a String" do
      expect(subject.unhexdump).to eq(raw)
    end
  end
end
