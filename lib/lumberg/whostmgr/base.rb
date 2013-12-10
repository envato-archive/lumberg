module Lumberg
  module Whostmgr
    class Base < Whm::Base
      def perform_request(options = {})
        function = options.delete(:function)

        server.force_response_type = :whostmgr

        server.perform_request function, options.merge({ whostmgr: true })
      end
    end
  end
end
