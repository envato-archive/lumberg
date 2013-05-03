module Lumberg
  class Config
    attr_accessor :options

    def initialize
      @options = {}
    end

    def [](v)
      @options[v]
    end

    # Provide debug output
    #
    # output - Boolean or String value. Set it to true to output debugging
    #          messages to $stderr, or specify a file path (default: '')
    #
    # Returns nothing
    def debug(output)
      @options[:debug] = output
    end
  end
end
