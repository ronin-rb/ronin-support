require 'spec_helper'
require 'ronin/support/software/version_constraint'

describe Ronin::Support::Software::VersionConstraint do
  let(:operator) { '>=' }
  let(:version)  { '1.2.3' }
  let(:string)   { "#{operator} #{version}" }

  subject { described_class.new(string) }

  describe "#initialize" do
    it "must set #string to the given version constraint string" do
      expect(subject.string).to eq(string)
    end

    it "must parse and set #version to a new Ronin::Support::Software::Version object using the version string within the version constraint string" do
      expect(subject.version).to be_kind_of(Ronin::Support::Software::Version)
      expect(subject.version.string).to eq(version)
    end

    context "when the version constraint string starts with '>='" do
      let(:operator) { '>=' }

      it "must parse and set #operator to '>='" do
        expect(subject.operator).to eq(operator)
      end
    end

    context "when the version constraint string starts with '>'" do
      let(:operator) { '>' }

      it "must parse and set #operator to '>'" do
        expect(subject.operator).to eq(operator)
      end
    end

    context "when the version constraint string starts with '<='" do
      let(:operator) { '<=' }

      it "must parse and set #operator to '<='" do
        expect(subject.operator).to eq(operator)
      end
    end

    context "when the version constraint string starts with '<'" do
      let(:operator) { '<' }

      it "must parse and set #operator to '<'" do
        expect(subject.operator).to eq(operator)
      end
    end

    context "when the version constraint string starts with '='" do
      let(:operator) { '=' }

      it "must parse and set #operator to '='" do
        expect(subject.operator).to eq(operator)
      end
    end

    context "but the version constraint string does not start with any operator" do
      let(:string) { version }

      it "must default #operator to '='" do
        expect(subject.operator).to eq('=')
      end
    end

    context "but there are no spaces between the operator and the version" do
      let(:string) { "#{operator}#{version}" }

      it "must still parse and set #operator" do
        expect(subject.operator).to eq(operator)
      end

      it "must still parse and set #version" do
        expect(subject.version).to be_kind_of(Ronin::Support::Software::Version)
        expect(subject.version.string).to eq(version)
      end
    end

    context "but the version constraint string is malformed" do
      let(:string) { '' }

      it "must raise an ArgumentError exception" do
        expect {
          described_class.new(string)
        }.to raise_error(ArgumentError,"invalid version constraint: #{string.inspect}")
      end
    end
  end

  describe ".parse" do
    subject { described_class.parse(string) }

    it "must return a new #{described_class} with the given version constraint string" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.string).to eq(string)
    end
  end

  describe "#include?" do
    let(:lesser_version)  { '1.2.2' }
    let(:greater_version) { '1.2.4' }

    context "when the #operator is '>'" do
      let(:operator) { '>' }

      context "and the given version is greater than #version" do
        let(:other_version) do
          Ronin::Support::Software::Version.new(greater_version)
        end

        it "must return true" do
          expect(subject.include?(other_version)).to be(true)
        end
      end

      context "but the given version is equal to #version" do
        let(:other_version) do
          Ronin::Support::Software::Version.new(version)
        end

        it "must return false" do
          expect(subject.include?(other_version)).to be(false)
        end
      end

      context "but the given version is less than #version" do
        let(:other_version) do
          Ronin::Support::Software::Version.new(lesser_version)
        end

        it "must return false" do
          expect(subject.include?(other_version)).to be(false)
        end
      end
    end

    context "when the #operator is '>='" do
      let(:operator) { '>=' }

      context "and the given version is greater than #version" do
        let(:other_version) do
          Ronin::Support::Software::Version.new(greater_version)
        end

        it "must return true" do
          expect(subject.include?(other_version)).to be(true)
        end
      end

      context "and the given version is equal to #version" do
        let(:other_version) do
          Ronin::Support::Software::Version.new(version)
        end

        it "must return true" do
          expect(subject.include?(other_version)).to be(true)
        end
      end

      context "but the given version is less than #version" do
        let(:other_version) do
          Ronin::Support::Software::Version.new(lesser_version)
        end

        it "must return false" do
          expect(subject.include?(other_version)).to be(false)
        end
      end
    end

    context "when the #operator is '<'" do
      let(:operator) { '<' }

      context "but the given version is greater than #version" do
        let(:other_version) do
          Ronin::Support::Software::Version.new(greater_version)
        end

        it "must return false" do
          expect(subject.include?(other_version)).to be(false)
        end
      end

      context "but the given version is equal to #version" do
        let(:other_version) do
          Ronin::Support::Software::Version.new(version)
        end

        it "must return false" do
          expect(subject.include?(other_version)).to be(false)
        end
      end

      context "and the given version is less than #version" do
        let(:other_version) do
          Ronin::Support::Software::Version.new(lesser_version)
        end

        it "must return true" do
          expect(subject.include?(other_version)).to be(true)
        end
      end
    end

    context "when the #operator is '<='" do
      let(:operator) { '<=' }

      context "but the given version is greater than #version" do
        let(:other_version) do
          Ronin::Support::Software::Version.new(greater_version)
        end

        it "must return false" do
          expect(subject.include?(other_version)).to be(false)
        end
      end

      context "and the given version is equal to #version" do
        let(:other_version) do
          Ronin::Support::Software::Version.new(version)
        end

        it "must return true" do
          expect(subject.include?(other_version)).to be(true)
        end
      end

      context "and the given version is less than #version" do
        let(:other_version) do
          Ronin::Support::Software::Version.new(lesser_version)
        end

        it "must return true" do
          expect(subject.include?(other_version)).to be(true)
        end
      end
    end

    context "when the #operator is '='" do
      let(:operator) { '=' }

      context "and the given version is equal to #version" do
        let(:other_version) do
          Ronin::Support::Software::Version.new(version)
        end

        it "must return true" do
          expect(subject.include?(other_version)).to be(true)
        end
      end

      context "but the given version is less than #version" do
        let(:other_version) do
          Ronin::Support::Software::Version.new(lesser_version)
        end

        it "must return false" do
          expect(subject.include?(other_version)).to be(false)
        end
      end

      context "but the given version is greater than #version" do
        let(:other_version) do
          Ronin::Support::Software::Version.new(greater_version)
        end

        it "must return false" do
          expect(subject.include?(other_version)).to be(false)
        end
      end
    end
  end

  describe "#==" do
    context "when given another #{described_class}" do
      let(:other_operator) { operator }
      let(:other_version)  { version }
      let(:other_string)   { "#{other_operator} #{other_version}" }
      let(:other)          { described_class.new(other_string) }

      context "and the #operator and #version are the same" do
        it "must return true" do
          expect(subject == other).to be(true)
        end
      end

      context "but the #operator is different" do
        let(:other_operator) { '>' }

        it "must return false" do
          expect(subject == other).to be(false)
        end
      end

      context "but the #version is different" do
        let(:other_version) { '0.0.0' }

        it "must return false" do
          expect(subject == other).to be(false)
        end
      end
    end

    context "when given another kind of object" do
      let(:other) { Object.new }

      it "must return false" do
        expect(subject == other).to be(false)
      end
    end
  end
end
