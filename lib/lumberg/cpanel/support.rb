module Lumberg
  module Cpanel
    class Support < Base
      def self.api_module; "Contactus"; end

      # Public: Send a support request.
      #
      # options - Hash options for API call params (default: {}):
      #  :email   - String destination email address.
      #  :issue   - String brief explantation of issue (body text).
      #  :subject - String subject line.
      #
      # Returns Hash API response.
      def open_ticket(options = {})
        perform_request({
          :api_function => "sendcontact"
        }.merge(options))
      end

      # Public: Check if you can open a support ticket, or if you are able to
      # contact your hosting provider through Cpanel
      #
      # Returns Hash API response
      def contactable
        perform_request({ :api_function => "isenabled" })
      end
    end
  end
end
