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
    after(:each) do
      FakeWeb.clean_registry
    end

    it "should raise an APICallError if RPX returns an error message" do
      FakeWeb.register_uri(:get,
                           'http://rpxnow.com:443/api/v2/auth_info',
                           :file => fixture_path('session/normal_error.json'),
                           :status => ['400', 'Bad Request'])
      lambda {
        @session.auth_info('errortoken')
      }.should raise_error(Evri::RPX::Session::APICallError)
    end

    it "should raise ServiceUnavailableError if the service is not available" do
      FakeWeb.register_uri(:get,
                           'http://rpxnow.com:443/api/v2/auth_info',
                           :file => fixture_path('session/service_down_error.json'),
                           :status => ['404', 'Not Found'])
      lambda {
        @session.auth_info('errortoken')
      }.should raise_error(Evri::RPX::Session::ServiceUnavailableError)
    end

    it "should return a User object for a mapping" do
      FakeWeb.register_uri(:get,
                           'http://rpxnow.com:443/api/v2/auth_info',
                           :file => fixture_path('user/dbalatero_gmail.json'))

      result = @session.auth_info('mytoken')
      result.should be_a_kind_of(Evri::RPX::User)
    end
  end

  describe "mappings" do
    it "should return a Mappings object" do
      FakeWeb.register_uri(:get,
                           'http://rpxnow.com:443/api/v2/mappings',
                           :file => fixture_path('mappings/identifiers.json'))

      result = @session.mappings('dbalatero')
      result.should be_a_kind_of(Evri::RPX::Mappings)
      result.identifiers.should_not be_empty
    end
  end
end
