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
          :api_function => "set_email",
          :api_username => options.delete(:api_username)
        }, {
          :email => options.delete(:email)
        })
      end


      # Get the default cron notification email address
      def email(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "get_email",
          :api_username => options.delete(:api_username)
        })
      end

      # List cron jobs
      def list(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listcron",
          :api_username => options.delete(:api_username)
        })
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
          :api_function => "add_line",
          :api_username => options.delete(:api_username)
        }, {
          :command => options.delete(:command),
          :day     => options.delete(:day),
          :hour    => options.delete(:hour),
          :minute  => options.delete(:minute),
          :month   => options.delete(:month),
          :weekday => options.delete(:weekday)
        })
      end

      # Remove a cron job
      #
      # ==== Required
      #  * <tt>:linekey</tt> - Linekey of the crontab entry to remove
      def remove(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "remove_line",
          :api_username => options.delete(:api_username)
        }, {
          :linekey => options.delete(:linekey)
        })
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
          :api_function => "edit_line",
          :api_username => options.delete(:api_username)
        }, {
          :command       => options.delete(:command),
          :day           => options.delete(:day),
          :hour          => options.delete(:hour),
          :minute        => options.delete(:minute),
          :month         => options.delete(:month),
          :weekday       => options.delete(:weekday),
          :commandnumber => options.delete(:commandnumber),
          :linekey       => options.delete(:linekey)
        })
      end
    end
  end
end
