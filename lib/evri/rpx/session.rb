module Evri
  module RPX
    class Session
      API_VERSION = 'v2'
      API_HOST = 'rpxnow.com'
      ROOT_CA_PATH = File.expand_path(File.join(File.dirname(__FILE__),
                                                '..', '..', '..', 'certs',
                                                'cacert.pem'))

      class ServiceUnavailableError < StandardError; end
      class APICallError < StandardError; end

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
      #
      #     Default: false
      def auth_info(token, options = {})
        params = { 'apiKey' => @api_key,
                   'token' => token }
        params.merge!(options)

        json = parse_response(get("/api/#{API_VERSION}/auth_info",
                                  params))
        User.new(json)
      end

      def all_mappings
        json = parse_response(get("/api/#{API_VERSION}/all_mappings",
                                  :apiKey => @api_key))
        json['mappings']
      end

      # Returns the mappings for a given user's primary key, as a
      # Evri::RPX::Mappings object.
      #
      # Takes either a string of the user's primary key:
      #   session.mappings('dbalatero')
      # or a User object with an attached primary key:
      #   session.mappings(
      def mappings(user_or_primary_key)
        params = { 'apiKey' => @api_key }
        params['primaryKey'] = user_or_primary_key.respond_to?(:primary_key) ?
            user_or_primary_key.primary_key : user_or_primary_key
        
        json = parse_response(get("/api/#{API_VERSION}/mappings",
                                  params))
        Mappings.new(json)
      end


      # Map an OpenID to a primary key. Future logins by this owner of 
      # this OpenID will return the mapped primaryKey in the auth_info 
      # API response, which you may use to sign the user in.
      #
      #  
      def map(user_or_identifier, primary_key, options = {})
        params = { 'apiKey' => @api_key,
                   'primaryKey' => primary_key,
                   'overwrite' => true }
        params.merge!(options)
        params['identifier'] = identifier_param(user_or_identifier)
        json = parse_response(get("/api/#{API_VERSION}/map",
                                  params))

        json['stat'] == 'ok'
      end

      def unmap(user_or_identifier, primary_key)
        params = { 'apiKey' => @api_key,
                   'primaryKey' => primary_key }
        params['identifier'] = identifier_param(user_or_identifier)

        json = parse_response(get("/api/#{API_VERSION}/unmap",
                                  params))

        json['stat'] == 'ok'
      end

      private
      def identifier_param(user_or_identifier)
        user_or_identifier.respond_to?(:identifier) ? 
            user_or_identifier.identifier : user_or_identifier
      end

      def get(resource, params)
        request = Net::HTTP::Get.new(resource)
        request.form_data = params
        make_request(request)
      end

      def make_request(request)
        http = Net::HTTP.new(API_HOST, 443)
        http.use_ssl = true
        http.ca_file = ROOT_CA_PATH
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        http.verify_depth = 5
        http.request(request)
      end

      def parse_response(response)
        if response.code.to_i >= 400
          result = JSON.parse(response.body)

          code = result['err']['code']
          if code == -1
            raise ServiceUnavailableError, "The RPX service is temporarily unavailable."
          else
            raise APICallError, "Got error: #{result['err']['msg']} (code: #{code}), HTTP status: #{response.code}"
          end
        else
          JSON.parse(response.body)
        end
      end
    end
  end
end
