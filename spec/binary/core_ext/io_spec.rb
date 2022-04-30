require 'spec_helper'
require 'ronin/support/binary/core_ext/io'

require 'tempfile'
require 'binary/stream/methods_examples'

describe IO do
  it do
    expect(described_class).to include(Ronin::Support::Binary::Stream::Methods)
  end

  let(:buffer)   { String.new }
  let(:tempfile) { Tempfile.new('ronin-support') }
  let(:path)     { tempfile.path }
  let(:io)       { File.open(path,'r+') }

  before { File.binwrite(path,buffer) }

  subject { io }

  include_examples "Ronin::Support::Binary::Stream::Methods examples"
end
