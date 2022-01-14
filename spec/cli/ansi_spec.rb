require 'spec_helper'
require 'ronin/cli/ansi'

describe CLI::ANSI do
  describe "RESET" do
    it { expect(subject::RESET).to eq("\e[0m") }
  end

  describe "BOLD_ON" do
    it { expect(subject::BOLD_ON).to eq("\e[1m") }
  end

  describe "BOLD_OFF" do
    it { expect(subject::BOLD_OFF).to eq("\e[22m") }
  end

  describe "BLACK" do
    it { expect(subject::BLACK).to eq("\e[30m") }
  end

  describe "RED" do
    it { expect(subject::RED).to eq("\e[31m") }
  end

  describe "GREEN" do
    it { expect(subject::GREEN).to eq("\e[32m") }
  end

  describe "YELLOW" do
    it { expect(subject::YELLOW).to eq("\e[33m") }
  end

  describe "BLUE" do
    it { expect(subject::BLUE).to eq("\e[34m") }
  end

  describe "MAGENTA" do
    it { expect(subject::MAGENTA).to eq("\e[35m") }
  end

  describe "CYAN" do
    it { expect(subject::CYAN).to eq("\e[36m") }
  end

  describe "WHITE" do
    it { expect(subject::WHITE).to eq("\e[37m") }
  end

  describe "RESET_COLOR" do
    it { expect(subject::RESET_COLOR).to eq("\e[39m") }
  end

  let(:str) { 'foo' }

  describe ".reset" do
    context "when $stdout is a TTY" do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      it { expect(subject.reset).to eq(described_class::RESET) }
    end

    context "when $stdout is not a TTY" do
      before { $stdout = StringIO.new }

      it { expect(subject.bold).to eq('') }

      after { $stdout = STDOUT }
    end
  end

  describe ".bold" do
    context "when $stdout is a TTY" do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      context "when given a string" do
        it "must wrap the string with \\e[1m and \\e[22m" do
          expect(subject.bold(str)).to eq("\e[1m#{str}\e[22m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.bold).to eq("\e[1m") }
      end
    end

    context "when $stdout is not a TTY" do
      before { $stdout = StringIO.new }

      context "when given a string" do
        it "must return the String" do
          expect(subject.bold(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.bold).to eq('') }
      end

      after { $stdout = STDOUT }
    end
  end

  describe ".black" do
    context "when $stdout is a TTY" do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      context "when given a string" do
        it "must wrap the string with \\e[30m and \\e[39m" do
          expect(subject.black(str)).to eq("\e[30m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.black).to eq("\e[30m") }
      end
    end

    context "when $stdout is not a TTY" do
      before { $stdout = StringIO.new }

      context "when given a string" do
        it "must return the String" do
          expect(subject.black(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.black).to eq('') }
      end

      after { $stdout = STDOUT }
    end
  end

  describe ".red" do
    context "when $stdout is a TTY" do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      context "when given a string" do
        it "must wrap the string with \\e[31m and \\e[39m" do
          expect(subject.red(str)).to eq("\e[31m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.red).to eq("\e[31m") }
      end
    end

    context "when $stdout is not a TTY" do
      before { $stdout = StringIO.new }

      context "when given a string" do
        it "must return the String" do
          expect(subject.red(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.red).to eq('') }
      end

      after { $stdout = STDOUT }
    end
  end

  describe ".green" do
    context "when $stdout is a TTY" do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      context "when given a string" do
        it "must wrap the string with \\e[32m and \\e[39m" do
          expect(subject.green(str)).to eq("\e[32m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.green).to eq("\e[32m") }
      end
    end

    context "when $stdout is not a TTY" do
      before { $stdout = StringIO.new }

      context "when given a string" do
        it "must return the String" do
          expect(subject.green(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.green).to eq('') }
      end

      after { $stdout = STDOUT }
    end
  end

  describe ".yellow" do
    context "when $stdout is a TTY" do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      context "when given a string" do
        it "must wrap the string with \\e[33m and \\e[39m" do
          expect(subject.yellow(str)).to eq("\e[33m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.yellow).to eq("\e[33m") }
      end
    end

    context "when $stdout is not a TTY" do
      before { $stdout = StringIO.new }

      context "when given a string" do
        it "must return the String" do
          expect(subject.yellow(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.yellow).to eq('') }
      end

      after { $stdout = STDOUT }
    end
  end

  describe ".blue" do
    context "when $stdout is a TTY" do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      context "when given a string" do
        it "must wrap the string with \\e[34m and \\e[39m" do
          expect(subject.blue(str)).to eq("\e[34m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.blue).to eq("\e[34m") }
      end
    end

    context "when $stdout is not a TTY" do
      before { $stdout = StringIO.new }

      context "when given a string" do
        it "must return the String" do
          expect(subject.blue(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.blue).to eq('') }
      end

      after { $stdout = STDOUT }
    end
  end

  describe ".magenta" do
    context "when $stdout is a TTY" do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      context "when given a string" do
        it "must wrap the string with \\e[35m and \\e[39m" do
          expect(subject.magenta(str)).to eq("\e[35m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.magenta).to eq("\e[35m") }
      end
    end

    context "when $stdout is not a TTY" do
      before { $stdout = StringIO.new }

      context "when given a string" do
        it "must return the String" do
          expect(subject.magenta(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.magenta).to eq('') }
      end

      after { $stdout = STDOUT }
    end
  end

  describe ".cyan" do
    context "when $stdout is a TTY" do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      context "when given a string" do
        it "must wrap the string with \\e[36m and \\e[39m" do
          expect(subject.cyan(str)).to eq("\e[36m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.cyan).to eq("\e[36m") }
      end
    end

    context "when $stdout is not a TTY" do
      before { $stdout = StringIO.new }

      context "when given a string" do
        it "must return the String" do
          expect(subject.cyan(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.cyan).to eq('') }
      end

      after { $stdout = STDOUT }
    end
  end

  describe ".white" do
    context "when $stdout is a TTY" do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      context "when given a string" do
        it "must wrap the string with \\e[37m and \\e[39m" do
          expect(subject.white(str)).to eq("\e[37m#{str}\e[39m")
        end
      end

      context "when given no arguments" do
        it { expect(subject.white).to eq("\e[37m") }
      end
    end

    context "when $stdout is not a TTY" do
      before { $stdout = StringIO.new }

      context "when given a string" do
        it "must return the String" do
          expect(subject.white(str)).to eq(str)
        end
      end

      context "when given no arguments" do
        it { expect(subject.white).to eq('') }
      end

      after { $stdout = STDOUT }
    end
  end
end
