module Lumberg
  module Cpanel
    # Public: Allows you to manage MySQL Databases, users and other related settings.
    class MysqlDb < Base
      def self.api_module; "Mysql"; end

      # Public: Add a new MySQL database to a cPanel account.
      #
      # options - Hash options for API call params (default: {}).
      #   :dbname - String name of the MySQL database to add.
      #
      # Returns Hash API response.
      def add_db(options = {})
        perform_request({
          api_function: 'adddb',
          'arg-0' => options.delete(:dbname)
        }.merge(default_options(options)))
      end

      # Public: Create a new MySQL user.
      #
      # options - Hash options for API call params (default: {}).
      #   :username - String MySQL user to create.
      #   :password - String password for the new MySQL user.
      #
      # Returns Hash API respone.
      def add_user(options = {})
        perform_request({
          api_function: 'adduser',
          'arg-0' => options.delete(:username),
          'arg-1' => options.delete(:password)
        }.merge(default_options(options)))
      end

      # Public: Grant a user permission to access a cPanel account's database.
      #
      # options - Hash options for API call params (default: {})
      #   :dbname - String name of the database to allow the user to access.
      #   :dbuser - String MySQL user who should be given access to the database.
      #   :perms_list - A space-separated String containing a list of permissions
      #                 to grant to the user
      #                 (e.g. "all" or "alter drop create delete insert update lock" )
      #
      # Returns Hash API respone.
      def add_user_db(options = {})
        perform_request({
          api_function: 'adduserdb',
          'arg-0' => options.delete(:dbname),
          'arg-1' => options.delete(:dbuser),
          'arg-2' => options.delete(:perms_list)
        }.merge(default_options(options)))
      end

      # Public: Retrieve the number of database users an account has created.
      #
      # Returns Hash API response.
      def number_of_dbs(options = {})
        perform_request({
          api_function: 'number_of_dbs'
        }.merge(default_options(options)))
      end

      # Public: Run a MySQL database check.
      #
      # options - Hash options for API call params (default: {}).
      #   :dbname - String name of the MySQL database to check.
      #
      # Returns Hash API response.
      def check_db(options = {})
        perform_request({
          api_function: 'checkdb',
          'arg-0' => options.delete(:dbname)
        }.merge(default_options(options)))
      end

      # Public: Run a MySQL database repair.
      #
      # options - Hash options for API call params (default: {}).
      #   :dbname - String name of the MySQL database to repair.
      #
      # Returns Hash API response.
      def repair_db(options = {})
        perform_request({
          api_function: 'repairdb',
          'arg-0' => options.delete(:dbname)
        }.merge(default_options(options)))
      end

      # Public: Force an update of MySQL privileges and passwords.
      #
      # options - Hash options for API call params (default: {})
      #
      # Returns Hash API response.
      def update_privs(options = {})
        perform_request({
          api_function: 'updateprivs'
        }.merge(default_options(options)))
      end

      # Public: Refresh the cache of MySQL information. This includes users,
      #         databases, routines and other related information.
      #
      # options - Hash options for API call params (default: {})
      #
      # Returns Hash API response.
      def init_cache(options = {})
        perform_request({
          api_function: 'initcache'
        }.merge(default_options(options)))
      end

      # Public: Disallow a MySQL user from accessing a database.
      #
      # options - Hash options for API call params (default: {})
      #   :dbname - String MySQL database from which to remove the user's permissions.
      #   :dbuser - String name of the MySQL user to remove.
      #
      # Returns Hash API response.
      def del_user_db(options = {})
        perform_request({
          api_function: 'deluserdb',
          'arg-0' => options.delete(:dbname),
          'arg-1' => options.delete(:dbuser)
        }.merge(default_options(options)))
      end

      # Public: Remove a user from MySQL.
      #
      # options - Hash options for API call params (default: {})
      #   :dbuser - String name of the MySQL user to remove.
      #             This value must be prefixed with the cPanel username.
      #             (e.g. cpuser_dbuser)
      #
      # Returns Hash API response.
      def del_user(options = {})
        perform_request({
          api_function: 'deluser',
          'arg-0' => options.delete(:dbuser)
        }.merge(default_options(options)))
      end

      # Public: Remove a database from MySQL.
      #
      # options - Hash options for API call params (default: {}).
      #   :dbname - String name of the MySQL database to remove.
      #            This value must be prefixed with the cPanel username
      #            (e.g., cpuser_dbname).
      #
      # Returns Hash API response.
      def del_db(options = {})
        perform_request({
          api_function: 'deldb',
          'arg-0' => options.delete(:dbname)
        }.merge(default_options(options)))
      end

      # Public: Authorize a remote host to access a cPanel account's MySQL users.
      #
      # options - Hash options for API call params (default: {})
      #   :hostname - String IP address or hostname that should be provided access.
      #
      # Returns Hash API response.
      def add_host(options = {})
        perform_request({
         api_function: 'addhost',
         'arg-0' => options.delete(:hostname)
        }.merge(default_options(options)))
      end

      # Public: Remove host access permissions from MySQL.
      #
      # options - Hash options for API call params (default: {})
      #   :host - String IP address or hostname that should be provided access.
      #
      # Returns Hash API response.
      def del_host(options = {})
        perform_request({
          api_function: 'delhost',
          'arg-0' => options.delete(:host)
        }.merge(default_options(options)))
      end

      private

      def default_options(options)
        { api_version: 1, response_key: 'data' }.merge(options)
      end
    end
  end
end
