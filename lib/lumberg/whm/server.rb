module Whm
  class Server
    attr_accessor :host
    attr_accessor :hash
    attr_accessor :url

    def initialize(options)
      opts  = options.dup
      @host = opts.delete(:host)
      @hash = opts.delete(:hash)
      opts ||= {}

      @url = Whm::format_url(@host, opts)
    end

  end
end
