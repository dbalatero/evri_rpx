require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

describe Evri::RPX::ContactList do
  before(:all) do
    @list = Evri::RPX::ContactList.new(json_fixture('session/get_contacts.json'))
  end

  describe "total_results" do
    it "should return the total results for a user's contact list" do
      @list.total_results.should == 5
    end
  end

  describe "start_index" do
    it "should return the start index used in pagination" do
      @list.start_index.should == 1
    end
  end

  describe "items_per_page" do
    it "should return the items per page, for pagination" do
      @list.items_per_page.should == 5
    end
  end

  describe "contacts" do
    it "should return an array of Contact objects" do
      @list.contacts.each do |contact|
        contact.should be_a_kind_of(Evri::RPX::Contact)
      end
    end

    it "should include Bob Johnson" do
      @list.contacts.select { |contact|
        contact.display_name == 'Bob Johnson'
      }.should_not be_nil
    end
  end
end
