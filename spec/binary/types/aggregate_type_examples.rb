require 'rspec'
require 'ronin/support/binary/types/array_type'
require 'ronin/support/binary/types/unbounded_array_type'

shared_examples_for "AggregateType examples" do
  describe "#[]" do
    context "when a length argument is given" do
      let(:length) { 10 }

      it "must return an ArrayType" do
        expect(subject[length]).to be_kind_of(Ronin::Support::Binary::Types::ArrayType)
      end

      it "must have a #type of self" do
        expect(subject[length].type).to be(subject)
      end

      it "must have a #length of the length argument" do
        expect(subject[length].length).to be(length)
      end
    end

    context "when no argument is given" do
      it "must return an UnboundedArrayType" do
        expect(subject[]).to be_kind_of(Ronin::Support::Binary::Types::UnboundedArrayType)
      end

      it "must have a #type of self" do
        expect(subject[].type).to be(subject)
      end
    end
  end
end
