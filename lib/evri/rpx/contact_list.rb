module Evri
  module RPX
    class ContactList
      attr_reader :total_results
      attr_reader :start_index
      attr_reader :items_per_page
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
