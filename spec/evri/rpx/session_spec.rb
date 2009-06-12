require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

describe Evri::RPX::Session do
  before(:all) do
    @session = Evri::RPX::Session.new('fake_api_key')
  end

  describe "api_key" do
    it "should return the current API key" do
      @session.api_key.should == 'fake_api_key'
    end
  end

  describe "auth_info" do
    it "should return a User object for a mapping" do
      pending
      result = @session.auth_info('mytoken')
      result.should be_a_kind_of(Evri::RPX::User)
    end
  end
end
