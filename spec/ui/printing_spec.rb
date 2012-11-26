require 'spec_helper'
require 'ronin/ui/printing'

require 'tempfile'

describe UI::Printing do
  before { described_class.normal! }

  describe "mode" do
    it "should be normal by default" do
      should be_normal
    end

    context "when normal" do
      before { subject.normal! }

      it { should_not be_verbose }
      it { should_not be_quiet }
    end

    context "when verbose" do
      before { subject.verbose! }

      it { should_not be_normal }
      it { should_not be_quiet }

      after { subject.normal! }
    end

    context "when quiet" do
      before { subject.quiet! }

      it { should_not be_normal }
      it { should_not be_verbose }

      after { subject.normal! }
    end

    context "when silent" do
      before { subject.silent! }

      it { should_not be_verbose }
      it { should_not be_normal }
      it { should_not be_quiet }

      after { subject.normal! }
    end
  end

  describe "helper methods" do
    subject { Object.new.extend described_class }

    let(:message) { 'foo' }

    let(:green)      { "\e[32m" }
    let(:cyan)       { "\e[36m" }
    let(:yellow)     { "\e[33m" }
    let(:red)        { "\e[31m" }
    let(:bright)     { "\e[1m"  }
    let(:bright_off) { "\e[21m" }
    let(:clear)      { "\e[0m"  }

    describe "#print_info" do
      context "when $stdout is a TTY" do
        it "should print ANSI colour codes" do
          $stdout.should_receive(:puts).with("#{green}#{bright}[-]#{bright_off} #{message}#{clear}")

          subject.print_info(message).should be_true
        end
      end

      context "when $stdout is not a TTY" do
        before { $stdout = Tempfile.new('ronin-printing') }

        it "should print ANSI colour codes" do
          $stdout.should_receive(:puts).with("[-] #{message}")

          subject.print_info(message).should be_true
        end

        after { $stdout = STDOUT }
      end

      context "when quiet" do
        before { described_class.quiet! }

        it "should return false" do
          subject.print_info(message).should be_false
        end

        after { described_class.normal! }
      end

      context "when silent" do
        before { described_class.silent! }

        it "should return false" do
          subject.print_info(message).should be_false
        end

        after { described_class.normal! }
      end
    end

    describe "#print_debug" do
      context "when verbose" do
        before { described_class.verbose! }

        context "when $stdout is a TTY" do
          it "should print ANSI colour codes" do
            $stdout.should_receive(:puts).with("#{cyan}#{bright}[?]#{bright_off} #{message}#{clear}")

            subject.print_debug(message).should be_true
          end
        end

        context "when $stdout is not a TTY" do
          before { $stdout = Tempfile.new('ronin-printing') }

          it "should print ANSI colour codes" do
            $stdout.should_receive(:puts).with("[?] #{message}")

            subject.print_debug(message).should be_true
          end

          after { $stdout = STDOUT }
        end

        after { described_class.normal! }
      end

      context "when not verbose" do
        before { described_class.normal! }

        it "should return false" do
          subject.print_debug(message).should be_false
        end
      end

      context "when silent" do
        before { described_class.silent! }

        it "should return false" do
          subject.print_debug(message).should be_false
        end

        after { described_class.normal! }
      end
    end

    describe "#print_warning" do
      context "when $stdout is a TTY" do
        it "should print ANSI colour codes" do
          $stdout.should_receive(:puts).with("#{yellow}#{bright}[*]#{bright_off} #{message}#{clear}")

          subject.print_warning(message).should be_true
        end
      end

      context "when $stdout is not a TTY" do
        before { $stdout = Tempfile.new('ronin-printing') }

        it "should print ANSI colour codes" do
          $stdout.should_receive(:puts).with("[*] #{message}")

          subject.print_warning(message).should be_true
        end

        after { $stdout = STDOUT }
      end

      context "when quiet" do
        before { described_class.quiet! }

        it "should return false" do
          subject.print_warning(message).should be_false
        end

        after { described_class.normal! }
      end

      context "when silent" do
        before { described_class.silent! }

        it "should return false" do
          subject.print_warning(message).should be_false
        end

        after { described_class.normal! }
      end
    end

    describe "#print_error" do
      context "when $stdout is a TTY" do
        it "should print ANSI colour codes" do
          $stdout.should_receive(:puts).with("#{red}#{bright}[!]#{bright_off} #{message}#{clear}")

          subject.print_error(message).should be_true
        end
      end

      context "when $stdout is not a TTY" do
        before { $stdout = Tempfile.new('ronin-printing') }

        it "should print ANSI colour codes" do
          $stdout.should_receive(:puts).with("[!] #{message}")

          subject.print_error(message).should be_true
        end

        after { $stdout = STDOUT }
      end

      context "when silent" do
        before { described_class.silent! }

        it "should return false" do
          subject.print_error(message).should be_false
        end

        after { described_class.normal! }
      end
    end

    describe "#print_exception" do
      let(:exception_class) { RuntimeError }
      let(:message)         { "error!" }

      let(:backtrace) do
        [
          "/usr/share/ruby/irb/workspace.rb:80:in `eval'",
          "/usr/share/ruby/irb/workspace.rb:80:in `evaluate'",
          "/usr/share/ruby/irb/context.rb:254:in `evaluate'",
          "/usr/share/ruby/irb.rb:159:in `block (2 levels) in eval_input'",
          "/usr/share/ruby/irb.rb:273:in `signal_status'",
          "/usr/share/ruby/irb.rb:156:in `block in eval_input'",
          "/usr/share/ruby/irb/ruby-lex.rb:243:in `block (2 levels) in each_top_level_statement'",
          "/usr/share/ruby/irb/ruby-lex.rb:229:in `loop'",
          "/usr/share/ruby/irb/ruby-lex.rb:229:in `block in each_top_level_statement'",
          "/usr/share/ruby/irb/ruby-lex.rb:228:in `catch'",
          "/usr/share/ruby/irb/ruby-lex.rb:228:in `each_top_level_statement'",
          "/usr/share/ruby/irb.rb:155:in `eval_input'",
          "/usr/share/ruby/irb.rb:70:in `block in start'",
          "/usr/share/ruby/irb.rb:69:in `catch'",
          "/usr/share/ruby/irb.rb:69:in `start'",
          "/usr/bin/irb:12:in `<main>'"
        ]
      end

      let(:exception) do
        begin
          raise(exception_class,message,backtrace)
        rescue => exception
          exception
        end
      end

      it "should print the exception class and message" do
        subject.should_receive(:print_error).with("#{exception_class}: #{message}")

        subject.print_exception(exception)
      end

      context "when verbose" do
        before { described_class.verbose! }

        it "should print the first five lines of the backtrace" do
          subject.should_receive(:print_error).with("#{exception_class}: #{message}")
          subject.should_receive(:print_error).exactly(5).times

          subject.print_exception(exception)
        end

        after { described_class.normal! }
      end
    end
  end

  after { described_class.silent! }
end
