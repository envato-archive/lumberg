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

      def list
       result = server.perform_request('listresellers', :key => 'reseller')
       result[:success] = true
       result
      end
    end
  end
end
