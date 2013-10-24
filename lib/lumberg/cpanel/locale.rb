module Lumberg
  module Cpanel
    # Public: Allows access into cPanel's language system
    class Locale < Base
      # Public: Retrieve a user's character set encoding
      #
      # Returns Hash API response
      def show
        perform_request({ api_function: 'get_encoding' })
      end
    end
  end
end


