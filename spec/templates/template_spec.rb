require 'spec_helper'
require 'ronin/templates/template'

require 'templates/classes/example_template'
require 'templates/helpers/data'

describe Templates::Template do
  let(:example_template) { File.join(Helpers::TEMPLATE_DIR,'templates','example.erb') }
  let(:relative_template) { File.join(Helpers::TEMPLATE_DIR,'includes','_relative.erb') }

  subject { ExampleTemplate.new }

  it "should return the result of the block when entering a template" do
    subject.enter_example_template { |path|
      'result'
    }.should == 'result'
  end

  it "should be able to find templates relative to the current one" do
    subject.enter_example_template do |path|
      path.should == example_template
    end
  end

  it "should be able to find static templates" do
    subject.enter_relative_template do |path|
      path.should == relative_template
    end
  end

  it "should raise a RuntimeError when entering an unknown template" do
    lambda {
      subject.enter_missing_template { |path| }
    }.should raise_error(RuntimeError)
  end

  it "should be able to read templates relative to the current one" do
    subject.read_example_template do |contents|
      contents.should == File.read(example_template)
    end
  end

  it "should be able to find static templates" do
    subject.read_relative_template do |contents|
      contents.should == File.read(relative_template)
    end
  end

  it "should raise a RuntimeError when entering an unknown template" do
    lambda {
      subject.read_missing_template { |path| }
    }.should raise_error(RuntimeError)
  end
end
