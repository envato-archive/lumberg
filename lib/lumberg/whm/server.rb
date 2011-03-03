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

      # HTTP SSL verify mode
      attr_accessor :ssl_verify

      # Returned params to transfor to booleans
      attr_accessor :boolean_params

      def initialize(options)
        Args.new(options) do |c|
          c.requires  :host, :hash
          c.optionals :user
        end

        @ssl_verify ||= false
        @host       = options.delete(:host)
        @hash       = Whm::format_hash(options.delete(:hash))
        @user       = (options.has_key?(:user) ? options.delete(:user) : 'root')

        @base_url = Whm::format_url(@host, options)
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

        # Do the request
        http = Net::HTTP.new(uri.host, uri.port)
        if uri.port == 2087
          if @ssl_verify
            http.verify_mode = OpenSSL::SSL::VERIFY_PEER
            http.ca_file = File.join(Lumberg::base_path, "cacert.pem")
          else
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end
          http.use_ssl = true 
        end

        res = http.start do |h|
          h.request(req)
        end

        @raw_response = res
        @response     = JSON.parse(@raw_response.body)
        format_response
      end

      protected
      def response_type
        if !@response.respond_to?(:has_key?)
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
          # Some API methods ALSO return a 'status' as
          # part of a result. We only use this value if it's
          # part of the results hash
          if @response[@key].first.is_a?(Hash)
            success = @response[@key].first['status'].to_i == 1
            message = @response[@key].first['statusmsg']
            res     = @response[@key].first.dup
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

          params  = res
        when :query
          success = @response['status'].to_i == 1
          message = @response['statusmsg']

          # returns the rest as a params arg
          res = @response.dup
          res.delete('status')
          res.delete('statusmsg')
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

      def format_query(hash)
        elements = []
        hash.each do |key, value|
          value = 1 if value === true
          value = 0 if value === false
          elements << "#{CGI::escape(key.to_s)}=#{CGI::escape(value.to_s)}"
        end
        elements.sort.join('&')
      end
    end
  end
end
