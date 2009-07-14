module Evri
  module RPX
    # All API calls go through this session object.
    #
    # Any API call has the chance of raising one of two errors, which
    # you should be aware of:
    #   - ServiceUnavailableError, raised when RPX is down
    #   - APICallError, raised when RPX finds something wrong w/ your API call.
    class Session
      API_VERSION = 'v2'
      API_HOST = 'rpxnow.com'
      ROOT_CA_PATH = File.expand_path(File.join(File.dirname(__FILE__),
                                                '..', '..', '..', 'certs',
                                                'cacert.pem'))

      # This error is raised when the RPX service is unavailable.
      class ServiceUnavailableError < StandardError; end

      # This error is raised when an API call is misformed,
      # or there is bad configuration on the other end.
      class APICallError < StandardError; end

      # Returns the current RPX api_key attached to the session.
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

      # Get all stored mappings for a particular application.
      #
      # Returns a hash in this form:
      #   { 'identifier1' => ['mapping1', 'mapping2'],
      #     'identifier2' => ['mapping3', 'mapping4'],
      #     ... }
      def all_mappings
        json = parse_response(get("/api/#{API_VERSION}/all_mappings",
                                  :apiKey => @api_key))
        json['mappings']
      end

      # Retrieve a list of contacts for an identifier in the
      # Portable Contacts format. 
      #
      # Takes either a string identifier, or a User object
      # that responds to :identifier.
      #
      # This feature is only available for RPX Pro customers.
      def get_contacts(user_or_identifier)
        identifier = identifier_param(user_or_identifier)
        json = parse_response(get("/api/#{API_VERSION}/get_contacts",
                                  :apiKey => @api_key,
                                  :identifier => identifier))
        ContactList.new(json)
      end

      # Returns the mappings for a given user's primary key, as a
      # Evri::RPX::Mappings object.
      #
      # Takes either a string of the user's primary key:
      #   m = session.mappings('dbalatero')
      # or a User object with an attached primary key:
      #   user = session.auth_info(params[:token])
      #   m = session.mappings(user)
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
      # Returns true.  
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

      # Sets the status for a given user's social network. If this
      # is not supported by the API, it will raise an error message 
      # to that effect.
      #
      # See: https://rpxnow.com/dos#api_set_status
      #
      # Only available in Plus and Pro.
      def set_status(user_or_identifier, status_message)
        params = { 'apiKey' => @api_key,
                   'status' => status_message }
        params['identifier'] = identifier_param(user_or_identifier)

        json = parse_response(get("/api/#{API_VERSION}/set_status",
                                  params))

        json['stat'] == 'ok'
      end

      # Remove (unmap) an OpenID from a primary key.
      #
      # Returns true.
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
        result = JSON.parse(response.body)

        if result['err']
          code = result['err']['code']
          if code == -1
            raise ServiceUnavailableError, "The RPX service is temporarily unavailable."
          else
            raise APICallError, "Got error: #{result['err']['msg']} (code: #{code}), HTTP status: #{response.code}"
          end
        end

        result
      end
    end
  end
end
