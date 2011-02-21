require 'cgi'

module Whm
  class Server
    include Args

    attr_accessor :host
    attr_accessor :hash
    attr_accessor :url
    attr_accessor :user
    attr_accessor :raw_response
    attr_accessor :params

    def initialize(options)
      requires!(options, :host, :hash)

      @host  = options.delete(:host)
      @hash  = Whm::format_hash(options.delete(:hash))
      @user  ||= 'root'

      @url = Whm::format_url(@host, options)
    end

    def perform_request(function, options = {})
      @params = format_query(options)

      uri = URI.parse("#{@url}#{function}?#{@params}")

      # Auth Header
      req = Net::HTTP::Get.new(uri.path)
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
