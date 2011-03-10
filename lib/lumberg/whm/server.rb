require 'cgi'

module Lumberg
  module Whm
    class Server
      # Server
      attr_accessor :host

      # Remote access hash
      attr_accessor :hash

      # Base URL to the WHM API
      attr_accessor :base_url

      # API username - :default => root
      attr_accessor :user

      # Raw HTTP response from WHM
      attr_accessor :raw_response

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

      def initialize(options)
        Args.new(options) do |c|
          c.requires  :host, :hash
          c.optionals :user, :ssl
        end

        @ssl_verify ||= false
        @ssl        = options.delete(:ssl)
        @host       = options.delete(:host)
        @hash       = format_hash(options.delete(:hash))
        @user       = (options.has_key?(:user) ? options.delete(:user) : 'root')

        @base_url   = format_url(options)
      end

      def perform_request(function, options = {})
        @function = function

        # WHM sometime uses different keys for the result hash
        @key  = options.delete(:key) || 'result'

        @params   = format_query(options)
        uri       = URI.parse("#{@base_url}#{function}?#{@params}")

        yield self if block_given?

        # Setup request URL
        url = uri.path
        url << "?" + uri.query unless uri.query.nil? || uri.query.empty?

        # Add Auth Header
        req = Net::HTTP::Get.new(url)
        req.add_field("Authorization", "WHM #{@user}:#{@hash}")

        begin
          # Do the request
          res = do_request(uri, req)
        rescue
          raise "Error when sending the request. Enable debug output by setting the environment variable LUMBERG_DEBUG and try again."
        end

        @raw_response = res
        @response     = JSON.parse(@raw_response.body)
        format_response
      end

      protected
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

      def format_response
        success = false
        message = nil
        params  = {}

        case response_type
          when :action
            success, message, res = format_action_response
            params  = res
          when :query
            success, message, res = format_query_response
            params = res
          when :error
            message = @response['error']
          when :unknown
            message = "Unknown error occurred #{@response.inspect}"
        end
 
        if !@boolean_params.nil?
          params = Whm::to_bool(params, @boolean_params)
        end

        {:success => success, :message => message, :params => Whm::symbolize_keys(params)}
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

      def format_query(hash)
        elements = []
        hash.each do |key, value|
          value = 1 if value === true
          value = 0 if value === false
          elements << "#{CGI::escape(key.to_s)}=#{CGI::escape(value.to_s)}"
        end
        elements.sort.join('&')
      end

      private

      def do_request(uri, req)
        http = Net::HTTP.new(uri.host, uri.port)
        http.set_debug_output($stderr) if ENV['LUMBERG_DEBUG']

        if uri.port == 2087
          if @ssl_verify
            http.verify_mode = OpenSSL::SSL::VERIFY_PEER
            http.ca_file = File.join(Lumberg::base_path, "cacert.pem")
          else
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end
          http.use_ssl = true 
        end

        http.start do |h|
          h.request(req)
        end
      end

      def format_action_response
        # Some API methods ALSO return a 'status' as
        # part of a result. We only use this value if it's
        # part of the results hash
        unless @response[@key].is_a?(Array) || @response[@key].is_a?(Hash)
          res = {@key => @response[@key]}
          success = true
          message = ""
        else
          if @response[@key].first.is_a?(Hash)
            success = @response[@key].first['status'].to_i == 1
            message = @response[@key].first['statusmsg']
            if @response[@key].size > 1
              res     = @response[@key].dup
            else
              res     = @response[@key].first.dup
            end
          else
            res     = @response[@key].dup

            # more hacks for WHM silly API
            if @response.has_key?('result')
              success = @response['result'].first['status'] == 1
              message = @response['result'].first['statusmsg']
            else
              res.delete('status')
              res.delete('statusmsg')
            end
          end
        end

        return success, message, res
      end

      def format_query_response
        success = @response['status'].to_i == 1
        message = @response['statusmsg']

        # returns the rest as a params arg
        res = @response.dup
        res.delete('status')
        res.delete('statusmsg')

        return success, message, res
      end
    end
  end
end
