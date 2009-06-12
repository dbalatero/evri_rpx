module Evri
  module RPX
    class Session
      API_VERSION = 'v2'
      API_HOST = 'rpxnow.com'
      ROOT_CA_PATH = File.expand_path(File.join(File.dirname(__FILE__), 
                                                '..', '..', '..', 'certs',
                                                'curl-ca-bundle.crt'))


      class ServiceUnavailableError < StandardError; end
      #class ServiceUpstreamError < StandardError; end
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
      def auth_info(token, options = {})
        params = { 'apiKey' => @api_key,
                   'token' => token }
        json = parse_response(get("/api/#{API_VERSION}/auth_info",
                                  params))
        User.new(json)
      end

      private
      def get(resource, params)
        request = Net::HTTP::Get.new(resource)
        request.form_data = params
        make_request(request)
      end

      def make_request(request)
        http = Net::HTTP.new(API_HOST, 443)
        http.ca_path = ROOT_CA_PATH
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
