require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

describe Evri::RPX::Contact do
  before(:all) do
    @contact = Evri::RPX::Contact.new(json_fixture('contacts/bob_johnson.json'))
  end

  describe "display_name" do
    it "should be the correct display name in the response" do
      @contact.display_name.should == 'Bob Johnson'
    end
  end

  describe "emails" do
    it "should return a list of emails for a given user" do
      @contact.emails.should == ['bob@example.com']
    end
  end
end
