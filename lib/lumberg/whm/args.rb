module Lumberg
  module Whm
    module Args
      # Check the included hash for the included parameters, and ensure they aren't blank.
      #
      # ==== Example
      # 
      #    class User
      #      def initialize
      #        requires!(options, :username, :password)
      #      end
      #    end
      #
      #    >> User.new
      #    ArgumentError: Missing required parameter: username
      #
      #    >> User.new(:username => "john")
      #    ArgumentError: Missing required parameter: password
      def requires!(hash, *params)
        params.each do |param| 
          if param.is_a?(Array)
            raise Whm::ArgumentError.new("Missing required parameter: #{param.first}") unless hash.has_key?(param.first) 
            raise Whm::ArgumentError.new("Required parameter cannot be blank: #{param.first}") if (hash[param.first].nil? || hash[param.first].empty?)
          else
            raise Whm::ArgumentError.new("Missing required parameter: #{param}") unless hash.has_key?(param) 
            raise Whm::ArgumentError.new("Required parameter cannot be blank: #{param}") if (hash[param].nil? || hash[param].empty?)
          end
        end
      end


      # Checks to see if supplied params (which are booleans) contain
      # either a 1 ("Yes") or 0 ("No") value.
      def booleans!(hash, *params)
        params.each do |param|
          if param.is_a?(Array)
            raise ArgumentError.new("Boolean parameter must be \"1\" or \"0\": #{param.first}") unless hash[param.first].to_s.match(/(1|0)/)          
          else
            raise ArgumentError.new("Boolean parameter must be \"1\" or \"0\": #{param}") unless hash[param].to_s.match(/(1|0)/)
          end
        end
      end

      # Checks the hash to see if the hash includes any parameter
      # which is not included in the list of valid parameters.
      #
      # ==== Example
      #
      #    class User
      #      def initialize
      #        valid_options!(options, :username)
      #      end
      #    end
      #
      #    >> User.new(:username => "josh")
      #    => #<User:0x18a1190 @username="josh">
      #
      #    >> User.new(:username => "josh", :credit_card => "5105105105105100")
      #    ArgumentError: Not a valid parameter: credit_card
      def valid_options!(hash, *params)
        keys = hash.keys
        
        keys.each do |key|
          raise ArgumentError.new("Not a valid parameter: #{key}") unless params.include?(key)
        end
      end  
    end
  end
end
