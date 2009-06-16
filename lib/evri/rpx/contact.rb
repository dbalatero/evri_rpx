module Evri
  module RPX
    class Contact
      # Returns the person's display name, eg "Bob Johnson".
      attr_reader :display_name

      # Returns an array of emails, eg ['bob@johnson.com']
      attr_reader :emails

      def initialize(json)
        @display_name = json['displayName']
        @emails = json['emails'].map do |email|
          email['value']
        end
      end
    end
  end
end
