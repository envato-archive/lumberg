module Lumberg
  module Cpanel
    class Contact < Base
      def self.api_module; "Contactus"; end

      # Public: Send a support request.
      #
      # options - Hash options for API call params (default: {}):
      #  :email   - String destination email address.
      #  :issue   - String brief explantation of issue (body text).
      #  :subject - String subject line.
      #
      # Returns Hash API response.
      def contact(options = {})
        perform_request({
          :api_function => "sendcontact"
        }.merge(options))
      end

      # Public: Check if the account's contact option enabled.
      #
      # options - Hash options for API call params (default: {}):
      #
      # Returns Hash API response.
      def status(options = {})
        perform_request({
          :api_function => "isenabled",
        }.merge(options))
      end
    end
  end
end
