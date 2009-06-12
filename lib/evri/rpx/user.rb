module Evri
  module RPX
    class User
      class InvalidUserJsonError < StandardError; end

      def initialize(json)
        if !json['profile']
          raise InvalidUserJsonError,
                'The JSON passed in is invalid!'
        end
        @json = json
      end

      # Returns the person's full name (aka David Balatero)
      def name
        @json['profile']['name']['formatted'] rescue nil
      end

      # Returns a name that should be displayed for this user.
      def display_name
        @json['profile']['displayName'] rescue nil
      end

      # Returns a username for this user.
      def username
        @json['profile']['preferredUsername'] rescue nil
      end

      # Returns a unique identifier for this user.
      def identifier
        @json['profile']['identifier'] rescue nil
      end

      # Returns the primary key for this user, if they have
      # been mapped already.
      def primary_key
        @json['profile']['primaryKey'] rescue nil
      end

      # Returns a photo URL for a user if they have one.
      def photo
        @json['profile']['photo'] rescue nil
      end

      # Returns a URL to a person's profile on the 3rd-party site.
      def profile_url
        @json['profile']['url'] rescue nil
      end

      def credentials
        nil
      end

      # Returns true if this is a Twitter login.
      def twitter?
        @json['profile']['providerName'] == 'Twitter'
      end

      def google?
        @json['profile']['providerName'] == 'Google'
      end
    end
  end
end
