require 'spec_helper'
require 'ronin/templates/erb'

require 'templates/classes/example_erb'

describe Templates::Erb do
  subject { ExampleErb.new }

  before do
    subject.x = 2
    subject.y = 3
  end

  it "should render inline ERB templates" do
    expect(subject.erb(%{<%= 'hello' %>})).to eq('hello')
  end

  it "should render ERB templates using the binding of the object" do
    expect(subject.erb(%{<%= @x %> <%= @y %>})).to eq('2 3')
  end
end
