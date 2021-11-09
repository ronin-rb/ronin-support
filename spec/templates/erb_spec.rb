require 'spec_helper'
require 'ronin/templates/erb'

describe Templates::Erb do
  class ErbTemplate

    include Ronin::Templates::Erb

    attr_accessor :x, :y

    def initialize
      @x = 2
      @y = 3
    end

    def template_method
      "foo"
    end

  end

  subject { ErbTemplate.new }

  before do
    subject.x = 2
    subject.y = 3
  end

  it "should render inline ERB templates" do
    expect(subject.erb(%{<%= 'hello' %>})).to eq('hello')
  end

  context "when the template uses instance variables" do
    it "should render ERB templates using the binding of the object" do
      expect(subject.erb(%{<%= @x %> <%= @y %>})).to eq("#{subject.x} #{subject.y}")
    end
  end

  context "when the template calls instance methods" do
    it "should render ERB templates using the instance method" do
      expect(subject.erb(%{<%= template_method %>})).to eq(subject.template_method)
    end
  end
end
