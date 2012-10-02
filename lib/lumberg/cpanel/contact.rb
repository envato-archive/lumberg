module Lumberg
  module Cpanel
    class Contact < Base
      def self.api_module; "Contactus"; end

      # Send support request
      #
      # ==== Required
      #  * <tt>:email</tt> - Destination
      #  * <tt>:issue</tt> - Brief explantation
      #  * <tt>:subject</tt> - Subject line
      def contact(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "sendcontact"
        }.merge(options))
      end

      # Is the account's contact option enabled?
      def status(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "isenabled",
        }.merge(options))
      end
    end
  end
end
