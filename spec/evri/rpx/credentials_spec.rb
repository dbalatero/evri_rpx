require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

describe Evri::RPX::Credentials do
  describe "parsing OAuth (twitter) credentials" do
    before(:all) do
      json = json_fixture('credentials/dbalatero_twitter.json')
      @credentials = Evri::RPX::Credentials.new(json['accessCredentials'])
    end

    describe "oauth?" do
      it "should be true" do
        @credentials.oauth?.should be_true
      end
    end

    describe "type" do
      it "should be OAuth" do
        @credentials.type.should == 'OAuth'
      end
    end

    describe "oauth_token" do
      it "should be the oauth token given" do
        @credentials.oauth_token.should == '35834683-jBU3o-snip' 
      end
    end

    describe "oauth_token_secret" do
      it "should be the secret given" do
        @credentials.oauth_token_secret.should == '2GjoAgV5-snip'
      end
    end
  end

  describe "parsing Windows Live credentials" do
    before(:all) do
      json = json_fixture('credentials/dbalatero_windowslive.json')
      @credentials = Evri::RPX::Credentials.new(json['accessCredentials'])
    end

    describe "windows_live?" do
      it "should be true" do
        @credentials.windows_live?.should be_true
      end
    end

    describe "type" do
      it "should be WindowsLive" do
        @credentials.type.should == 'WindowsLive'
      end
    end

    describe "windows_live_eact" do
      it "should be the eact field given" do
        @credentials.windows_live_eact.should == 'eact%3DJvtJUb4%252Bx1InXqjglTBWX-snip'
      end
    end
  end


  describe "parsing Facebook credentials" do
    before(:all) do
      json = json_fixture('credentials/dbalatero_facebook.json')
      @credentials = Evri::RPX::Credentials.new(json['accessCredentials'])
    end

    describe "facebook?" do
      it "should be true" do
        @credentials.facebook?.should be_true
      end
    end

    describe "type" do
      it "should be Facebook" do
        @credentials.type.should == 'Facebook'
      end
    end

    describe "facebook_session_key" do
      it "should be the session key given" do
        @credentials.facebook_session_key.should == '2.7kr3H8W-snip'
      end
    end

    describe "facebook_uid" do
      it "should be the UID given" do
        @credentials.facebook_uid.should == '10701789'
      end
    end

    describe "facebook_expires" do
      it "should be the correct Time object" do
        @credentials.facebook_expires.should == Time.at(1245196800)
      end
    end

  end
end
