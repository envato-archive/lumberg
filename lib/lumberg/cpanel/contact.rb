module Lumberg
  module Cpanel
    # Public: Allows users to specify contact information and preferences
    class Contact < Base
      def self.api_module; "CustInfo"; end

      # Public: Show your contact information and email notfication settings
      #
      # Returns Hash API response
      def show
        perform_request({ api_function: 'displaycontactinfo' })
      end

      # Public: Updates the user's contact info and settings for email
      # notifications
      #
      # options - Hash options for API call params (default: {})
      #   :email - String email account to send notifications to
      #   :second_email - String secondary email account to send notifications
      #                   to (default: String)
      #   :email_quota - Boolean value. Set to true to be notified when you are
      #                  when one of your email accounts approaches or is over
      #                  quota (default: Boolean)
      #   :disk_quota - Boolean value. Set to true to be notified when you are
      #                 when you are reaching your disk quota (default: Boolean)
      #   :bandwidth - Boolean value. Set to true to be notified when you are
      #                reaching your bandwidth usage limit (default: Boolean)
      #
      # Returns Hash API response
      def update(options = {})
        options[:notify_disk_limit] = options.delete(:disk_quota)
        options[:notify_bandwidth_limit] = options.delete(:bandwidth)
        options[:notify_email_quota_limit] = options.delete(:email_quota)
        perform_request({ api_function: 'savecontactinfo' }.merge(options))
      end
    end
  end
end
