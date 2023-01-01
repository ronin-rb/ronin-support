require 'spec_helper'
require 'ronin/support/core_ext/enumerable'

describe Enumerable do
  describe "#map_hash" do
    it "must map elements to a Hash" do
      expect([1, 2, 3].map_hash { |i| i ** 2 }).to eq({
        1 => 1,
        2 => 4,
        3 => 9
      })
    end

    it "must not map the same element twice" do
      expect([1, 2, 2].map_hash { |i| rand }.keys).to match_array([1, 2])
    end

    it "must set the default_proc of the Hash" do
      hash = [].map_hash { |i| i ** 2 }

      expect(hash[3]).to eq(9)
    end
  end
end
