require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

describe Evri::RPX::Mappings do
  describe "identifiers" do
    it "should return the identifiers present in the response" do
      json = json_fixture('mappings/identifiers.json')
      mappings = Evri::RPX::Mappings.new(json)
      mappings.identifiers.should include("http://brian.myopenid.com/")
      mappings.identifiers.should include("http://brianellin.com/")
    end
  end

  describe "raw/json" do
    it "should return the raw JSON that was passed to the constructor" do
      json = {}
      mappings = Evri::RPX::Mappings.new(json)
      mappings.raw.should == json
      mappings.json.should == json
    end
  end
end
