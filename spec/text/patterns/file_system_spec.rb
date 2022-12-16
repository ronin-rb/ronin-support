require 'spec_helper'
require 'matchers/fully_match'
require 'ronin/support/text/patterns/file_system'

describe Ronin::Support::Text::Patterns do
  describe "FILE_EXT" do
    subject { described_class::FILE_EXT }

    it "must match the '.' separator character" do
      ext = '.txt'

      expect(ext).to fully_match(subject)
    end

    it "must not allow '_' characters" do
      ext = '.foo_bar'

      expect(ext.match(subject)[0]).to eq('.foo')
    end

    it "must not allow '-' characters" do
      ext = '.foo-bar'

      expect(ext.match(subject)[0]).to eq('.foo')
    end
  end

  describe "FILE_NAME" do
    subject { described_class::FILE_NAME }

    it "must match the filename and extension" do
      filename = 'foo_bar.txt'

      expect(filename).to fully_match(subject)
    end

    it "must match '\\' escapped characters" do
      filename = 'foo\\ bar.txt'

      expect(filename).to fully_match(subject)
    end

    it "must match file names without extensions" do
      filename = 'foo_bar'

      expect(filename).to fully_match(subject)
    end
  end

  describe "DIR_NAME" do
    subject { described_class::DIR_NAME }

    it "must match directory names" do
      dir = 'foo_bar'

      expect(dir).to fully_match(subject)
    end

    it "must match '.'" do
      dir = '.'

      expect(dir).to fully_match(subject)
    end

    it "must match '..'" do
      dir = '..'

      expect(dir).to fully_match(subject)
    end
  end

  describe "RELATIVE_UNIX_PATH" do
    subject { described_class::RELATIVE_UNIX_PATH }

    it "must match multiple directories" do
      path = 'foo/./bar/../baz'

      expect(path).to fully_match(subject)
    end
  end

  describe "ABSOLUTE_UNIX_PATH" do
    subject { described_class::ABSOLUTE_UNIX_PATH }

    it "must match absolute paths" do
      path = '/foo/bar/baz'

      expect(path).to fully_match(subject)
    end

    it "must match trailing '/' characters" do
      path = '/foo/bar/baz/'

      expect(path).to fully_match(subject)
    end

    it "must not match relative directories" do
      path = '/foo/./bar/../baz'

      expect(subject.match(path)[0]).to eq('/foo/')
    end
  end

  describe "UNIX_PATH" do
    subject { described_class::UNIX_PATH }

    it "must match relative paths" do
      path = 'foo/./bar/../baz'

      expect(path).to fully_match(subject)
    end

    it "must match absolute paths" do
      path = '/foo/bar/baz'

      expect(path).to fully_match(subject)
    end
  end

  describe "RELATIVE_WINDOWS_PATH" do
    subject { described_class::RELATIVE_WINDOWS_PATH }

    it "must match multiple directories" do
      path = 'foo\\.\\bar\\..\\baz'

      expect(path).to fully_match(subject)
    end
  end

  describe "ABSOLUTE_WINDOWS_PATH" do
    subject { described_class::ABSOLUTE_WINDOWS_PATH }

    it "must match absolute paths" do
      path = 'C:\\foo\\bar\\baz'

      expect(path).to fully_match(subject)
    end

    it "must match trailing '/' characters" do
      path = 'C:\\foo\\bar\\baz\\'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "must not match relative directories" do
      path = 'C:\\foo\\.\\bar\\..\\baz'

      expect(subject.match(path)[0]).to eq('C:\\foo\\')
    end
  end

  describe "WINDOWS_PATH" do
    subject { described_class::WINDOWS_PATH }

    it "must match relative paths" do
      path = 'foo\\.\\bar\\..\\baz'

      expect(path).to fully_match(subject)
    end

    it "must match absolute paths" do
      path = 'C:\\foo\\bar\\baz'

      expect(path).to fully_match(subject)
    end
  end

  describe "RELATIVE_PATH" do
    subject { described_class::RELATIVE_PATH }

    it "must match relative UNIX paths" do
      path = 'foo/./bar/../baz'

      expect(path).to fully_match(subject)
    end

    it "must match relative Windows paths" do
      path = 'foo\\.\\bar\\..\\baz'

      expect(path).to fully_match(subject)
    end
  end

  describe "ABSOLUTE_PATH" do
    subject { described_class::ABSOLUTE_PATH }

    it "must match absolute UNIX paths" do
      path = '/foo/bar/baz'

      expect(path).to fully_match(subject)
    end

    it "must match absolute Windows paths" do
      path = 'C:\\foo\\bar\\baz'

      expect(path).to fully_match(subject)
    end
  end

  describe "PATH" do
    subject { described_class::PATH }

    it "must match relative UNIX paths" do
      path = 'foo/./bar/../baz'

      expect(path).to fully_match(subject)
    end

    it "must match absolute UNIX paths" do
      path = '/foo/bar/baz'

      expect(path).to fully_match(subject)
    end

    it "must match relative Windows paths" do
      path = 'foo\\.\\bar\\..\\baz'

      expect(path).to fully_match(subject)
    end

    it "must match absolute Windows paths" do
      path = 'C:\\foo\\bar\\baz'

      expect(path).to fully_match(subject)
    end
  end
end
