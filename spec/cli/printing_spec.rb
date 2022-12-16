require 'spec_helper'
require 'ronin/support/cli/printing'

require 'stringio'

describe Ronin::Support::CLI::Printing do
  describe ".debug?" do
    subject { described_class }

    it "must return false by default" do
      expect(subject.debug?).to be(false)
    end

    context "when `Printing.debug = true` is called" do
      before { subject.debug = true }

      it "must return true" do
        expect(subject.debug?).to be(true)
      end

      after { subject.debug = false }
    end
  end

  subject { Object.new.extend described_class }

  let(:message) { 'foo' }

  let(:green)       { "\e[32m" }
  let(:cyan)        { "\e[36m" }
  let(:yellow)      { "\e[33m" }
  let(:red)         { "\e[31m" }
  let(:white)       { "\e[37m" }
  let(:bold_on)     { "\e[1m"  }
  let(:bold_off)    { "\e[22m" }
  let(:reset_color) { "\e[39m" }
  let(:reset)       { "\e[0m"  }

  describe "#debug?" do
    it "must default to false" do
      expect(subject.debug?).to be(false)
    end

    context "when #{described_class}.debug? is true" do
      before { described_class.debug = true }

      it "must return true" do
        expect(subject.debug?).to be(true)
      end

      after { described_class.debug = false }
    end
  end

  describe "#debug=" do
    context "when called with true" do
      before { subject.debug = true }

      it "#debug? must return true" do
        expect(subject.debug?).to be(true)
      end

      it "must not change #{described_class}.debug?" do
        expect(described_class.debug?).to be(false)
      end
    end

    context "when called with false" do
      before do
        subject.debug = true
        subject.debug = false
      end

      it "#debug? must return false" do
        expect(subject.debug?).to be(false)
      end
    end
  end

  describe "#print_info" do
    context "when $stdout is a TTY" do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      it "must print ANSI colour codes" do
        expect($stdout).to receive(:puts).with("#{bold_on}#{white}[*]#{reset_color}#{bold_off} #{message}#{reset}")

        expect(subject.print_info(message)).to be(true)
      end
    end

    context "when $stdout is not a TTY" do
      before { $stdout = StringIO.new }

      it "must print ANSI colour codes" do
        expect($stdout).to receive(:puts).with("[*] #{message}")

        expect(subject.print_info(message)).to be(true)
      end

      after { $stdout = STDOUT }
    end
  end

  describe "#print_debug" do
    context "when Printing.debug? is true" do
      before { described_class.debug = true }

      context "when $stdout is a TTY" do
        before do
          allow($stdout).to receive(:tty?).and_return(true)
        end

        it "must print ANSI colour codes" do
          expect($stdout).to receive(:puts).with("#{bold_on}#{yellow}[?]#{reset_color}#{bold_off} #{message}#{reset}")

          expect(subject.print_debug(message)).to be(true)
        end
      end

      context "when $stdout is not a TTY" do
        before { $stdout = StringIO.new }

        it "must print ANSI colour codes" do
          expect($stdout).to receive(:puts).with("[?] #{message}")

          expect(subject.print_debug(message)).to be(true)
        end

        after { $stdout = STDOUT }
      end

      after { described_class.debug = false }
    end

    context "when Printing.debug? is false" do
      before { described_class.debug = false }

      it "must return false" do
        expect(subject.print_debug(message)).to be(false)
      end
    end
  end

  describe "#print_warning" do
    context "when $stdout is a TTY" do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      it "must print ANSI colour codes" do
        expect($stdout).to receive(:puts).with("#{bold_on}#{yellow}[~]#{reset_color}#{bold_off} #{message}#{reset}")

        expect(subject.print_warning(message)).to be(true)
      end
    end

    context "when $stdout is not a TTY" do
      before { $stdout = StringIO.new }

      it "must print ANSI colour codes" do
        expect($stdout).to receive(:puts).with("[~] #{message}")

        expect(subject.print_warning(message)).to be(true)
      end

      after { $stdout = STDOUT }
    end
  end

  describe "#print_error" do
    context "when $stdout is a TTY" do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      it "must print ANSI colour codes" do
        expect($stdout).to receive(:puts).with("#{bold_on}#{red}[!]#{reset_color}#{bold_off} #{message}#{reset}")

        expect(subject.print_error(message)).to be(true)
      end
    end

    context "when $stdout is not a TTY" do
      before { $stdout = StringIO.new }

      it "must print ANSI colour codes" do
        expect($stdout).to receive(:puts).with("[!] #{message}")

        expect(subject.print_error(message)).to be(true)
      end

      after { $stdout = STDOUT }
    end
  end

  describe "#print_positive" do
    context "when $stdout is a TTY" do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      it "must print ANSI colour codes" do
        expect($stdout).to receive(:puts).with("#{bold_on}#{green}[+]#{reset_color}#{bold_off} #{message}#{reset}")

        expect(subject.print_positive(message)).to be(true)
      end
    end

    context "when $stdout is not a TTY" do
      before { $stdout = StringIO.new }

      it "must print ANSI colour codes" do
        expect($stdout).to receive(:puts).with("[+] #{message}")

        expect(subject.print_positive(message)).to be(true)
      end

      after { $stdout = STDOUT }
    end
  end

  describe "#print_negative" do
    context "when $stdout is a TTY" do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      it "must print ANSI colour codes" do
        expect($stdout).to receive(:puts).with("#{bold_on}#{red}[-]#{reset_color}#{bold_off} #{message}#{reset}")

        expect(subject.print_negative(message)).to be(true)
      end
    end

    context "when $stdout is not a TTY" do
      before { $stdout = StringIO.new }

      it "must print ANSI colour codes" do
        expect($stdout).to receive(:puts).with("[-] #{message}")

        expect(subject.print_negative(message)).to be(true)
      end

      after { $stdout = STDOUT }
    end
  end
end
