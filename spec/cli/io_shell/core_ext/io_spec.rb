require 'spec_helper'
require 'ronin/support/cli/io_shell/core_ext/io'

require 'stringio'

describe IO do
  subject { File.new(__FILE__) }

  it { expect(subject).to respond_to(:shell) }

  describe "#shell" do
    it do
      expect(Ronin::Support::CLI::IOShell).to receive(:start).with(subject)

      subject.shell
    end
  end
end
