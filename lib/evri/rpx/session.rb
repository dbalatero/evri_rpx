module Evri
  module RPX
    class Session
      attr_reader :api_key

      def initialize(api_key)
        @api_key = api_key
      end

      # Returns an auth_info User response from RPXNow.
      # Options:
      #   :tokenUrl => 'http://...'
      #     RPX will validate that the tokenUrl that you received
      #     a login redirect from matches the tokenUrl they have on
      #     file. This is extra security to guard against spoofing.
      #
      #     Default: nil
      #   :extended => (true|false)
      #     If you are a Plus/Pro customer, RPX will return extended
      #     data.
      def auth_info(token, options = {})

      end
    end
  end
end
