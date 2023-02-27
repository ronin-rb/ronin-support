require 'spec_helper'
require 'ronin/support/network/tld'

describe Ronin::Support::Network::TLD do
  describe ".list" do
    let(:fixtures_dir) { File.join(__dir__,'tld','fixtures') }
    let(:list_file)    { File.join(fixtures_dir,'tlds-alpha-by-domain.txt') }

    it "must call #{described_class}::List.update and #{described_class}::List.load_file" do
      expect(described_class::List).to receive(:update)
      expect(described_class::List).to receive(:load_file)

      subject.list
    end

    it "must return a #{described_class}::List object" do
      stub_const("#{described_class}::List::PATH",list_file)
      allow(described_class::List).to receive(:update)

      expect(subject.list).to be_kind_of(described_class::List)
    end

    it "must cache the loaded #{described_class}::List object" do
      stub_const("#{described_class}::List::PATH",list_file)
      allow(described_class::List).to receive(:update)

      expect(subject.list).to be(subject.list)
    end
  end
end
