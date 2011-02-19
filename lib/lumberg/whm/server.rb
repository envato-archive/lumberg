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
  end
end
