require 'spec_helper'
require 'matchers/fully_match'
require 'ronin/support/text/patterns/source_code'

describe Ronin::Support::Text::Patterns do
  describe "IDENTIFIER" do
    subject { described_class::IDENTIFIER }

    it "must match Strings beginning with a '_' character" do
      identifier = '_foo'

      expect(identifier).to fully_match(subject)
    end

    it "must match Strings ending with a '_' character" do
      identifier = 'foo_'

      expect(identifier).to fully_match(subject)
    end

    it "must not match Strings beginning with numberic characters" do
      expect(subject.match('1234foo')[0]).to eq('foo')
    end

    it "must not match Strings not containing any alpha characters" do
      identifier = '_1234_'

      expect(identifier).to_not match(subject)
    end
  end

  describe "VARIABLE_NAME" do
    subject { described_class::VARIABLE_NAME }

    let(:name) { "foo" }

    it "must match identifiers followed by a '=' character" do
      string = "#{name}=1"

      expect(subject.match(string)[0]).to eq(name)
    end

    it "must match identifiers followed by a space then a '=' character" do
      string = "#{name} = 1"

      expect(subject.match(string)[0]).to eq(name)
    end

    it "must not match identifiers not followed by a '=' character" do
      string = name

      expect(string).to_not match(subject)
    end
  end

  describe "VARIABLE_ASSIGNMENT" do
    subject { described_class::VARIABLE_ASSIGNMENT }

    it "must match identifiers followed by a '=' character" do
      string = "foo=1"

      expect(string).to fully_match(subject)
    end

    it "must match identifiers followed by a space then a '=' character" do
      string = "foo = 1"

      expect(string).to fully_match(subject)
    end

    it "must not match identifiers not followed by a '=' character" do
      string = "foo"

      expect(string).to_not match(subject)
    end
  end

  describe "FUNCTION_NAME" do
    subject { described_class::FUNCTION_NAME }

    it "must match identifiers that are followed by an opening parenthesis" do
      name   = "foo"
      string = "#{name}("

      expect(subject.match(string)[0]).to eq(name)
    end

    it "must not match an identifier name without parenthesis following it" do
      string = "foo"

      expect(string).to_not match(subject)
    end
  end

  describe "DOUBLE_QUOTED_STRING" do
    subject { described_class::DOUBLE_QUOTED_STRING }

    it "must not match non-quoted text" do
      string = "foo"

      expect(string).to_not match(subject)
    end

    it "must match double-quoted text" do
      string = "\"foo\""

      expect(string).to fully_match(subject)
    end

    it "must match double-quoted text containing backslash-escaped chars" do
      string = "\"foo\\\"bar\\\"baz\\0\""

      expect(string).to fully_match(subject)
    end
  end

  describe "SINGLE_QUOTED_STRING" do
    subject { described_class::SINGLE_QUOTED_STRING }

    it "must not match non-quoted text" do
      string = "foo"

      expect(string).to_not match(subject)
    end

    it "must match single-quoted text" do
      string = "'foo'"

      expect(string).to fully_match(subject)
    end

    it "must match single-quoted text containing backslash-escaped chars" do
      string = "'foo\\bar\\''"

      expect(string).to fully_match(subject)
    end
  end

  describe "STRING" do
    subject { described_class::STRING }

    it "must not match non-quoted text" do
      string = "foo"

      expect(string).to_not match(subject)
    end

    it "must match double-quoted text" do
      string = "\"foo\""

      expect(string).to fully_match(subject)
    end

    it "must match double-quoted text containing backslash-escaped chars" do
      string = "\"foo\\\"bar\\\"baz\\0\""

      expect(string).to fully_match(subject)
    end

    it "must match single-quoted text" do
      string = "'foo'"

      expect(string).to fully_match(subject)
    end

    it "must match single-quoted text containing backslash-escaped chars" do
      string = "'foo\\bar\\''"

      expect(string).to fully_match(subject)
    end
  end

  describe "BASE64" do
    subject { described_class::BASE64 }

    it "must not match alphabetic strings less then four characters long" do
      string = "YWE"

      expect(string).to_not match(subject)
    end

    it "must match alphabetic strings padded with '=' characters" do
      string = "YQ=="

      expect(string).to fully_match(subject)
    end

    it "must match alphabetic strings with four characters exactly" do
      string = "YWFh"

      expect(string).to fully_match(subject)
    end

    it "must match alphabetic strings longer than four characters but padded with '=' characters" do
      string = "YWFhYQ=="

      expect(string).to fully_match(subject)
    end

    it "must match alphabetic strings that include newline characters" do
      string = "QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB\nQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB\nQUFBQUFBQUFBQQ==\n"

      expect(string).to fully_match(subject)
    end
  end

  shared_examples_for "C-style comments" do
    it "must match a single-line // comment" do
      string = "// comment"

      expect(string).to fully_match(subject)
    end

    it "must match a single-line // comment that does end with a new-line" do
      string = "// comment\n"

      expect(string).to fully_match(subject)
    end

    it "must match multiple // comments in a row" do
      string = <<~TEXT.chomp
        // comment 1
        // comment 2
        // comment 3
      TEXT

      expect(string).to fully_match(subject)
    end

    it "must match multiple // comments in a row, that ends with a new-line" do
      string = <<~TEXT
        // comment 1
        // comment 2
        // comment 3
      TEXT

      expect(string).to fully_match(subject)
    end

    it "must match a single-line // comment within a string" do
      string = <<~CODE
      foo
      // comment
      bar
      CODE

      expect(string).to match(subject)
    end

    it "must match a single-line /* ... */ comment" do
      string = "/* comment here */"

      expect(string).to fully_match(subject)
    end

    it "must match a single-line /* ... */ comment that ends with a new-line" do
      string = "/* comment here */\n"

      expect(string).to match(subject)
    end

    it "must match a multi-line /* ... */ comment" do
      string = <<~TEXT.chomp
      /*
       * foo
       * bar
       * baz
       */
      TEXT

      expect(string).to fully_match(subject)
    end

    it "must match a multi-line /* ... */ comment that ends with a new-line" do
      string = <<~TEXT
      /*
       * foo
       * bar
       * baz
       */
      TEXT

      expect(string).to match(subject)
    end
  end

  describe "C_STYLE_COMMENT" do
    subject { described_class::C_STYLE_COMMENT }

    include_examples "C-style comments"
  end

  describe "C_COMMENT" do
    subject { described_class::C_COMMENT }

    it "must equal C_STYLE_COMMENT" do
      expect(subject).to be(described_class::C_STYLE_COMMENT)
    end
  end

  describe "CPP_COMMENT" do
    subject { described_class::CPP_COMMENT }

    it "must equal C_STYLE_COMMENT" do
      expect(subject).to be(described_class::C_STYLE_COMMENT)
    end
  end

  describe "JAVA_COMMENT" do
    subject { described_class::JAVA_COMMENT }

    it "must equal C_STYLE_COMMENT" do
      expect(subject).to be(described_class::C_STYLE_COMMENT)
    end
  end

  describe "JAVASCRIPT_COMMENT" do
    subject { described_class::JAVASCRIPT_COMMENT }

    it "must equal C_STYLE_COMMENT" do
      expect(subject).to be(described_class::C_STYLE_COMMENT)
    end
  end

  shared_examples_for "Shell-style comments" do
    it "must match a single-line # comment" do
      string = "# comment"

      expect(string).to fully_match(subject)
    end

    it "must match a single-line # comment that ends with a new-line" do
      string = "# comment\n"

      expect(string).to fully_match(subject)
    end

    it "must match multiple # comments in a row" do
      string = <<~TEXT.chomp
        # comment 1
        # comment 2
        # comment 3
      TEXT

      expect(string).to fully_match(subject)
    end

    it "must match multiple # comments in a row, that ends with a new-line" do
      string = <<~TEXT
        # comment 1
        # comment 2
        # comment 3
      TEXT

      expect(string).to fully_match(subject)
    end

    it "must match a single-line # comment within a string" do
      string = <<~CODE
      foo
      # comment
      bar
      CODE

      expect(string).to match(subject)
    end
  end

  describe "SHELL_STYLE_COMMENT" do
    subject { described_class::SHELL_STYLE_COMMENT }

    include_examples "Shell-style comments"
  end

  describe "SHELL_COMMENT" do
    subject { described_class::SHELL_COMMENT }

    it "must equal SHELL_STYLE_COMMENT" do
      expect(subject).to be(described_class::SHELL_STYLE_COMMENT)
    end
  end

  describe "BASH_COMMENT" do
    subject { described_class::BASH_COMMENT }

    it "must equal SHELL_STYLE_COMMENT" do
      expect(subject).to be(described_class::SHELL_STYLE_COMMENT)
    end
  end

  describe "RUBY_COMMENT" do
    subject { described_class::RUBY_COMMENT }

    it "must equal SHELL_STYLE_COMMENT" do
      expect(subject).to be(described_class::SHELL_STYLE_COMMENT)
    end
  end

  describe "PYTHON_COMMENT" do
    subject { described_class::PYTHON_COMMENT }

    it "must equal SHELL_STYLE_COMMENT" do
      expect(subject).to be(described_class::SHELL_STYLE_COMMENT)
    end
  end

  describe "COMMENT" do
    subject { described_class::COMMENT }

    include_examples "C-style comments"
    include_examples "Shell-style comments"
  end
end
