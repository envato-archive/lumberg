module Lumberg
  module Cpanel
    class Cron < Base
      # Public: Set default cron notification email address.
      #
      # options - Hash options for API call params (default: {}):
      #  :email - String email address to receive notifications.
      #
      # Returns Hash API response.
      def set_email(options = {})
        perform_request({
          :api_function => "set_email"
        }.merge(options))
      end

      # Public: Get the default cron notification email address.
      #
      # options - Hash options for API call params (default: {})
      #
      # Returns Hash API response.
      def email(options = {})
        perform_request({
          :api_function => "get_email"
        }.merge(options))
      end

      # Public: Get list of cron jobs.
      #
      # options - Hash options for API call params (default: {})
      #
      # Returns Hash API response.
      def list(options = {})
        perform_request({
          :api_function => "listcron"
        }.merge(options))
      end

      # Public: Add a cron job.
      #
      # options - Hash options for API call params (default: {}):
      #  :command - String command to execute.
      #  :day     - String day value.
      #  :hour    - String hour value.
      #  :minute  - String minute value.
      #  :month   - String month value.
      #  :weekday - String weekday value.
      #
      # Returns Hash API response.
      def add(options = {})
        perform_request({
          :api_function => "add_line"
        }.merge(options))
      end

      # Public: Remove a cron job.
      #
      # options - Hash options for API call params (default: {}):
      #  :linekey - String linekey of the crontab entry to remove.
      #
      # Returns Hash API response.
      def remove(options = {})
        perform_request({
          :api_function => "remove_line"
        }.merge(options))
      end

      # Public: Edit a crontab entry.
      #
      # options - Hash options for API call params (default: {}):
      #  :command       - String command to execute.
      #  :day           - String day value.
      #  :hour          - String hour value.
      #  :minute        - String minute value.
      #  :month         - String month value.
      #  :weekday       - String weekday value.
      #  :commandnumber - Integer Line of cron entry to edit (optional).
      #                   If not present, :linekey is required.
      #  :linekey       - String Linekey for entry to edit (optional).
      #                   If not present, :commandnumber is required.
      #
      # Returns Hash API response.
      def edit(options = {})
        perform_request({
          :api_function => "edit_line"
        }.merge(options))
      end
    end
  end
end
