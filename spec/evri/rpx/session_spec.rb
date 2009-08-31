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
      FakeWeb.register_uri(:post,
                           'https://rpxnow.com:443/api/v2/auth_info',
                           :body => fixture_path('session/normal_error.json'),
                           :status => ['400', 'Bad Request'])
      lambda {
        @session.auth_info('errortoken')
      }.should raise_error(Evri::RPX::Session::APICallError)
    end

    it "should raise ServiceUnavailableError if the service is not available" do
      FakeWeb.register_uri(:post,
                           'https://rpxnow.com:443/api/v2/auth_info',
                           :body => fixture_path('session/service_down_error.json'),
                           :status => ['404', 'Not Found'])
      lambda {
        @session.auth_info('errortoken')
      }.should raise_error(Evri::RPX::Session::ServiceUnavailableError)
    end

    it "should return a User object for a mapping" do
      FakeWeb.register_uri(:post,
                           'https://rpxnow.com:443/api/v2/auth_info',
                           :body => fixture_path('user/dbalatero_gmail.json'))

      result = @session.auth_info('mytoken')
      result.should be_a_kind_of(Evri::RPX::User)
    end
  end

  describe "all_mappings" do
    it "should return a set of identifiers to mappings" do
      FakeWeb.register_uri(:post,
                           'https://rpxnow.com:443/api/v2/all_mappings',
                           :body => fixture_path('session/all_mappings.json'))
      result = @session.all_mappings
      result['1'].should == ['http://cygnus.myopenid.com/']
      result['2'].should == ['http://brianellin.com/', 'http://brian.myopenid.com/']
    end
  end

  describe "get_contacts" do
    before(:each) do
      FakeWeb.register_uri(:post,
                           'https://rpxnow.com:443/api/v2/get_contacts',
                           :body => fixture_path('session/get_contacts.json'))
    end
    
    after(:each) do
      FakeWeb.clean_registry
    end

    it "should return a contacts list for a identifier string" do
      result = @session.get_contacts('http://brian.myopenid.com/')
      result.should be_a_kind_of(Evri::RPX::ContactList)

      result.contacts.should have(6).things
    end

    it "should return a contacts list for a user string" do
      user = mock('user')
      user.should_receive(:identifier).and_return('http://brian.myopenid.com/')

      result = @session.get_contacts(user)
      result.should be_a_kind_of(Evri::RPX::ContactList)

      result.contacts.should have(6).things
    end
  end

  describe "map" do
    before(:each) do
      FakeWeb.register_uri(:post,
                           'https://rpxnow.com:443/api/v2/map',
                           :body => fixture_path('session/map.json'))
    end

    it "should take in a User object as the second parameter" do
      user = mock('user')
      user.should_receive(:identifier).and_return('https://www.facebook.com/dbalatero')

      result = @session.map(user, 50)
      result.should be_true
    end

    it "should take in a identifier string as the second parameter" do
      result = @session.map('https://www.facebook.com/dbalatero', 50)
      result.should be_true
    end
  end

  describe "mappings" do
    it "should return a Mappings object" do
      FakeWeb.register_uri(:post,
                           'https://rpxnow.com:443/api/v2/mappings',
                           :body => fixture_path('mappings/identifiers.json'))

      result = @session.mappings('dbalatero')
      result.should be_a_kind_of(Evri::RPX::Mappings)
      result.identifiers.should_not be_empty
    end

    it "should take a User object in" do
      FakeWeb.register_uri(:post,
                           'https://rpxnow.com:443/api/v2/mappings',
                           :body => fixture_path('mappings/identifiers.json'))
      user = mock('user')
      user.should_receive(:primary_key).and_return('dbalatero')

      result = @session.mappings(user)
      result.should be_a_kind_of(Evri::RPX::Mappings)
      result.identifiers.should_not be_empty
    end
  end

  describe "set_status" do
    it "should call set_status, and return true" do
      FakeWeb.register_uri(:post,
                           'https://rpxnow.com/api/v2/set_status',
                           :body => fixture_path('session/set_status.json'))
      user = mock('user')
      user.should_receive(:identifier).and_return('https://www.facebook.com/dbalatero')

      result = @session.set_status(user, "My new status!")
      result.should be_true
    end
  end

  describe "unmap" do
    before(:each) do
      FakeWeb.register_uri(:post,
                           'https://rpxnow.com:443/api/v2/unmap',
                           :body => fixture_path('session/unmap.json'))
    end

    it "should take a string as the identifier" do
      result = @session.unmap('https://www.facebook.com/dbalatero', 50)
      result.should be_true
    end

    it "should take a User as the identifier" do
      user = mock('user')
      user.should_receive(:identifier).and_return('https://www.facebook.com/dbalatero')

      result = @session.unmap(user, 50)
      result.should be_true
    end
  end
end
