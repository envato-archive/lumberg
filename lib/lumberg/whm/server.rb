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

      # API username - :default => root
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
        Args.new(options) do |c|
          c.requires  :host, :hash
          c.optionals :user, :ssl, :basic_auth
        end

        @ssl_verify ||= false
        @ssl        = options.delete(:ssl)
        @host       = options.delete(:host)
        @hash       = format_hash(options.delete(:hash))
        @user       = (options.has_key?(:user) ? options.delete(:user) : 'root')
        @basic_auth = options.delete(:basic_auth)
        @base_url   = format_url(options)
      end

      def perform_request(function, options = {})
        # WHM sometime uses different keys for the result hash
        @key      = options.delete(:key) || 'result'
        @function = function
        @params   = format_query(options)

        yield self if block_given?

        do_request(@base_url, function, @params)
      end

      def get_hostname
        perform_request('gethostname', {:key => 'hostname'})
      end

      def version
        perform_request('version', {:key => 'version'})
      end

      def load_average
        @force_response_type = :query
        result = perform_request('loadavg')
        result[:success] = result[:params].has_key?(:one)
        result
      end

      def system_load_average(options = {})
        Args.new(options) do |c|
          c.requires "api.version".to_sym
        end

        perform_request('systemloadavg', options.merge(:key => 'data'))
      end

      def languages
        perform_request('getlanglist', {:key => 'lang'})
      end

      def list_ips
        perform_request('listips', {:key => 'result'})
      end

      def add_ip(options = {})
        Args.new(options) do |c|
          c.requires :ip, :netmask
        end

        perform_request('addip', options.merge(:key => 'addip'))
      end

      def delete_ip(options = {})
        Args.new(options) do |c|
          c.requires :ip
          c.optionals :ethernetdev
          c.booleans :skipifshutdown
        end

        perform_request('delip', options.merge(:key => 'delip'))
      end

      def set_hostname(options = {})
        Args.new(options) do |c|
          c.requires :hostname
        end

        perform_request('sethostname', options.merge(:key => 'sethostname'))
      end

      def set_resolvers(options = {})
        Args.new(options) do |c|
          c.requires :nameserver1
          c.optionals :nameserver2, :nameserver3
        end

        perform_request('setresolvers', options.merge(:key => 'setresolvers'))
      end

      def show_bandwidth(options = {})
        Args.new(options) do |c|
          c.optionals :month, :year, :showres, :search, :searchtype
        end

        perform_request('showbw', options.merge(:key => 'bandwidth'))
      end

      def set_nv_var(options = {})
        Args.new(options) do |c|
          c.requires :key
          c.optionals :value
        end

        perform_request('nvset', options.merge(:key => 'nvset'))
      end

      def get_nv_var(options = {})
        Args.new(options) do |c|
          c.requires :key
          c.optionals :value
        end

        perform_request('nvget', options.merge(:key => 'nvget'))
      end

      def reboot
        perform_request('reboot', {:key => "reboot"})
      end

    private
      
      def do_request(uri, function, params)
        @response = Faraday.new(:url => uri, :ssl => ssl_options) do |c|
          c.basic_auth @user, @hash
          c.params = params
          c.request :url_encoded
          c.response :logger, create_logger_instance
          # TODO: c.response :skip_bad_headers
          # TODO: c.response :whm_errors
          c.response :json
          c.adapter :net_http
        end.get(function).body
        # TODO: Move to middleware
        format_response
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
            :verify_mode => OpenSSL::SSL::VERIFY_PEER,
            :ca_file     => File.join(Lumberg::base_path, "cacert.pem")
          }
        else
          {
            :verify_mode => OpenSSL::SSL::VERIFY_NONE
          }
        end
      end

      # TODO: Move to middleware
      def format_response
        success, message, params = false, nil, {}

        case response_type
          when :action
            success, message, params = format_action_response
          when :query
            success, message, params = format_query_response
          when :error
            message = @response['error']
          when :unknown
            message = "Unknown error occurred #{@response.inspect}"
        end
 
        params = Whm::to_bool(params, @boolean_params) unless @boolean_params.nil?

        # Reset this for subsequent requests
        @force_response_type = nil
        {:success => success, :message => message, :params => Whm::symbolize_keys(params)}
      end

      # TODO: Move to middleware
      def format_action_response
        # Some API methods ALSO return a 'status' as
        # part of a result. We only use this value if it's
        # part of the results hash
        item = @response[@key]

        unless item.is_a?(Array) || item.is_a?(Hash)
          res = {@key => item}
          success, message = true, ""
        else
          result = nil
          if item.first.is_a?(Hash)
            result = item.first
            res = (item.size > 1 ? item.dup : item.first.dup)
          else
            res = item.dup

            # more hacks for WHM silly API
            if @response.has_key?('result')
              result_node = @response['result']
              node_with_key_status = result_node.is_a?(Hash) && result_node.has_key?('status')
              result = (node_with_key_status ? result_node : result_node.first)
            else
              res.delete('status')
              res.delete('statusmsg')
            end
          end

          unless result.nil?
            success = result['status'].to_i == 1
            message = result['statusmsg']
          end
        end

        return success, message, res
      end

      # TODO: Move to middleware
      def format_query_response
        success = @response['status'].to_i == 1
        message = @response['statusmsg']

        # returns the rest as a params arg
        res = @response.dup
        res.delete('status')
        res.delete('statusmsg')

        return success, message, res
      end
      
      def response_type
        if !@force_response_type.nil?
          @force_response_type
        elsif !@response.respond_to?(:has_key?)
          :unknown
        elsif @response.has_key?('error')
          :error
        elsif @response.has_key?(@key)
          :action
        elsif @response.has_key?('status') && @response.has_key?('statusmsg')
          :query
        else
          :unknown
        end
      end

      def format_url(options = {})
        @ssl = true if @ssl.nil?
        port  = (@ssl ? 2087 : 2086)
        proto = (@ssl ? 'https' : 'http')

        "#{proto}://#{@host}:#{port}/json-api/"
      end

      def format_hash(hash)
        raise Lumberg::WhmArgumentError.new("Missing WHM hash") unless hash.is_a?(String)
        hash.gsub(/\n|\s/, '')
      end


      # Creates WHM::Whatever.new(:server => @server)
      # automagically
      def auto_accessors
        [:account, :dns, :reseller]
      end

      def method_missing(meth, *args, &block)
        if auto_accessors.include?(meth.to_sym)
          ivar = instance_variable_get("@#{meth}")
          if ivar.nil?
            constant = Whm.const_get(meth.to_s.capitalize)
            return instance_variable_set("@#{meth}", constant.new(:server => self))
          else
            return ivar
          end
        else
          super
        end
      end

    end
  end
end