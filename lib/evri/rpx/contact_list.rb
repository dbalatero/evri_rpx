module Evri
  module RPX
    class ContactList
      # Returns the total amount of contacts found for this user.
      attr_reader :total_results

      # Returns the current pagination index into the contact results
      attr_reader :start_index

      # Returns the number of contacts returned per page.
      attr_reader :items_per_page

      # Returns an array of Contact objects.
      attr_reader :contacts

      def initialize(json)
        @total_results = json['response']['totalResults'] rescue 0
        @start_index = json['response']['startIndex'] rescue nil
        @items_per_page = json['response']['itemsPerPage']

        @contacts = json['response']['entry'].map do |contact_json|
          Contact.new(contact_json)
        end
      end
    end
  end
end
