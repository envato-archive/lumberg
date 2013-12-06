Faraday.register_middleware :response, format_whm: Lumberg::FormatWhm

module Lumberg
  module Whm
    class Server < Base
      # Server
      attr_accessor :host

      # Remote access hash
      attr_accessor :hash

      # Base URL to the WHM API
      attr_accessor :base_url

      # Enable Basic Authentication with API - default false
      attr_accessor :basic_auth

      # API username - default: root
      attr_accessor :user

      # WHM parsed response
      attr_reader :response

      # HTTP Params used for API requests
      attr_accessor :params

      # WHM API function name
      attr_reader :function

      # Use ssl?
      attr_accessor :ssl

      # HTTP SSL verify mode
      attr_accessor :ssl_verify

      # Returned params to transfor to booleans
      attr_accessor :boolean_params

      # Force response type...ARG!
      attr_accessor :force_response_type

      # HTTP read/open timeout
      attr_accessor :timeout

      # Whostmgr
      attr_accessor :whostmgr

      #
      # ==== Required
      #  * <tt>:host</tt> - PENDING
      #  * <tt>:hash</tt> - PENDING
      #
      # ==== Optional
      #  * <tt>:user</tt> - PENDING
      #  * <tt>:ssl</tt> - PENDING
      #  * <tt>:basic_auth</tt>
      def initialize(options)
        @ssl_verify ||= false
        @ssl        = options.delete(:ssl)
        @host       = options.delete(:host)
        @hash       = format_hash(options.delete(:hash))
        @user       = (options.has_key?(:user) ? options.delete(:user) : 'root')
        @basic_auth = options.delete(:basic_auth)
        @timeout    = options.delete(:timeout)
        @whostmgr   = options.delete(:whostmgr)

        validate_server_host

        @base_url   = format_url(options)
      end

      def perform_request(function, options = {})
        # WHM sometime uses different keys for the result hash
        @response_key = options.delete(:response_key) || 'result'
        @function = function
        @params   = format_query(options)

        yield self if block_given?

        do_request(@base_url, function, @params)
      end

      def get_hostname
        perform_request('gethostname', {response_key: 'hostname'})
      end

      def version
        perform_request('version', {response_key: 'version'})
      end

      def load_average
        @force_response_type = :query
        result = perform_request('loadavg')
        result[:success] = result[:params].has_key?(:one)
        result
      end

      def system_load_average(options = {})
        perform_request('systemloadavg', options.merge(response_key: 'data'))
      end

      def languages
        perform_request('getlanglist', {response_key: 'lang'})
      end

      def themes
        perform_request('getlanglist', {response_key: 'themes'})
      end

      def list_ips
        perform_request('listips', {response_key: 'result'})
      end

      def get_tweaksetting(options = {})
        request = perform_request('get_tweaksetting',
          options.merge(
            response_key:     'data',
            :'api.version' => 1
          )
        )

        request[:success] = !request[:params].empty?
        request
      end

      def set_tweaksetting(options = {})
        request = perform_request('set_tweaksetting',
          options.merge(
            response_key:     'metadata',
            :'api.version' => 1
          )
        )

        request[:success] = (request[:params][:reason] == 'OK')
        request
      end

      def add_ip(options = {})
        perform_request('addip', options.merge(response_key: 'addip'))
      end

      def delete_ip(options = {})
        perform_request('delip', options.merge(response_key: 'delip'))
      end

      def set_hostname(options = {})
        perform_request('sethostname', options.merge(response_key: 'sethostname'))
      end

      def set_resolvers(options = {})
        perform_request('setresolvers', options.merge(response_key: 'setresolvers'))
      end

      def show_bandwidth(options = {})
        perform_request('showbw', options.merge(response_key: 'bandwidth'))
      end

      def set_nv_var(options = {})
        perform_request('nvset', options.merge(response_key: 'nvset'))
      end

      def get_nv_var(options = {})
        perform_request('nvget', options.merge(response_key: 'nvget'))
      end

      def reboot
        perform_request('reboot', {response_key: "reboot"})
      end

      def account
        @account ||= Account.new(server: self)
      end

      def dns
        @dns ||= Dns.new(server: self)
      end

      def reseller
        @reseller ||= Reseller.new(server: self)
      end

      def cert
        @cert ||= Cert.new(server: self)
      end

    private

      def do_request(uri, function, params)
        @response = Faraday.new(url: uri, ssl: ssl_options) do |c|
          if basic_auth
            c.basic_auth @user, @hash
          else
            c.headers['Authorization'] = "WHM #{@user}:#{@hash}"
          end

          c.params = params
          c.request :url_encoded
          c.response :format_whm, @force_response_type, @response_key, @boolean_params
          c.response :logger, create_logger_instance
          c.response :json unless @force_response_type == :whostmgr
          c.adapter :net_http
          c.options[:timeout] = timeout if timeout
        end.get(function).body
        @force_response_type = nil
        @response
      end

      def format_query(hash)
        hash.inject({}) do |params, (key, value)|
          value = 1 if value === true
          value = 0 if value === false
          params[key] = value
          params
        end
      end

      def create_logger_instance
        Logger.new(Lumberg.configuration[:debug].is_a?(TrueClass) ? $stderr : Lumberg.configuration[:debug])
      end

      def ssl_options
        if @ssl_verify
          {
            verify_mode: OpenSSL::SSL::VERIFY_PEER,
            ca_file:     File.join(Lumberg::base_path, "cacert.pem")
          }
        else
          {
            verify_mode: OpenSSL::SSL::VERIFY_NONE
          }
        end
      end

      def format_url(options = {})
        @ssl = true if @ssl.nil?
        port  = (@ssl ? 2087 : 2086)
        proto = (@ssl ? 'https' : 'http')

        api = @whostmgr ? "scripts2" : "json-api"

        "#{proto}://#{@host}:#{port}/#{api}/"
      end

      def format_hash(hash)
        raise Lumberg::WhmArgumentError.new("Missing WHM hash") unless hash.is_a?(String)
        hash.gsub(/\n|\s/, '')
      end

      def validate_server_host
        Resolv.getaddress(@host)
      rescue Resolv::ResolvError
        raise Lumberg::WhmArgumentError.new(
          "Unable to resolve #{@host}"
        )
      end
    end
  end
end
