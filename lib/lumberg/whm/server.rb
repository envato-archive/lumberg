require 'cgi'

module Lumberg
  module Whm
    class Server
      include Args

      # Server
      attr_accessor :host

      # Remote access hash
      attr_accessor :hash

      # Base URL to the WHM API
      attr_accessor :url

      # API username - default: root
      attr_accessor :user

      # Raw HTTP response from WHM
      attr_accessor :raw_response

      # WHM parsed response
      attr_reader :response

      # HTTP Params used for API requests
      attr_accessor :params

      # WHM API function name
      attr_reader :function

      def initialize(options)
        requires!(options, :host, :hash)

        @host  = options.delete(:host)
        @hash  = Whm::format_hash(options.delete(:hash))
        @user = (options.has_key?(:user) ? options.delete(:user) : 'root')

        @url = Whm::format_url(@host, options)
      end

      def perform_request(function, options = {})
        @function = function
        @params   = format_query(options)
        uri       = URI.parse("#{@url}#{function}?#{@params}")

        # Auth Header
        _url = uri.path
        _url << "?" + uri.query unless uri.query.nil? || uri.query.empty?
        req = Net::HTTP::Get.new(_url)
        req.add_field("Authorization", "WHM #{@user}:#{@hash}")

        # Do the request
        http = Net::HTTP.new(uri.host, uri.port)
        if uri.port == 2087
          # TODO: Install CAs
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          http.use_ssl = true 
        end

        res = http.start do |h|
          h.request(req)
        end
        @raw_response = res
        @response = JSON.parse(@raw_response.body)
        format_response
      end

      protected
      def response_type
        if !@response.respond_to?(:has_key?)
          :unknown
        elsif @response.has_key?('error')
          :error
        elsif @response.has_key?('result')
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
        params  = nil

        case response_type
        when :action
          success = @response['result'].first['status'].to_i == 1
          message = @response['result'].first['statusmsg']
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
        {success: success, message: message, params: params}
      end

      def format_query(hash)
        elements = []
        hash.each do |key, value|
          elements << "#{CGI::escape(key.to_s)}=#{CGI::escape(value.to_s)}"
        end
        elements.sort.join('&')
      end
    end
  end
end
