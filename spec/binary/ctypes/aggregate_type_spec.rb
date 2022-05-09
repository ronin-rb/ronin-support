require 'spec_helper'
require 'ronin/support/binary/ctypes/aggregate_type'

describe Ronin::Support::Binary::CTypes::AggregateType do
  let(:pack_string) { 'L<10' }

  subject { described_class.new(pack_string: pack_string) }

  describe "#length" do
    it do
      expect {
        subject.length
      }.to raise_error(NotImplementedError,"#{described_class}#length was not implemented")
    end
  end
end
