require 'spec_helper'
require 'ronin/support/core_ext/enumerable'

describe Enumerable do
  describe "#map_hash" do
    it "must map elements to a Hash" do
      new_hash = [1, 2, 3].map_hash { |i| i**2 }

      expect(new_hash).to eq(
        {
          1 => 1,
          2 => 4,
          3 => 9
        }
      )
    end

    it "must not map the same element twice" do
      new_hash = [1, 2, 2].map_hash { |i| rand }

      expect(new_hash.keys).to match_array([1, 2])
    end

    it "must set the default_proc of the Hash" do
      new_hash = [].map_hash { |i| i**2 }

      expect(new_hash[3]).to eq(9)
    end
  end
end
