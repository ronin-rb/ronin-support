require 'spec_helper'
require 'ronin/ui/shell'

require 'ui/classes/test_shell'

describe UI::Shell do
  subject { TestShell.new }

  describe "#commands" do
    it "should include builtin methods" do
      expect(subject.commands).to include('help', 'exit')
    end

    it "should include protected methods" do
      expect(subject.commands).to include(
        'command1',
        'command_with_arg',
        'command_with_args'
      )
    end

    it "should not include public methods" do
      expect(subject.commands).not_to include('a_public_method')
    end
  end

  describe "#run" do
    it "should ignore empty lines" do
      expect(subject.run('')).to be(false)
    end

    it "should ignore white-space lines" do
      expect(subject.run("     \t   ")).to be(false)
    end

    it "should not allow runing the handler method" do
      expect(subject.run('handler')).to be(false)
    end

    it "should not allow runing unknown commands" do
      expect(subject.run('an_unknown_command')).to be(false)
    end

    it "should not allow runing unknown commands" do
      expect(subject.run('an_unknown_command')).to be(false)
    end

    it "should not allow runing public methods" do
      expect(subject.run('a_public_method')).to be(false)
    end

    it "should allow runing protected methods" do
      expect(subject.run('command1')).to eq(:command1)
    end

    it "should raise an exception when passing invalid number of arguments" do
      expect {
        subject.run('command_with_arg too many args')
      }.to raise_error(ArgumentError)
    end

    it "should splat the command arguments to the command method" do
      expect(subject.run('command_with_args one two three')).to eq([
        'one', 'two', 'three'
      ])
    end
  end
end
