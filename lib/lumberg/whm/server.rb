module Whm
  class Server
    attr_accessor :host
    attr_accessor :hash
    attr_accessor :url

    def initialize(options)
      opts  = options.dup
      @host = opts.delete(:host)
      @hash = format_hash(opts.delete(:hash))
      opts ||= {}

      @url = Whm::format_url(@host, opts)
    end

    def format_hash(value)
      raise Lumberg::WhmArgumentError unless value.is_a?(String)
      value.gsub!(/\n|\s/, '')
      value
    end
  end
end
