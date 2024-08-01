require 'spec_helper'
require 'ronin/support/encoding/smtp'

describe "Ronin::Support::Encoding::SMTP" do
  subject { Ronin::Support::Encoding::SMTP }

  it "must be an alias to Ronin::Support::Encoding::QuotedPrintable" do
    expect(subject).to be(Ronin::Support::Encoding::QuotedPrintable)
  end
end
