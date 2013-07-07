require 'spec_helper'
require 'ronin/ui/repl'

describe UI::REPL do
  describe "#initialize" do
    subject do
      described_class.new { |line| }
    end

    it "should default name to nil" do
      subject.name.should == nil
    end

    it "should default prompt to '>'" do
      subject.prompt.should == '>'
    end

    context "when given options" do
      let(:name)   { 'foo' }
      let(:prompt) { '$'   }

      subject do
        described_class.new(name: name, prompt: prompt) { |line| }
      end

      it "should allow overriding the name" do
        subject.name.should == name
      end

      it "should allow overriding the prompt" do
        subject.prompt.should == prompt
      end
    end

    context "when no block is given" do
      it "should raise an ArgumentError" do
        lambda {
          described_class.new
        }.should raise_error(ArgumentError)
      end
    end
  end

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
