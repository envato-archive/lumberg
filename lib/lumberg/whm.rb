require 'lumberg/whm/server'

module Whm
  class << self
    def format_url(earl, options = {})
      options[:ssl] = true if options[:ssl].nil?

      port  = (options[:ssl] ? 2087 : 2086)
      proto = (options[:ssl] ? 'https' : 'http')

      "#{proto}://#{earl}:#{port}"
    end
  end
end
