module Lumberg
  module Whm
    class Base
      # Whm::Server
      attr_accessor :server

      def initialize(options = {})
        Args.new(options) do |c|
          c.requires :server
        end
     
        @server = setup_server options.delete(:server) 
      end

      def setup_server(value)
        if value.is_a?(Whm::Server) 
          value
        else
          Whm::Server.new value
        end
      end

      # Creates WHM::Whatever.new(:server => @server)
      # automagically
      def auto_accessors
        [:account, :dns, :reseller]
      end

      def method_missing(meth, *args, &block)
        if auto_accessors.include?(meth.to_sym)
          ivar = instance_variable_get("@#{meth}")
          if ivar.nil?
            constant  = Whm.const_get(meth.to_s.capitalize)
            return instance_variable_set("@#{meth}", constant.new(:server => @server))
          end
        else
          super
        end
      end
    end
  end
end
