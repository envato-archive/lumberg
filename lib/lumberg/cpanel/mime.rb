module Lumberg
  module Cpanel
    # Public: Allows users to list mime types and handlers
    class Mime < Base
      # Public: List mime types associated with Apache
      #
      # options - Hash options for API call params (default: {})
      #   :system - String parameter allows you to specify whether or not to
      #             only return system wide mime types (default: '')
      #   :user - String parameter allows you to specify whether or not to
      #             only return user defined mime types (default: '')
      #
      # Returns Hash API response
      def list(options = {})
        perform_request({ api_function: 'listmime' }.merge(options))
      end

      # Public: List handlers associated with Apache
      #
      # options - Hash options for API call params (default: {})
      #   :system - String parameter allows you to specify whether or not to
      #             only return system wide handlers (default: '')
      #   :user - String parameter allows you to specify whether or not to
      #             only return user defined handlers (default: '')
      #
      # Returns Hash API response
      def handlers(options = {})
        perform_request({ api_function: 'listhandlers' }.merge(options))
      end
    end
  end
end


