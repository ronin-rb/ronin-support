require 'spec_helper'
require 'ronin/support/core_ext/integer'

describe Integer do
  subject { 0x41 }

  it "must alias char to the #chr method" do
    expect(subject.char).to eq(subject.chr)
  end
end
