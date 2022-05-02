require 'rspec'

shared_examples_for "Ronin::Support::Binary::Types::ScalarType examples" do
  describe "#align" do
    let(:new_alignment) { 3 }

    let(:new_type) { subject.align(new_alignment) }

    it "must return the same kind of type" do
      expect(new_type).to be_kind_of(described_class)
    end

    it "must return a copy of the scalar type" do
      expect(new_type).to_not be(subject)
    end

    it "must preserve #size" do
      expect(new_type.size).to eq(subject.size)
    end

    it "must set #alignment to the new alignment" do
      expect(new_type.alignment).to eq(new_alignment)
    end

    it "must preserve #endian" do
      expect(new_type.endian).to eq(subject.endian)
    end

    it "must preserve #signed" do
      expect(new_type.signed).to eq(subject.signed)
    end
  end
end
