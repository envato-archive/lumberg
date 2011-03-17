module Lumberg

      #
      # ==== Optional 
      #  * <tt>:whatever</tt> - PENDING
  module Whm
    class Args
      attr_reader :required_params, :boolean_params, :optional_params, :one_of_params
      attr_reader :options
      # Check the included hash for the included parameters.
      # Raises WhmArgumentError when it's mising the proper params
      #
      # ==== Example
      # 
      #    Args.new(options) do |c|
      #      c.requries  :user, :pass
      #      c.booleans  :name
      #      c.optionals :whatever
      #    end
      def initialize(options)
        @required_params ||= []
        @boolean_params  ||= []
        @optional_params ||= []
        @one_of_params   ||= []
        @options = options

        yield self 

        requires!
        booleans!
        one_ofs!
        valid_options!
      end

      # Specifies the required arguments
      def requires(*values)
        @optional_params.concat(values)
        @required_params = values
      end

      # Specifies which arguments are boolean
      def booleans(*values)
        @optional_params.concat(values)
        @boolean_params = values
      end

      # Specifies which arguments are optional
      def optionals(*values)
        @optional_params.concat(values)
      end

      # Specifies which arguments take one of a set of arguments
      def one_of(*values)
        @optional_params.concat(values)
        @one_of_params = values 
      end

      protected

      # Verifies that all required arguments are present
      def requires!
        @required_params.each do |param| 
          key = (param.is_a?(Array) ? param.first : param)
          verify_required_param(key)
        end
      end


      # Checks to see if supplied params (which are booleans) contain
      # either a 1 ("Yes") or 0 ("No") value.
      def booleans!
        @boolean_params.each do |param|
          key = (param.is_a?(Array) ? param.first : param)
          verify_boolean_param(key)
        end
      end

      # Verifies that only valid arguments were set
      def valid_options!
        @options.keys.uniq.each do |key|
          raise WhmArgumentError.new("Not a valid parameter: #{key}") unless @optional_params.include?(key)
        end
      end  

      # Verifies that the one_of arguments were used correctly
      def one_ofs!
        if @one_of_params.size > 1
          specified = @options.keys.select { |key| @one_of_params.include?(key) }.uniq
          if specified.size > 1 || specified.size == 0
            raise WhmArgumentError.new("The parameters may include only one of '#{@one_of_params.join(', ')}'") 
          end
        else
          raise WhmArgumentError.new("One of requires two or more items") unless @one_of_params.empty?
        end
      end

      private
      
      # Internal method for verifiying required arguments
      def verify_required_param(param)
        raise WhmArgumentError.new("Missing required parameter: #{param}") unless @options.has_key?(param) 
        raise WhmArgumentError.new("Required parameter cannot be blank: #{param}") if (@options[param].nil? || (@options[param].respond_to?(:empty?) && @options[param].empty?))
      end

      # Internal method for verifying boolean arguments
      def verify_boolean_param(param)
        if @options.include?(param) && ![true, false].include?(@options[param])
          raise WhmArgumentError.new("Boolean parameter must be \"true\" or \"false\": #{param}")
        end
      end
    end
  end
end
