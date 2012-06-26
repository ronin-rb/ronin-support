require 'spec_helper'
require 'ronin/network/network'

describe Network do
  it "should determine our public facing IP Address", :network do
    subject.ip.should_not be_nil
  end
end
