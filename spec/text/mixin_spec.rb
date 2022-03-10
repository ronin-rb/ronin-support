require 'spec_helper'
require 'ronin/support/text/mixin'

describe Ronin::Support::Text::Mixin do
  class TestTextMixin
    include Ronin::Support::Text::Mixin

    attr_accessor :x, :y
  end

  let(:test_class) { TestTextMixin }
  subject { test_class.new }

  it "must provide a #erb method" do
    expect(subject).to respond_to(:erb)
  end

  describe "#erb" do
    let(:x) { 1 }
    let(:y) { 2 }

    before do
      subject.x = x
      subject.y = y
    end

    let(:fixtures_dir) { File.join(__dir__,'fixtures')          }
    let(:erb_file)     { File.join(fixtures_dir,'erb_file.erb') }

    it "must render an .erb file in it's object context" do
      expect(subject.erb(erb_file)).to eq("x + y = 3")
    end
  end
end
