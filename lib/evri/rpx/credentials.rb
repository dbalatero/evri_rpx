module Evri
  module RPX
    class Credentials
      def initialize(json)
        @json = json
      end

      # Returns the type of credentials:
      #   (Facebook|OAuth|WindowsLive)
      #
      # Generally, you should use the helper methods such
      # as #facebook?, #oauth?, #windows_live?
      def type
        @json['type']
      end

      # Returns true if these credentials are Facebook.
      def facebook?
        type == 'Facebook'
      end

      # Returns the Facebook session key.
      def facebook_session_key
        @json['sessionKey']
      end

      # Returns when this Facebook session expires, as a Time
      # object.
      def facebook_expires
        Time.at(@json['expires'].to_i)
      end

      # Returns the UID for the authorized Facebook user.
      def facebook_uid
        @json['uid']
      end

      # Returns true if these credentials are OAuth.
      def oauth?
        type == 'OAuth'
      end

      # Returns the OAuth token.
      def oauth_token
        @json['oauthToken']
      end

      # Returns the OAuth token secret.
      def oauth_token_secret
        @json['oauthTokenSecret']
      end

      # Returns true if these credentials are for Windows Live
      def windows_live?
        type == 'WindowsLive'
      end

      # Returns the Windows Live eact string, which contains the
      # user's delegated authentication consent token.
      def windows_live_eact
        @json['eact']
      end
    end
  end
end
