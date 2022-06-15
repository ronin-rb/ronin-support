require 'spec_helper'
require 'ronin/support/inflector/core_ext/string'

describe String do
  subject { "foo" }

  it { expect(subject).to respond_to(:underscore) }
  it { expect(subject).to respond_to(:camelcase)  }
  it { expect(subject).to respond_to(:camelize)   }

  describe "#underscore" do
    subject { "FooBar" }

    it "must convert a CamelCase string into an under_scored string" do
      expect(subject.underscore).to eq("foo_bar")
    end
  end

  describe "#camelcase" do
    subject { "foo_bar" }

    it "must convert an under_scored string into a CamelCase string" do
      expect(subject.camelcase).to eq("FooBar")
    end
  end
end
