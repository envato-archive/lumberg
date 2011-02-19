module Whm
  class Server
    attr_accessor :host
    attr_accessor :hash
    attr_accessor :url
    attr_accessor :user

    def initialize(options)
      opts   = options.dup
      @host  = opts.delete(:host)
      @hash  = Whm::format_hash(opts.delete(:hash))
      @user  ||= 'root'
      opts   ||= {}

      @url = Whm::format_url(@host, opts)
    end

  end
end
