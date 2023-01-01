require 'spec_helper'
require 'ronin/support/text/core_ext/regexp'

describe Regexp do
  it { expect(described_class).to include(Ronin::Support::Text::Patterns) }
end
