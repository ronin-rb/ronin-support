require 'spec_helper'
require 'ronin/support/binary/types/string_type'

describe Ronin::Support::Binary::Types::StringType do
  it do
    expect(described_class).to be < Ronin::Support::Binary::Types::UnboundedArrayType
  end
end
