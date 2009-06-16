module Evri
  module RPX
    class Mappings
      # Gives back the raw JSON returned by RPX.
      attr_reader :json
      alias :raw :json

      def initialize(json)
        @json = json
      end

      # Returns a list of identifiers for a user, or an empty
      # array if there are none.
      def identifiers
        @json['identifiers'] || []
      end
    end
  end
end
