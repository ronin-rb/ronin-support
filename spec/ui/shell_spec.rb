require 'spec_helper'
require 'ronin/ui/shell'

require 'ui/classes/test_shell'

describe UI::Shell do
  context "with handler callback" do
    let(:line) { 'one two three' }

    before do
      Readline.stub(:readline).and_return(line,'exit')
    end

    it "should call the input handler with the shell and input line" do
      lines = []

      described_class.start do |input|
        lines << input
      end

      lines.should == [line]
    end
  end

  context "with commands" do
    subject { TestShell.new }

    describe "#commands" do
      it "should include builtin methods" do
        subject.commands.should include('help', 'exit')
      end

      it "should include protected methods" do
        subject.commands.should include(
          'command1',
          'command_with_arg',
          'command_with_args'
        )
      end

      it "should not include public methods" do
        subject.commands.should_not include('a_public_method')
      end
    end

    describe "#run" do
      it "should ignore empty lines" do
        subject.run('').should == false
      end

      it "should ignore white-space lines" do
        subject.run("     \t   ").should == false
      end

      it "should not allow calling the handler method" do
        subject.run('handler').should == false
      end

      it "should not allow calling unknown commands" do
        subject.run('an_unknown_command').should == false
      end

      it "should not allow calling unknown commands" do
        subject.run('an_unknown_command').should == false
      end

      it "should not allow calling public methods" do
        subject.run('a_public_method').should == false
      end

      it "should allow calling protected methods" do
        subject.run('command1').should == :command1
      end

      it "should raise an exception when passing invalid number of arguments" do
        lambda {
          subject.run('command_with_arg too many args')
        }.should raise_error(ArgumentError)
      end

      it "should splat the command arguments to the command method" do
        subject.run('command_with_args one two three').should == [
          'one', 'two', 'three'
        ]
      end
    end
  end
end
