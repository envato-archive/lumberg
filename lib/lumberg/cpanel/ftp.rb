module Lumberg
  module Cpanel
    class Ftp < Base
      def self.api_module; "Ftp"; end

      # Public: List FTP accounts associated with the authenticated user's account
      #
      # options              - Hash options for API call params (default: {}):
      #  :include_acct_types - specify which FTP account types to include
      #  :skip_acct_types    - specify which FTP account types to exclude
      #
      # Returns Hash API response.
      def list_ftp(options = {})
        perform_request({
          api_function: "listftp"
        }.merge(options))
      end

      # Public: Retrieve a list of FTP sessions associated with the account
      #
      # Returns Hash API response.
      def list_ftp_sessions(options = {})
        perform_request({
          api_function: "listftpsessions"
        }.merge(options))
      end

      # Public: Generate a list of FTP accounts associated with a cPanel account
      #         The list will contain each account's disk information
      #
      # options              - Hash options for API call params (default: {}):
      #  :dirhtml            - prepend the 'dir' return variable with a URL
      #  :include_acct_types - specify which FTP account types to include
      #  :skip_acct_types    - specify which FTP account types to exclude
      #
      # Returns Hash API response.
      def list_ftp_with_disk(options = {})
        perform_request({
          api_function: "listftpwithdisk"
        }.merge(options))
      end

      # Public: Change an FTP account's password
      #
      # options   - Hash options for API call params (default: {}):
      #  :user    - The username portion of the FTP account
      #  :pass    - The new password for the FTP account
      #
      # Returns Hash API response.
      def passwd(options = {})
        perform_request({
          api_function: "passwd"
        }.merge(options))
      end

      # Public: Add a new FTP account
      #
      # options   - Hash options for API call params (default: {}):
      #  :user    - The username portion of the new FTP account, without the domain
      #  :pass    - The password for the new FTP account
      #  :quota   - The new FTP account's quota. The default, 0, indicates that
      #             the account will not use a quota.
      #  :homedir - The path to the FTP account's root directory. This value
      #             should be relative to the account's home directory
      #
      # Returns Hash API response.
      def add_ftp(options = {})
        perform_request({
          api_function: "addftp"
        }.merge(options))
      end

      # Public: Change an FTP account's quota
      #
      # options   - Hash options for API call params (default: {}):
      #  :user    - The username portion of the FTP account
      #  :quota   - The new quota (in megabytes) for the FTP account
      #
      # Returns Hash API response.
      def set_quota(options = {})
        perform_request({
          api_function: "setquota"
        }.merge(options))
      end

      # Public: Delete an FTP account
      #
      # options   - Hash options for API call params (default: {}):
      #  :user    - The name of the account to be removed
      #  :destroy - A boolean value that indicates whether or not the FTP account's
      #             home directory should also be deleted
      #
      # Returns Hash API response.
      def del_ftp(options = {})
        perform_request({
          api_function: "delftp"
        }.merge(options))
      end
    end
  end
end
