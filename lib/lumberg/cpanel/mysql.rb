module Lumberg
  module Cpanel
    # Public: Allows you to access information about an account's MySQL users,
    # databases, and permissions
    class Mysql < Base
      def self.api_module; "MysqlFE"; end
      # Public: Retrieve a list of databases that belong to username
      #
      # options - Hash options for API call params (default: {})
      #   :regex - String regular expression to filter results (optional)
      #
      # Returns Hash API response
      def list(options = {})
        perform_request({ :api_function => 'listdbs' }.merge(options))
      end

      # Public: List all of the MySQL users available to a cPanel account
      #
      # Returns Hash API response
      def accounts
        perform_request({ :api_function => 'listusers' })
      end

      # Public: Retrieve a list of remote MySQL connection hosts
      #
      # Returns Hash API response
      def remote_hosts
        perform_request({ :api_function => 'listhosts' })
      end

      # Public: Retrieve a list of existing database backups
      #
      # Returns Hash API response
      def backups
        perform_request({ :api_function => 'listdbsbackup' })
      end

      # Public: List users who can access a particular database
      #
      # options - Hash options for API call params (default: {})
      #   :db - String name of the database whose users you wish to review. Be
      #         sure to use Cpanel convention's full mysql database name, e.g:
      #         cpanelaccount_databasename
      #
      # Returns Hash API response
      def usernames_for_db(options = {})
        perform_request({ :api_function => 'listusersindb' })
      end

      # Public: Retrieve a list of permissions that correspond to a specific
      # user and database
      #
      # options - Hash options for API call params (default: {})
      #   :db - String database that corresponds to th user whose permission
      #         you wish to view
      #   :username - String user whose permissions you wish to view
      #
      # Returns Hash API response
      def permissions(options = {})
        perform_request({ :api_function => 'userdbprivs' }.merge(options))
      end
    end
  end
end


