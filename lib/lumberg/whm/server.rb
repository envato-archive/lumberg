require 'cgi'

module Whm
  class Server
    include Args

    attr_accessor :host
    attr_accessor :hash
    attr_accessor :url
    attr_accessor :user

    def initialize(options)
      requires!(options, :host, :hash)

      @host  = options.delete(:host)
      @hash  = Whm::format_hash(options.delete(:hash))
      @user  ||= 'root'

      @url = Whm::format_url(@host, options)
    end

    def perform_request(function, options = {})
      options = format_query(options)
      uri = "#{@url}#{function}?#{options}"
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
