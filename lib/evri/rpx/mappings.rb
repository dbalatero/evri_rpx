module Evri
  module RPX
    class Mappings
      attr_reader :json
      alias :raw :json

      def initialize(json)
        @json = json
      end

      def identifiers
        @json['identifiers'] || []
      end
    end
  end
end
