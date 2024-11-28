require 'spec_helper'
require 'ronin/support/software/version'

describe Ronin::Support::Software::Version do
  let(:version) { '1.2.3' }

  subject { described_class.new(version) }

  describe "#initialize" do
    it "must initialize #string" do
      expect(subject.string).to eq(version)
    end

    it "must parse the version string and populate #parts" do
      expect(subject.parts).to eq([1, 2, 3])
    end
  end

  describe ".parse" do
    subject { described_class.parse(version) }

    it "must return a new #{described_class} with the given version" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.string).to eq(version)
    end
  end

  describe "#parts" do
    context "when the version string is of the form 'XYZ'" do
      let(:version) { '1234' }

      it "must contain a single Integer" do
        expect(subject.parts).to eq([version.to_i])
      end
    end

    context "when the version string is of the form 'X.Y'" do
      let(:version) { '1.2' }

      it "must contain two Integers" do
        expect(subject.parts).to eq([1, 2])
      end
    end

    context "when the version string is of the form 'X-Y'" do
      let(:version) { '1-2' }

      it "must contain two Integers" do
        expect(subject.parts).to eq([1, 2])
      end
    end

    context "when the version string is of the form 'X_Y'" do
      let(:version) { '1_2' }

      it "must contain two Integers" do
        expect(subject.parts).to eq([1, 2])
      end
    end

    context "when the version string is of the form 'X.Y.Z'" do
      let(:version) { '1.2.3' }

      it "must contain three Integers" do
        expect(subject.parts).to eq([1, 2, 3])
      end
    end

    context "when the version string is of the form 'X.Y-Z'" do
      let(:version) { '1.2-3' }

      it "must contain three Integers" do
        expect(subject.parts).to eq([1, 2, 3])
      end
    end

    context "when the version string is of the form 'X-Y.Z'" do
      let(:version) { '1-2.3' }

      it "must contain three Integers" do
        expect(subject.parts).to eq([1, 2, 3])
      end
    end

    context "when the version string is of the form 'X-Y-Z'" do
      let(:version) { '1-2-3' }

      it "must contain three Integers" do
        expect(subject.parts).to eq([1, 2, 3])
      end
    end

    context "when the version string is of the form 'X.Y_Z'" do
      let(:version) { '1.2_3' }

      it "must contain three Integers" do
        expect(subject.parts).to eq([1, 2, 3])
      end
    end

    context "when the version string is of the form 'X_Y.Z'" do
      let(:version) { '1_2.3' }

      it "must contain three Integers" do
        expect(subject.parts).to eq([1, 2, 3])
      end
    end

    context "when the version string is of the form 'X_Y_Z'" do
      let(:version) { '1_2_3' }

      it "must contain three Integers" do
        expect(subject.parts).to eq([1, 2, 3])
      end
    end

    context "when the version string is of the form 'X.Y.Z.W'" do
      let(:version) { '1.2.3.4' }

      it "must contain four Integers" do
        expect(subject.parts).to eq([1, 2, 3, 4])
      end
    end

    context "when the version string is of the form 'X.Y.Z-W'" do
      let(:version) { '1.2.3-4' }

      it "must contain four Integers" do
        expect(subject.parts).to eq([1, 2, 3, 4])
      end
    end

    context "when the version string is of the form 'X.Y-Z.W'" do
      let(:version) { '1.2-3.4' }

      it "must contain four Integers" do
        expect(subject.parts).to eq([1, 2, 3, 4])
      end
    end

    context "when the version string is of the form 'X-Y.Z.W'" do
      let(:version) { '1-2.3.4' }

      it "must contain four Integers" do
        expect(subject.parts).to eq([1, 2, 3, 4])
      end
    end

    context "when the version string is of the form 'X-Y.Z-W'" do
      let(:version) { '1-2.3-4' }

      it "must contain four Integers" do
        expect(subject.parts).to eq([1, 2, 3, 4])
      end
    end

    context "when the version string is of the form 'X-Y-Z.W'" do
      let(:version) { '1-2-3.4' }

      it "must contain four Integers" do
        expect(subject.parts).to eq([1, 2, 3, 4])
      end
    end

    context "when the version string is of the form 'X-Y-Z-W'" do
      let(:version) { '1-2-3-4' }

      it "must contain four Integers" do
        expect(subject.parts).to eq([1, 2, 3, 4])
      end
    end

    context "when the version string is of the form 'X.Y.Z_W'" do
      let(:version) { '1.2.3_4' }

      it "must contain four Integers" do
        expect(subject.parts).to eq([1, 2, 3, 4])
      end
    end

    context "when the version string is of the form 'X.Y_Z.W'" do
      let(:version) { '1.2_3.4' }

      it "must contain four Integers" do
        expect(subject.parts).to eq([1, 2, 3, 4])
      end
    end

    context "when the version string is of the form 'X_Y.Z.W'" do
      let(:version) { '1_2.3.4' }

      it "must contain four Integers" do
        expect(subject.parts).to eq([1, 2, 3, 4])
      end
    end

    context "when the version string is of the form 'X_Y.Z_W'" do
      let(:version) { '1_2.3_4' }

      it "must contain four Integers" do
        expect(subject.parts).to eq([1, 2, 3, 4])
      end
    end

    context "when the version string is of the form 'X_Y_Z.W'" do
      let(:version) { '1_2_3.4' }

      it "must contain four Integers" do
        expect(subject.parts).to eq([1, 2, 3, 4])
      end
    end

    context "when the version string is of the form 'X_Y_Z_W'" do
      let(:version) { '1_2_3_4' }

      it "must contain four Integers" do
        expect(subject.parts).to eq([1, 2, 3, 4])
      end
    end

    context "when one of the version numbers contains a letter" do
      let(:version) { '1.2.3a' }

      it "must parse the version 'number' containing a letter as a String" do
        expect(subject.parts).to eq([1, 2, '3a'])
      end
    end

    context "when one of the version 'numbers' only contains letters" do
      let(:version) { '1.2.3.abc' }

      it "must parse the version 'number' only containing letters as a String" do
        expect(subject.parts).to eq([1, 2, 3, 'abc'])
      end
    end

    context "when one of the version numbers starts with a '.p' prefix" do
      let(:version) { '1.2.3.p4' }

      it "must omit the '.p' prefix and parse the number" do
        expect(subject.parts).to eq([1, 2, 3, 4])
      end
    end

    context "when one of the version numbers starts with a '-p' prefix" do
      let(:version) { '1.2.3-p4' }

      it "must omit the '-p' prefix and parse the number" do
        expect(subject.parts).to eq([1, 2, 3, 4])
      end
    end

    [:pre, :alpha, :beta, :rc].each do |modifier|
      context "when the version string ends with '-#{modifier}'" do
        let(:modifier) { modifier }
        let(:version)  { "1.2.3-#{modifier}" }

        it "must parse the '-#{modifier}' as the #{modifier.inspect} Symbol" do
          expect(subject.parts).to eq([1, 2, 3, modifier])
        end
      end

      context "when the version string ends with '.#{modifier}'" do
        let(:modifier) { modifier }
        let(:version)  { "1.2.3.#{modifier}" }

        it "must parse the '.#{modifier}' as the #{modifier.inspect} Symbol" do
          expect(subject.parts).to eq([1, 2, 3, modifier])
        end
      end

      context "when the version string ends with '-#{modifier}N'" do
        let(:modifier) { modifier }
        let(:version)  { "1.2.3-#{modifier}4" }

        it "must parse the '-#{modifier}N' as the #{modifier.inspect} Symbol followed by the Integer N" do
          expect(subject.parts).to eq([1, 2, 3, modifier, 4])
        end
      end

      context "when the version string ends with '.#{modifier}N'" do
        let(:modifier) { modifier }
        let(:version)  { "1.2.3.#{modifier}4" }

        it "must parse the '.#{modifier}N' as the #{modifier.inspect} Symbol followed by the Integer N" do
          expect(subject.parts).to eq([1, 2, 3, modifier, 4])
        end
      end
    end

    context "when the version string ends with '+XXX'" do
      let(:version) { '1.2.3+1a2b3c' }

      it "must ignore everything after the '+' character" do
        expect(subject.parts).to eq([1, 2, 3])
      end
    end
  end

  describe "#<=>" do
    let(:other) { described_class.new(other_version) }

    context "when the version string equals the other version string " do
      let(:other_version) { version }

      it "must return 0 (indicating they are equal)" do
        expect(subject <=> other).to eq(0)
      end
    end

    context "when the version string is different from the other version string" do
      context "but only the deliminators are different" do
        let(:version)       { '1.2.3' }
        let(:other_version) { '1.2-3' }

        it "must return 0 (indicating they are equal)" do
          expect(subject <=> other).to eq(0)
        end
      end
    end

    context "when a version number in the other version string is greater" do
      let(:version)       { '1.2.3' }
      let(:other_version) { '1.2.4' }

      it "must return -1 (indicating the other version is greater)" do
        expect(subject <=> other).to eq(-1)
      end
    end

    context "when a version number in the other version string is less than the version number" do
      let(:version)       { '1.2.3' }
      let(:other_version) { '1.2.2' }

      it "must return 1 (indicating the other version is lesser)" do
        expect(subject <=> other).to eq(1)
      end
    end

    context "when the version contains a version modifier (pre, alpha, beta, rc)" do
      let(:version)       { '1.2.3.alpha' }
      let(:other_version) { '1.2.3' }

      it "must return -1 (indicating the version is less)" do
        expect(subject <=> other).to eq(-1)
      end

      context "but the other version numbers contains letters instead of a version modifier" do
        let(:other_version) { '1.2.3a' }

        it "must return -1 (indicating the version is less)" do
          expect(subject <=> other).to eq(-1)
        end
      end
    end

    context "when the other version contains a version modifier (pre, alpha, beta, rc)" do
      let(:version)       { '1.2.3' }
      let(:other_version) { '1.2.3.alpha' }

      it "must return 1 (indicating the version is greater)" do
        expect(subject <=> other).to eq(1)
      end

      context "but the version numbers contains letters instead of a version modifier" do
        let(:version) { '1.2.3a' }

        it "must return 1 (indicating the version is greater)" do
          expect(subject <=> other).to eq(1)
        end
      end
    end

    context "when both of the versions contain a version modifier (pre, alpha, beta, rc)" do
      context "and the version contains 'pre'" do
        let(:version) { '1.2.3.pre' }

        context "and the other version contains 'pre'" do
          let(:other_version) { '1.2.3.pre' }

          it "must return 0 (indicating the versions are equal)" do
            expect(subject <=> other).to eq(0)
          end
        end

        context "but the other version contains 'alpha'" do
          let(:other_version) { '1.2.3.alpha' }

          it "must return -1 (indicating the version is less)" do
            expect(subject <=> other).to eq(-1)
          end
        end

        context "but the other version contains 'beta'" do
          let(:other_version) { '1.2.3.beta' }

          it "must return -1 (indicating the version is less)" do
            expect(subject <=> other).to eq(-1)
          end
        end

        context "but the other version contains 'rc'" do
          let(:other_version) { '1.2.3.rc' }

          it "must return -1 (indicating the version is less)" do
            expect(subject <=> other).to eq(-1)
          end
        end
      end

      context "and the version contains 'alpha'" do
        let(:version) { '1.2.3.alpha' }

        context "and the other version contains 'pre'" do
          let(:other_version) { '1.2.3.pre' }

          it "must return 1 (indicating the version is greater)" do
            expect(subject <=> other).to eq(1)
          end
        end

        context "but the other version contains 'alpha'" do
          let(:other_version) { '1.2.3.alpha' }

          it "must return 0 (indicating the versions are equal)" do
            expect(subject <=> other).to eq(0)
          end
        end

        context "but the other version contains 'beta'" do
          let(:other_version) { '1.2.3.beta' }

          it "must return -1 (indicating the version is less)" do
            expect(subject <=> other).to eq(-1)
          end
        end

        context "but the other version contains 'rc'" do
          let(:other_version) { '1.2.3.rc' }

          it "must return -1 (indicating the version is less)" do
            expect(subject <=> other).to eq(-1)
          end
        end
      end

      context "and the version contains 'beta'" do
        let(:version) { '1.2.3.beta' }

        context "and the other version contains 'pre'" do
          let(:other_version) { '1.2.3.pre' }

          it "must return 1 (indicating the version is greater)" do
            expect(subject <=> other).to eq(1)
          end
        end

        context "but the other version contains 'alpha'" do
          let(:other_version) { '1.2.3.alpha' }

          it "must return 1 (indicating the version is greater)" do
            expect(subject <=> other).to eq(1)
          end
        end

        context "but the other version contains 'beta'" do
          let(:other_version) { '1.2.3.beta' }

          it "must return 0 (indicating the versions are equal)" do
            expect(subject <=> other).to eq(0)
          end
        end

        context "but the other version contains 'rc'" do
          let(:other_version) { '1.2.3.rc' }

          it "must return -1 (indicating the version is less)" do
            expect(subject <=> other).to eq(-1)
          end
        end
      end

      context "and the version contains 'rc'" do
        let(:version) { '1.2.3.rc' }

        context "and the other version contains 'pre'" do
          let(:other_version) { '1.2.3.pre' }

          it "must return 1 (indicating the version is greater)" do
            expect(subject <=> other).to eq(1)
          end
        end

        context "but the other version contains 'alpha'" do
          let(:other_version) { '1.2.3.alpha' }

          it "must return 1 (indicating the version is greater)" do
            expect(subject <=> other).to eq(1)
          end
        end

        context "but the other version contains 'beta'" do
          let(:other_version) { '1.2.3.beta' }

          it "must return 1 (indicating the version is greater)" do
            expect(subject <=> other).to eq(1)
          end
        end

        context "but the other version contains 'rc'" do
          let(:other_version) { '1.2.3.rc' }

          it "must return 0 (indicating the versions are equal)" do
            expect(subject <=> other).to eq(0)
          end
        end
      end
    end

    context "when the version contains numbers with a letter" do
      let(:version)       { '1.2.3a' }
      let(:other_version) { '1.2.3' }

      it "must return 1 (indicating the version is greater)" do
        expect(subject <=> other).to eq(1)
      end
    end

    context "when the other version contains numbers with a letter" do
      let(:version)       { '1.2.3' }
      let(:other_version) { '1.2.3a' }

      it "must return -1 (indicating the version is less)" do
        expect(subject <=> other).to eq(-1)
      end
    end

    context "when both of the versions have numbers that contains letters" do
      context "and they are the same" do
        let(:version)       { '1.2.3a' }
        let(:other_version) { '1.2.3a' }

        it "must return 0 (indicating the versions are equal)" do
          expect(subject <=> other).to eq(0)
        end
      end

      context "but the version number with letters is lexically less than the other version's number that also contains letters" do
        let(:version)       { '1.2.3a' }
        let(:other_version) { '1.2.3b' }

        it "must return -1 (indicating the version is less)" do
          expect(subject <=> other).to eq(-1)
        end
      end

      context "but the version number with letters is lexically greater than the other version's number that also contains letters" do
        let(:version)       { '1.2.3b' }
        let(:other_version) { '1.2.3a' }

        it "must return 1 (indicating the version is greater)" do
          expect(subject <=> other).to eq(1)
        end
      end
    end

    context "when the other version has fewer parts than the version" do
      let(:other_version) { '1.2' }

      it "must return 1 (indicating the other version is less)" do
        expect(subject <=> other).to eq(1)
      end

      context "but the additional part is a version modifier (pre, alpha, beta, rc)" do
        let(:version)       { '1.2.3.alpha' }
        let(:other_version) { '1.2.3' }

        it "must return -1 (indicating the version is less)" do
          expect(subject <=> other).to eq(-1)
        end
      end

      context "when one of the numbers in the version contains a letter" do
        let(:version) { '1.2.3a' }

        it "must return 1 (indicating the version is greater)" do
          expect(subject <=> other).to eq(1)
        end
      end
    end

    context "when the other version has more parts than the version" do
      context "and the additional part is a number" do
        let(:other_version) { '1.2.3.4' }

        it "must return -1 (indicating the other version is greater)" do
          expect(subject <=> other).to eq(-1)
        end

        context "but the additional numbers are 0" do
          let(:other_version) { '1.2.3.0' }

          it "must implicitly consider the two versions equal and return 0" do
            expect(subject <=> other).to eq(0)
          end
        end
      end

      context "but the additional part is a version modifier (pre, alpha, beta, rc)" do
        let(:other_version) { '1.2.3.alpha' }

        it "must return 1 (indicating the version is greater)" do
          expect(subject <=> other).to eq(1)
        end
      end

      context "when one of the numbers in the other version contains a letter" do
        let(:other_version) { '1.2.3.4a' }

        it "must return -1 (indicating the version is less)" do
          expect(subject <=> other).to eq(-1)
        end
      end
    end
  end

  describe "#to_s" do
    it "must return the version string" do
      expect(subject.to_s).to eq(version)
    end
  end
end
