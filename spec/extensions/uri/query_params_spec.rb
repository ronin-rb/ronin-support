require 'spec_helper'
require 'ronin/extensions/uri'

describe URI::QueryParams do
  let(:uri) { URI('http://www.example.com/page.php?x=1&y=one%20two&z') }
  subject { uri }

  it "should provide #query_params" do
    should respond_to(:query_params)
  end

  it "should update #query_params after #query is set" do
    subject.query = 'u=3'
    subject.query_params['u'].should == '3'
  end

  it "should properly escape query param values" do
    subject.query_params = {'x' => '1&2', 'y' => 'one=two', 'z' => '?'}

    subject.to_s.should == "http://www.example.com/page.php?x=1%262&y=one%3Dtwo&z=%3F"
  end

  describe "#query_params" do
    subject { uri.query_params }

    it "should be a Hash" do
      subject.class.should == Hash
    end

    it "should contain params" do
      should_not be_empty
    end

    it "can contain single-word params" do
      subject['x'].should == '1'
    end

    it "can contain multi-word params" do
      subject['y'].should == 'one two'
    end

    it "can contain empty params" do
      subject['z'].should be_nil
    end
  end
end
