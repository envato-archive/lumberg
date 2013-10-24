module Lumberg
  module Cpanel
    class BoxTrapper < Base
      # Public: Get list of email accounts and their BoxTrapper statuses.
      #
      # options - Hash options for API call params (default: {}):
      #   :regex - String regular expression to filter search results
      #            (optional).
      #
      # Returns Hash API response.
      def list(options = {})
        perform_request({
          api_function: "accountmanagelist"
        }.merge(options))
      end
    end
  end
end
