module Lumberg
  module Cpanel
    class Cron < Base
      def self.api_module; "Cron"; end

      # Set default cron notification email address
      #
      # ==== Required
      #  * <tt>:email</tt> - Email address to receive notifications
      def set_email(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "set_email"
        }.merge(options))
      end


      # Get the default cron notification email address
      def email(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "get_email"
        }.merge(options))
      end

      # List cron jobs
      def list(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listcron"
        }.merge(options))
      end

      # Add a cron job
      #
      # ==== Required
      #  * <tt>:command</tt> - Command to execute
      #  * <tt>:day</tt> - Day value
      #  * <tt>:hour</tt> - Hour value
      #  * <tt>:minute</tt> - Minute value
      #  * <tt>:month</tt> - Month value
      #  * <tt>:weekday</tt> - Weekdady value
      def add(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "add_line"
        }.merge(options))
      end

      # Remove a cron job
      #
      # ==== Required
      #  * <tt>:linekey</tt> - Linekey of the crontab entry to remove
      def remove(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "remove_line"
        }.merge(options))
      end

      # Edit a crontab entry
      #
      # ==== Required
      #  * <tt>:command</tt> - Command to execute
      #  * <tt>:day</tt> - Day value
      #  * <tt>:hour</tt> - Hour value
      #  * <tt>:minute</tt> - Minute value
      #  * <tt>:month</tt> - Month value
      #  * <tt>:weekday</tt> - Weekday value
      #
      # ==== Optional
      #  * <tt>:commandnumber</tt> - Line of cron entry to edit.
      #                              If not present, :linekey is required
      #  * <tt>:linekey</tt> - Linekey for entry to edit. If not present,
      #                       :commandnumber is required
      def edit(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "edit_line"
        }.merge(options))
      end
    end
  end
end
