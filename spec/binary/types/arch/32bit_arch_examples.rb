require 'rspec'

shared_examples_for "32bit Arch examples" do
  describe "TYPES" do
    subject { described_class::TYPES }

    describe ":long" do
      it "must be an alias to :int32" do
        expect(subject[:long]).to be(subject[:int32])
      end
    end

    describe ":ulong" do
      it "must be an alias to :uint32" do
        expect(subject[:ulong]).to be(subject[:uint32])
      end
    end
  end
end
