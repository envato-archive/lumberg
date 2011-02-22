module Lumberg
  module Whm
    autoload :Args,    'lumberg/whm/args'
    autoload :Server,  'lumberg/whm/server'
    autoload :Account, 'lumberg/whm/account'

    class << self
      def format_url(earl, options = {})
        options[:ssl] = true if options[:ssl].nil?

        port  = (options[:ssl] ? 2087 : 2086)
        proto = (options[:ssl] ? 'https' : 'http')

        "#{proto}://#{earl}:#{port}/json-api/"
      end

      def format_hash(value)
        value = value.dup unless value.nil?
        raise Lumberg::WhmArgumentError.new("Missing WHM hash") unless value.is_a?(String)
        value.gsub!(/\n|\s/, '')
        value
      end

      def symbolize_keys(arg)
        case arg
        when Array
          arg.map { |elem| symbolize_keys elem }
        when Hash
          Hash[
            arg.map { |key, value|  
              k = key.is_a?(String) ? key.to_sym : key
              v = symbolize_keys value
              [k,v]
            }]
        else
          arg
        end
      end
    end
  end
end
