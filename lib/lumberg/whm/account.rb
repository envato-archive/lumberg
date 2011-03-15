module Lumberg
  module Whm
    # Some WHM functions require different params for the same 'thing'
    # e.g. some accept 'username' while others accept 'user' 
    # Be sure to keep our API consistent and work around those inconsistencies internally 
    class Account < Base

      # Creates a hosting account and sets up its associated domain information
      def create(options = {})
        Args.new(options) do |c|
          c.requires  :username, :domain, :password
          c.booleans  :savepkg, :ip, :cgi, :frontpage, :hasshell, :useregns, :reseller, :forcedns
          c.optionals :plan, :pkgname, :savepkg, :featurelist, :quota, :ip, :cgi, 
                       :frontpage, :hasshell, :contactemail, :cpmod, :maxftp, :maxsql, :maxpop, :maxlst, 
                       :maxsub, :maxpark, :maxaddon, :bwlimit, :customip, :language, :useregns, :hasuseregns, 
                       :reseller, :forcedns, :mxcheck
        end

        server.perform_request('createacct', options)
      end

      # Permanently removes a cPanel account
      def remove(options = {})
        Args.new(options) do |c|
          c.requires  :username
          c.booleans  :keepdns
        end

        options[:user] = options.delete(:username)
        server.perform_request('removeacct', options)
      end

      # Changes the password of a domain owner (cPanel) or reseller (WHM) account
      def change_password(options = {})
        Args.new(options) do |c|
          c.requires  :username, :password
          c.booleans  :db_pass_update
        end

        options[:user] = options.delete(:username)
        options[:pass] = options.delete(:password)
        server.perform_request('passwd', options.merge(:key => 'passwd'))
      end

      # Displays pertinent information about a specific account
      def summary(options = {})
        Args.new(options) do |c|
          c.requires  :username
        end

        options[:user] = options.delete(:username)
        server.perform_request('accountsummary', options)
      end

      # Modifies the bandwidth usage (transfer) limit for a specific account
      def limit_bandwidth(options = {})
        Args.new(options) do |c|
          c.requires :username, :bwlimit
        end

        verify_user(options[:username]) do
          options[:user] = options.delete(:username)
          server.perform_request('limitbw', options) do |s|
            s.boolean_params = :unlimited, :bwlimitenable
          end
        end
      end

      # Lists all accounts on the server, and also allows you to search for a specific account or set of accounts
      def list(options = {})
        Args.new(options) do |c|
          c.optionals :searchtype, :search
        end

        server.perform_request('listaccts', options) do |s|
          s.boolean_params = :suspended
        end
      end

      # Modifies settings for an account
      def modify(options = {})
        Args.new(options) do |c|
          c.requires :username
          c.optionals :domain, :newuser, :owner, :CPTHEME, :HASCGI, :LANG, :LOCALE, :MAXFTP, :MAXSQL, :MAXPOP, :MAXLST, :MAXSUB, :MAXPARK, :MAXADDON, :shell
        end

        options[:user] = options.delete(:username)
        server.perform_request('modifyacct', options) do |s|
          s.boolean_params = :DEMO
        end
      end

      # Changes an account's disk space usage quota
      def edit_quota(options = {})
        Args.new(options) do |c|
          c.requires :username, :quota
        end

        options[:user] = options.delete(:username)
        server.perform_request('editquota', options)
      end

      # Adds a new hosting package
      def add_package(options = {})
        Args.new(options) do |c|
          c.requires :name
          c.optionals :featurelist, :quota, :ip, :cgi, :frontpage, :cpmod, :language, :maxftp, :maxsql, :maxpop, :maxlists, :maxsub, :maxpark, :maxaddon, :hasshell, :bwlimit
          c.booleans :ip, :cgi, :frontpage, :hasshell
        end

        server.perform_request('addpkg', options)
      end

      # Changes the hosting package associated with a cPanel account
      def change_package(options = {})
        Args.new(options) do |c|
          c.requires :username, :pkg
        end

        options[:user] = options.delete(:username)
        server.perform_request('changepackage', options)
      end

      # Obtains user data for a specific domain
      def domain_user_data(options = {})
        Args.new(options) do |c|
          c.requires :domain
        end

        server.perform_request('domainuserdata', options.merge(:key => 'userdata')) do |s|
          s.boolean_params = :hascgi
        end
      end

      # Prevents a cPanel user from accessing his or her account. Once an account is suspended, it can be un-suspended to allow a user to access the account again
      def suspend(options ={})
        Args.new(options) do |c|
          c.requires  :username
          c.optionals :reason
        end

        options[:user] = options.delete(:username)
        server.perform_request('suspendacct', options)
      end

      # Unsuspend a suspended account. When a user's account is unsuspended, he or she will be able to access cPanel again
      def unsuspend(options ={})
        Args.new(options) do |c|
          c.requires  :username
        end

        options[:user] = options.delete(:username)
        server.perform_request('unsuspendacct', options)
      end

      # Generates a list of suspended accounts
      def list_suspended(options = {})
        server.perform_request('listsuspended', options)
      end

      # Generates a list of features you are allowed to use in WHM. Each feature will display either a 1 or 0. You are only able to use features with a corresponding 1
      def privs(options ={})
        Args.new(options) do |c|
          c.requires  :username
        end
    
        verify_user(options[:username]) do
          resp = server.perform_request('myprivs', options.merge(:key => 'privs')) do |s|
            s.boolean_params = :all
          end
          # if you get this far, it's successful
          resp[:success] = true
          resp
        end
      end

      # Changes the IP address of a website, or a user account, hosted on your server
      def set_site_ip(options = {})
        Args.new(options) do |c|
          c.requires :ip
          c.one_of :username, :domain
        end

        options[:user] = options.delete(:username) if options[:username]
        server.perform_request('setsiteip', options)
      end

      # Restores a user's account from a backup file. You may restore a monthly, weekly, or daily backup
      def restore_account(options = {})
        Args.new(options) do |c|
          c.requires "api.version".to_sym, :username, :type, :all, :ip, :mail, :mysql, :subs
          c.booleans :all, :ip, :mail, :mysql, :subs
        end

        options[:user] = options.delete(:username) if options[:username]
        server.perform_request('restoreaccount', options.merge(:key => 'metadata'))
      end

      protected 
      # Some WHM API methods always return a result, even if the user
      # doesn't actually exist. This makes it seem like your request 
      # was successful when it really wasn't
      #
      # Example
      #   verify_user('bob') do
      #      change_password()
      #   end
      def verify_user(username, &block)
        exists = summary(:username => username)
        if exists[:success]
          yield
        else
          raise WhmInvalidUser, "User #{username} does not exist"
        end
      end

    end
  end
end
