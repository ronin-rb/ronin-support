require 'spec_helper'
require 'ronin/ui/shell'

require 'ui/classes/test_shell'

describe UI::Shell do
  context "with handler callback" do
    let(:line) { 'one two three' }

    it "should call the input handler with the shell and input line" do
      lines = []
      shell = described_class.new { |shell,input| lines << input }

      shell.call(line)

      expect(lines).to eq([line])
    end
  end

  context "with commands" do
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

    describe "#call" do
      it "should ignore empty lines" do
        expect(subject.call('')).to eq(false)
      end

      it "should ignore white-space lines" do
        expect(subject.call("     \t   ")).to eq(false)
      end

      it "should not allow calling the handler method" do
        expect(subject.call('handler')).to eq(false)
      end

      it "should not allow calling unknown commands" do
        expect(subject.call('an_unknown_command')).to eq(false)
      end

      it "should not allow calling unknown commands" do
        expect(subject.call('an_unknown_command')).to eq(false)
      end

      it "should not allow calling public methods" do
        expect(subject.call('a_public_method')).to eq(false)
      end

      it "should allow calling protected methods" do
        expect(subject.call('command1')).to eq(:command1)
      end

      it "should raise an exception when passing invalid number of arguments" do
        expect {
          subject.call('command_with_arg too many args')
        }.to raise_error(ArgumentError)
      end

      it "should splat the command arguments to the command method" do
        expect(subject.call('command_with_args one two three')).to eq([
          'one', 'two', 'three'
        ])
      end
    end
  end
end
