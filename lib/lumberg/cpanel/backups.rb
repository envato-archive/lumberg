module Lumberg
  module Cpanel
    class Backups < Base
      # Public: Get a list backups.
      #
      # options - Hash options for API call params (default: {})
      #
      # Returns Hash API response.
      def list(options = {})
        perform_request({
          api_function: "listfullbackups"
        }.merge(options))
      end
    end
  end
end
