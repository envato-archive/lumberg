module Lumberg
  module Whm
    autoload :Server,  'lumberg/whm/server'
    autoload :Account, 'lumberg/whm/account'
    autoload :Dns,     'lumberg/whm/dns'

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

      def setup_server(value)
        if value.is_a?(Whm::Server) 
          value
        else
          Whm::Server.new value
        end
      end

      def symbolize_keys(arg)
        case arg
        when Array
          arg.map { |elem| symbolize_keys elem }
        when Hash
          Hash[
            arg.map { |key, value|  
              k = key.is_a?(String) ? key.gsub('-', '_').to_sym : key
              v = symbolize_keys value
              [k,v]
            }]
        else
          arg
        end
      end
    
      def to_bool(hash, *keys)
        if keys.empty?
          keys = [:all]
        else
          keys.flatten!
        end

        if hash.is_a?(Hash)
          hash = Hash[
            hash.map {|key, value|
              # recurse
              value = to_bool(value) if value.is_a?(Hash)
              value = value.map {|elem| to_bool(elem) } if value.is_a?(Array)

              if (keys.first == :all) || (keys.include?(key) || (keys.include?(key.to_sym)))
                value = (value.to_s.match(/0|1/) ? value.to_i == 1 : value)
              end
              [key, value]
          }]
        end
        hash
      end

      def from_bool(input)
        if input == false
          0
        elsif input == true
          1
        elsif input.is_a?(Hash)
          Hash[ 
            input.map {|k,v| 
              v = from_bool(v)
              [k,v]
            }
          ]
        end
      end

    end
  end
end
