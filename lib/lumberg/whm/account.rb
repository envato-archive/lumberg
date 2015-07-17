module Lumberg
  module Whm
    # WHM Account functions
    class Account < Base

      # Create a hosting account
      #
      # :domain      - String like domain-name.tld
      # :username    - String, maximum 8 chars long
      # :password    - String, mixing alpha and special characters
      #                Remember to use strong passwords for accounts
      #
      # :plan        - (default: String)
      # :pkgname     - (default: String)
      # :savepkg     - (default: String)
      # :featurelist - (default: String)
      # :quota       - (default: String)
      # :ip          - (default: String ip address)
      # :cgi         - (default: String)
      #
      # Examples
      #   server = Lumberg::Whm::Server.new(host: 'x.x.x.x', hash: '...')
      #   server.account.create(domain: 'example.com',
      #     username: 'example', password: '...')
      #
      # Returns request status, message and raw html
      def create(options = {})
        server.perform_request('createacct', options)
      end

      # Permanently removes a cPanel account
      #
      # username - String
      #
      # Returns request status, message and raw html
      def remove(options = {})
        options[:user] = options.delete(:username)
        server.perform_request('removeacct', options)
      end

      # Changes password, valid for accounts and resellers
      #
      # username - String
      # password - String
      #
      # Returns request status, message and raw html
      def change_password(options = {})
        options[:user] = options.delete(:username)
        options[:pass] = options.delete(:password)
        server.perform_request('passwd', options.merge(response_key: 'passwd'))
      end

      # Displays pertinent information about a specific account
      #
      # username - String
      #
      # Returns account summary
      def summary(options = {})
        options[:user] = options.delete(:username)
        server.perform_request('accountsummary', options)
      end

      # Changes bandwidth usage limits for account
      #
      # username - String
      # bwlimit  - String
      #
      # Returns request status
      def limit_bandwidth(options = {})
        verify_user(options[:username]) do
          options[:user] = options.delete(:username)
          server.perform_request('limitbw', options) do |s|
            s.boolean_params = :unlimited, :bwlimitenable
          end
        end
      end

      # Lists all accounts on the server.
      # You can also search for specific accounts, or a set of accounts
      #
      # searchtype - (default: String)
      # search     - (default: String)
      #
      # Returns existing accounts
      def list(options = {})
        server.perform_request('listaccts', options) do |s|
          s.boolean_params = :suspended
        end
      end

      # Modifies settings for an account
      #
      # :username - String
      #
      # :domain   - (default: '')
      # :newuser  - (default: '')
      # :owner    - (default: '')
      # :CPTHEME  - (default: '')
      # :HASCGI   - (default: '')
      # :LANG     - (default: '')
      # :LOCALE   - (default: '')
      # :MAXFTP   - (default: '')
      # :MAXSQL   - (default: '')
      # :MAXPOP   - (default: '')
      # :MAXLST   - (default: '')
      # :MAXSUB   - (default: '')
      # :MAXPARK  - (default: '')
      # :MAXADDON - (default: '')
      # :shell    - (default: '')
      #
      # Returns request status, message and raw html
      def modify(options = {})
        options[:user] = options.delete(:username)
        server.perform_request('modifyacct', options) do |s|
          s.boolean_params = :DEMO
        end
      end

      # Changes an account's disk space usage quota
      #
      # :username -  String
      # :quota    -  String
      #
      # Returns request status, message and raw html
      def edit_quota(options = {})
        options[:user] = options.delete(:username)
        server.perform_request('editquota', options)
      end

      # Adds a new hosting package
      #
      # :name         -  Package name
      #
      # :featurelist  -  (default: '')
      # :quota        -  (default: '')
      # :ip           -  (default: '')
      # :cgi          -  (default: '')
      # :frontpage    -  (default: '')
      # :cpmod        -  (default: '')
      # :language     -  (default: '')
      # :maxftp       -  (default: '')
      # :maxsql       -  (default: '')
      # :maxpop       -  (default: '')
      # :maxlists     -  (default: '')
      # :maxsub       -  (default: '')
      # :maxpark      -  (default: '')
      # :maxaddon     -  (default: '')
      # :hasshell     -  (default: '')
      # :bwlimit      -  (default: '')
      #
      # Returns a new hosting package
      def add_package(options = {})
        server.perform_request('addpkg', options)
      end

      # Changes the package associated within a cPanel account
      #
      # :username -  String
      # :pkg      -  String
      #
      # Returns modified package
      #
      def change_package(options = {})
        options[:user] = options.delete(:username)
        server.perform_request('changepackage', options)
      end

      # Obtains user data for a specific domain
      #
      # :domain -  (default: String)
      #
      # Returns Hash API response
      def domain_user_data(options = {})
        server.perform_request('domainuserdata', options.merge(response_key: 'userdata')) do |s|
          s.boolean_params = :hascgi
        end
      end

      # Prevents a cPanel user from accessing his or her account.
      # Once an account is suspended, it can be un-suspended to allow a user
      # to access the account again
      #
      # :username - String
      #
      # :reason   - Suspended reason (default: String)
      #
      # Returns request status, message and raw html
      def suspend(options ={})
        options[:user] = options.delete(:username)
        server.perform_request('suspendacct', options)
      end

      # Removes account suspension. When a user's account is unsuspended,
      # it will be able to access cPanel again
      #
      # :username - String
      #
      # Returns request status, message and raw html
      def unsuspend(options ={})
        options[:user] = options.delete(:username)
        server.perform_request('unsuspendacct', options)
      end

      # Gets suspended accounts
      #
      # Returns a list of suspended accounts
      def list_suspended(options = {})
        server.perform_request('listsuspended', options)
      end

      # Generates a list of features you are allowed to use in WHM. Each feature
      # will display either a 1 or 0, and you should be able to use only
      # features marked as "active" or "allowed" (with a corresponding 1)
      #
      # :username - String
      #
      # Returns current privileges
      def privs(options ={})
        verify_user(options[:username]) do
          resp = server.perform_request('myprivs', options.merge(response_key: 'privs')) do |s|
            s.boolean_params = :all
          end
          # if you get this far, it's successful
          resp[:success] = true
          resp
        end
      end

      # Changes the IP address of a website, or a user account, hosted on your
      # server
      #
      # :ip - String
      #
      # Returns the request, status message and raw html
      def set_site_ip(options = {})
        options[:user] = options.delete(:username) if options[:username]
        server.perform_request('setsiteip', options)
      end

      # Restores a user's account from a backup file. You may restore a monthly, weekly, or daily backup
      #
      # :username - String
      # :type     - String
      # :all      - String
      # :ip       - String
      # :mail     - String
      # :mysql    - String
      # :subs     - String
      #
      def restore_account(options = {})
        options[:user] = options.delete(:username) if options[:username]
        server.perform_request('restoreaccount', options.merge(response_key: 'metadata'))
      end

      protected
      # Internal: Some WHM API methods always return a result, even if the user
      #           doesn't actually exist. This makes it seem like your request
      #           was successful when it really wasn't
      #
      # Examples
      #   verify_user('bob') do
      #      change_password()
      #   end
      #
      # Returns account verification
      def verify_user(username, &block)
        exists = summary(username: username)
        if exists[:success]
          yield
        else
          raise WhmInvalidUser, "User #{username} does not exist"
        end
      end

    end
  end
end
