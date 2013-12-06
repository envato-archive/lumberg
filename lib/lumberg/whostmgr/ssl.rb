module Lumberg
  module Whostmgr
    class Ssl < Base
      # Public: Removes a SSL certificate
      #
      # options - Hash options for API call params (default: {}):
      #  :domain   - Domain name for the cert removal
      #
      # Returns Hash API response
      def remove(options = {})
        host = options.delete(:domain)
        perform_request({ function: "realdelsslhost", host: host })
      end
    end
  end
end
