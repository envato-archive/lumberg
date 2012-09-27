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
          :api_function => "sendcontact",
          :api_username => options.delete(:api_username)
        }, {
          :email   => options.delete(:email),
          :issue   => options.delete(:issue),
          :subject => options.delete(:subject)
        })
      end

      # Is the account's contact option enabled?
      def status(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "isenabled",
          :api_username => options.delete(:api_username)
        })
      end
    end
  end
end
