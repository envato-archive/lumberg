module Lumberg
  module Cpanel
    class Base < Whm::Base
      @@server = nil

      def initialize(options = {})
        if options.empty? && !@@server.nil?
          super :server => @@server
        else
          super options
        end

        @@server = @server
      end
    end
  end
end
