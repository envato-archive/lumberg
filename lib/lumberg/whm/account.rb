module Lumberg
  module Whm
    class Account
      include Args

      attr_reader :server

      def initialize(options = {})
        requires!(options, :server)
     
        setup_server options.delete(:server) 
      end

      # WHM functions
      def createacct(options = {})
        requires!(options, :username, :password)
        server.perform_request('createacct', options)
      end

      protected 
      def setup_server(value)
        if value.is_a?(Whm::Server) 
          @server = value
        else
          @server = Whm::Server.new value
        end
      end
    end
  end
end
