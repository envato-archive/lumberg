module Lumberg
  module Whm
    class Args

      # Arguments that must be present
      attr_writer :requires

      # Arguments that can be present
      attr_writer :optionals

      # Arguments that must be boolean
      attr_writer :booleans

      # Check the included hash for the included parameters.
      # Raises WhmArgumentError when it's mising the proper params
      #
      # ==== Example
      # 
      #    Args.new(options) do |c|
      #      c.requries  = [:user, :pass]
      #      c.booleans  = [:name]
      #      c.optionals = [:whatever]
      #    end
      def initialize(options)
        yield self 
        requires!(options, requires) unless requires.empty?
        booleans!(options, booleans) unless booleans.empty?
        valid_options!(options, optionals) unless optionals.empty?
      end

      def requires
        @requires ||= []
      end

      def booleans
        @booleans ||= []
      end

      def optionals
        @optionals ||= []
        @optionals.concat(requires).concat(booleans).uniq
      end

      protected

      def requires!(hash, params)
        params.each do |param| 
          if param.is_a?(Array)
            raise WhmArgumentError.new("Missing required parameter: #{param.first}") unless hash.has_key?(param.first) 
            raise WhmArgumentError.new("Required parameter cannot be blank: #{param.first}") if (hash[param.first].nil? || (hash[param.first].respond_to?(:empty?) && hash[param.first].empty?))
          else
            raise WhmArgumentError.new("Missing required parameter: #{param}") unless hash.has_key?(param) 
            raise WhmArgumentError.new("Required parameter cannot be blank: #{param}") if (hash[param].nil? || (hash[param].respond_to?(:empty?) && hash[param].empty?))
          end
        end
      end


      # Checks to see if supplied params (which are booleans) contain
      # either a 1 ("Yes") or 0 ("No") value.
      def booleans!(hash, params)
        params.each do |param|
          if param.is_a?(Array)
            if hash.include?(param.first) && !hash[param.first].to_s.match(/(1|0)/)
              raise WhmArgumentError.new("Boolean parameter must be \"1\" or \"0\": #{param.first}")
            end
          else
            if hash.include?(param) && !hash[param].to_s.match(/(1|0)/)
              raise WhmArgumentError.new("Boolean parameter must be \"1\" or \"0\": #{param}")
            end
          end
        end
      end

      def valid_options!(hash, params)
        keys = hash.keys
        
        keys.each do |key|
          raise WhmArgumentError.new("Not a valid parameter: #{key}") unless params.include?(key)
        end
      end  
    end
  end
end
