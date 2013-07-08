require 'spec_helper'
require 'ronin/ui/repl'

describe UI::REPL do
  subject do
    described_class.new { |line| }
  end

  describe "#initialize" do
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

  describe "#readline" do
    it "should map Interrupts to nil" do
      Readline.stub(:readline).and_raise(Interrupt)

      subject.readline.should be_nil
    end
  end

  describe "#completion" do
    before { Readline::HISTORY.clear }

    before do
      Readline::HISTORY << 'foo'
      Readline::HISTORY << 'bar'
      Readline::HISTORY << 'fox'
    end

    it "should recommend completions based on Readline::HISTORY" do
      subject.complete('fo').should == %w[foo fox]
    end

    after { Readline::HISTORY.clear }
  end

  describe "#start" do
    let(:input) { %w[one two three] }

    before do
      Readline.stub(:readline).and_return(*input,nil)
    end

    it "should call the input handler with the shell and input line" do
      lines = described_class.start { |line| }

      lines.should == input
    end

    context "when the handler raises Interrupt" do
      subject do
        described_class.new do |line|
          raise(Interrupt) if line == input[1]
        end
      end

      it "should stop if the handler raises an Interrupt" do
        lines = subject.start

        lines.should == input[0..1]
      end
    end

    it "should not add duplicate lines to Readline::HISTORY" do
      Readline.stub(:readline).and_return('foo','bar','bar','foo',nil)

      lines = subject.start { |line| }

      lines.should == %w[foo bar foo]
    end

    it "should roll back the Readline::HISTORY" do
      Readline::HISTORY << 'previously'

      subject.start

      Readline::HISTORY[0].should == 'previously'
    end
  end
end
