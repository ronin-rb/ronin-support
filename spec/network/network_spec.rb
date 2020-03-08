require 'spec_helper'
require 'ronin/network/network'

describe Network do
  it "should determine our public facing IP Address", :network do
    expect(subject.ip).not_to be_nil
  end
end
