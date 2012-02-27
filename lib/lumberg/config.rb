module Lumberg
  # Holds the configuration for Lumberg
  class Config
    attr_accessor :options

    def initialize
      @options = {}
    end

    def [](v)
      @options[v]
    end

    # Debug output.  value can be either true to output to $stderr or a path to a file
    def debug(output)
      @options[:debug] = output
    end
  end
end