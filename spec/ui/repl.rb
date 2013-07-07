require 'spec_helper'
require 'ronin/ui/repl'

describe UI::REPL do
  describe "#start" do
    let(:line) { 'one two three' }

    before do
      Readline.stub(:readline).and_return(line,'exit')
    end

    it "should call the input handler with the shell and input line" do
      lines = []

      described_class.start do |input|
        raise(Interrupt) if input == 'exit'

        lines << input
      end

      lines.should == [line]
    end

    it "should roll back the Readline::HISTORY" do
      Readline::HISTORY << 'previously'

      described_class.start do |input|
        raise(Interrupt) if input == 'exit'
      end

      Readline::HISTORY[0].should == 'previously'
    end
  end
end
