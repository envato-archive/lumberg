module Lumberg
  module Whm
    class Dns
      attr_accessor :server

      def initialize(options ={})
        Args.new(options) do |c|
          c.requires :server
        end

        @server = Whm::setup_server options.delete(:server)
      end

      def add_zone(options = {})
        Args.new(options) do |c|
          c.requires :domain, :ip
          c.optionals :template, :trueowner
        end

        server.perform_request('adddns', options)
      end
    end
  end
end
