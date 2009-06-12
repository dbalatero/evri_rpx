require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

describe Evri::RPX::User do
  describe "initialize" do
    it "should not accept any JSON hash that doesn't have profile data in it" do
      lambda {
        Evri::RPX::User.new({})
      }.should raise_error(Evri::RPX::User::InvalidUserJsonError)

      lambda {
        Evri::RPX::User.new(nil)
      }.should raise_error(Evri::RPX::User::InvalidUserJsonError)
    end
  end

  describe "parsing Twitter logins" do
    before(:all) do
      json = json_fixture('user/dbalatero_twitter.json')
      @user = Evri::RPX::User.new(json)
    end

    describe "name" do
      it "should be equal to the formatted name" do
        @user.name.should == 'David Balatero'
      end
    end

    describe "photo" do
      it "should be a valid photo" do
        @user.photo.should =~ /http:\/\/s3\.amazonaws\.com/
      end
    end

    describe "display_name" do
      it "should be the displayName in the JSON" do
        @user.display_name.should == 'David Balatero'
      end
    end
    
    describe 'profile_url' do
      it "should point to the user's Twitter page" do
        @user.profile_url.should == 'http://twitter.com/dbalatero'
      end
    end

    describe 'username' do
      it "should be the user's Twitter username" do
        @user.username.should == 'dbalatero'
      end
    end

    describe 'primary_key' do
      it "should be nil" do
        @user.primary_key.should be_nil
      end
    end
    
    describe 'identifier' do
      it "should be the identifier that Twitter gives" do
        @user.identifier.should =~ /user_id=35834683/
      end
    end

    describe "twitter?" do
      it "should be true for Twitter responses" do
        @user.twitter?.should be_true
      end
    end

    describe "credentials" do
      it "should not be nil" do
        pending
      end
    end

    describe 'provider_name' do
      it 'should be Twitter' do
        @user.provider_name.should == 'Twitter'
      end
    end
  end

  # Google logins
  describe "parsing Google logins" do
    before(:all) do
      json = json_fixture('user/dbalatero_gmail.json')
      @user = Evri::RPX::User.new(json)
    end

    describe "name" do
      it "should be equal to the formatted name" do
        @user.name.should == 'David Balatero'
      end
    end

    describe "photo" do
      it "should be nil" do
        @user.photo.should be_nil
      end
    end

    describe "display_name" do
      it "should be the displayName in the JSON" do
        @user.display_name.should == 'dbalatero'
      end
    end
    
    describe 'profile_url' do
      it "should be nil" do
        @user.profile_url.should be_nil
      end
    end

    describe 'username' do
      it "should be the user's Google username" do
        @user.username.should == 'dbalatero'
      end
    end

    describe 'primary_key' do
      it "should be set to the correct mapping" do
        @user.primary_key.should == 'DavidBalateroTestRPXX'
      end
    end
    
    describe 'identifier' do
      it "should be the identifier that Twitter gives" do
        @user.identifier.should =~ /https:\/\/www.google.com\/accounts/
      end
    end

    describe "google?" do
      it "should be true for Google responses" do
        @user.google?.should be_true
      end
    end

    describe "credentials" do
      it "should be nil" do
        @user.credentials.should be_nil
      end
    end

    describe 'provider_name' do
      it 'should be Google' do
        @user.provider_name.should == 'Google'
      end
    end

    describe "email" do
      it "should be set to dbalatero@gmail.com" do
        @user.email.should == 'dbalatero@gmail.com'
      end
    end
  end

  # Facebook logins
  describe "parsing Facebook logins" do
    before(:all) do
      json = json_fixture('user/dbalatero_facebook.json')
      @user = Evri::RPX::User.new(json)
    end

    describe "name" do
      it "should be equal to the formatted name" do
        @user.name.should == 'David Balatero'
      end
    end

    describe "photo" do
      it "should be a Facebook profile picture." do
        @user.photo.should_not be_nil
        @user.photo.should =~ /http:\/\/profile\.ak\.facebook\.com/
      end
    end

    describe "display_name" do
      it "should be the displayName in the JSON" do
        @user.display_name.should == 'David Balatero'
      end
    end
    
    describe 'profile_url' do
      it "should be the correct Facebook profile URL" do
        @user.profile_url.should == 'http://www.facebook.com/profile.php?id=10701789'
      end
    end

    describe 'username' do
      it "should be the user's Google username" do
        @user.username.should == 'DavidBalatero'
      end
    end

    describe 'identifier' do
      it "should be the identifier that Twitter gives" do
        @user.identifier.should == 'http://www.facebook.com/profile.php?id=10701789'
      end
    end

    describe "facebook?" do
      it "should be true for Google responses" do
        @user.facebook?.should be_true
      end
    end

    describe "credentials" do
      it "should be set" do
        pending
        @user.credentials.should_not be_nil
      end
    end

    describe 'provider_name' do
      it 'should be Facebook' do
        @user.provider_name.should == 'Facebook'
      end
    end
  end
end
