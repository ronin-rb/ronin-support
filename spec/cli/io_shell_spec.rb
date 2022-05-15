require 'spec_helper'
require 'ronin/support/cli/io_shell'

require 'stringio'

describe Ronin::Support::CLI::IOShell do
  let(:io)     { StringIO.new }
  let(:stdin)  { StringIO.new }
  let(:stdout) { StringIO.new }

  subject { described_class.new(io) }

  describe "#initialize" do
    it "must set #io" do
      expect(subject.io).to be(io)
    end

    it "must default #stdin to $stdin" do
      expect(subject.stdin).to be($stdin)
    end

    it "must default #stdout to $stdout" do
      expect(subject.stdout).to be($stdout)
    end

    context "when given the stdin: keyword argument" do
      subject { described_class.new(io, stdin: stdin) }

      it "must set #stdin" do
        expect(subject.stdin).to be(stdin)
      end
    end

    context "when given the stdout: keyword argument" do
      subject { described_class.new(io, stdout: stdout) }

      it "must set #stdout" do
        expect(subject.stdout).to be(stdout)
      end
    end
  end

  describe ".start" do
    subject { described_class }

    let(:kwargs) { {stdin: stdin, stdout: stdout} }
    let(:instance) { double('Ronin::Support::CLI::IOShell') }

    it "must initialize a new instance and call #run" do
      expect(subject).to receive(:new).with(io,**kwargs).and_return(instance)
      expect(instance).to receive(:run)

      subject.start(io,**kwargs)
    end
  end

  describe "#run" do
    subject { described_class.new(io, stdin: stdin, stdout: stdout) }

    let(:io_array) { [io, stdin] }
    let(:data1) { "foo\n" }
    let(:data2) { "bar\n" }

    it "must use IO.select to write IO data to stdout and stdin data to IO" do
      expect(IO).to receive(:select).with(io_array,nil,io_array).and_return(
        [[io], [], []],
        [[stdin], [], []],
        [[stdin], [], []]
      )
      expect(io).to receive(:readpartial).with(4096).and_return(data1)
      expect(stdout).to receive(:write).with(data1)

      expect(stdin).to receive(:readpartial).with(4096).and_return(data2)
      expect(io).to receive(:write).with(data2)

      expect(stdin).to receive(:readpartial).with(4096).and_raise(EOFError.new)

      subject.run
    end

    context "when io.readpartial raises EOFError" do
      it "must return false" do
        expect(IO).to receive(:select).with(io_array,nil,io_array).and_return(
          [[io], [], []]
        )
        expect(io).to receive(:readpartial).with(4096).and_raise(EOFError.new)

        expect(subject.run).to be(false)
      end
    end

    context "when stdin.readpartial raises EOFError" do
      it "must return true" do
        expect(IO).to receive(:select).with(io_array,nil,io_array).and_return(
          [[stdin], [], []]
        )
        expect(stdin).to receive(:readpartial).with(4096).and_raise(EOFError.new)

        expect(subject.run).to be(true)
      end
    end
  end
end
