module Lumberg
  module Whm
    class Reseller < Base
      def create(options = {})
        Args.new(options) do |c| 
          c.requires :username 
          c.booleans :makeowner
        end
        options[:user] = options.delete(:username)
        server.perform_request('setupreseller', options)
      end
    end
  end
end
