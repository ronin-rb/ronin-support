require 'spec_helper'
require 'ronin/cli/printing'

require 'stringio'

describe CLI::Printing do
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

  describe "#print_info" do
    context "when $stdout is a TTY" do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      it "should print ANSI colour codes" do
        expect($stdout).to receive(:puts).with("#{green}#{bold_on}[-]#{bold_off} #{message}#{reset_color}")

        expect(subject.print_info(message)).to be(true)
      end
    end

    context "when $stdout is not a TTY" do
      before { $stdout = StringIO.new }

      it "should print ANSI colour codes" do
        expect($stdout).to receive(:puts).with("[-] #{message}")

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

        it "should print ANSI colour codes" do
          expect($stdout).to receive(:puts).with("#{cyan}#{bold_on}[?]#{bold_off} #{message}#{reset_color}")

          expect(subject.print_debug(message)).to be(true)
        end
      end

      context "when $stdout is not a TTY" do
        before { $stdout = StringIO.new }

        it "should print ANSI colour codes" do
          expect($stdout).to receive(:puts).with("[?] #{message}")

          expect(subject.print_debug(message)).to be(true)
        end

        after { $stdout = STDOUT }
      end

      after { described_class.debug = false }
    end

    context "when Printing.debug? is false" do
      before { described_class.debug = false }

      it "should return false" do
        expect(subject.print_debug(message)).to be(false)
      end
    end
  end

  describe "#print_warning" do
    context "when $stdout is a TTY" do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      it "should print ANSI colour codes" do
        expect($stdout).to receive(:puts).with("#{yellow}#{bold_on}[*]#{bold_off} #{message}#{reset_color}")

        expect(subject.print_warning(message)).to be(true)
      end
    end

    context "when $stdout is not a TTY" do
      before { $stdout = StringIO.new }

      it "should print ANSI colour codes" do
        expect($stdout).to receive(:puts).with("[*] #{message}")

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

      it "should print ANSI colour codes" do
        expect($stdout).to receive(:puts).with("#{red}#{bold_on}[!]#{bold_off} #{message}#{reset_color}")

        expect(subject.print_error(message)).to be(true)
      end
    end

    context "when $stdout is not a TTY" do
      before { $stdout = StringIO.new }

      it "should print ANSI colour codes" do
        expect($stdout).to receive(:puts).with("[!] #{message}")

        expect(subject.print_error(message)).to be(true)
      end

      after { $stdout = STDOUT }
    end
  end

  describe "#print_success" do
    context "when $stdout is a TTY" do
      before do
        allow($stdout).to receive(:tty?).and_return(true)
      end

      it "should print ANSI colour codes" do
        expect($stdout).to receive(:puts).with("#{white}#{bold_on}[+]#{bold_off} #{message}#{reset_color}")

        expect(subject.print_success(message)).to be(true)
      end
    end

    context "when $stdout is not a TTY" do
      before { $stdout = StringIO.new }

      it "should print ANSI colour codes" do
        expect($stdout).to receive(:puts).with("[+] #{message}")

        expect(subject.print_success(message)).to be(true)
      end

      after { $stdout = STDOUT }
    end
  end
end