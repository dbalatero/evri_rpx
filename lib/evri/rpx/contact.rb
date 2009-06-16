module Evri
  module RPX
    class Contact
      attr_reader :display_name
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
