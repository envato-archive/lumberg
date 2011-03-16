module Lumberg
  module Whm
    class Base
      # Whm::Server
      attr_accessor :server

      #
      # ==== Required 
      #  * <tt>:server</tt> - PENDING
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

    end
  end
end
