require 'spec_helper'
require 'ronin/templates/erb'

require 'templates/classes/example_erb'

describe Templates::Erb do
  subject { ExampleErb.new }

  before(:all) do
    subject.x = 2
    subject.y = 3
  end

  it "should render inline ERB templates" do
    subject.erb(%{<%= 'hello' %>}).should == 'hello'
  end

  it "should render ERB templates using the binding of the object" do
    subject.erb(%{<%= @x %> <%= @y %>}).should == '2 3'
  end
end
