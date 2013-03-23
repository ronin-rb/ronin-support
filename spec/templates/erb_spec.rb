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

  it "should render inline ERB templates" do
    subject.erb(%{<%= 'hello' %>}).should == 'hello'
  end

  context "when the template uses instance variables" do
    it "should render ERB templates using the binding of the object" do
      subject.erb(%{<%= @x %> <%= @y %>}).should == "#{subject.x} #{subject.y}"
    end
  end

  context "when the template calls instance methods" do
    it "should render ERB templates using the instance method" do
      subject.erb(%{<%= template_method %>}).should == subject.template_method
    end
  end
end
