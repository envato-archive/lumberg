module Lumberg
  module Whm
    # Some WHM functions require different params for the same 'thing'
    # e.g. some accept 'username' while others accept 'user' 
    # Be sure to keep our API consistent and work around those inconsistencies internally 
    class Account < Base

      # WHM functions
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

      def remove(options = {})
        Args.new(options) do |c|
          c.requires  :username
          c.booleans  :keepdns
        end

        options[:user] = options.delete(:username)
        server.perform_request('removeacct', options)
      end

      def change_password(options = {})
        Args.new(options) do |c|
          c.requires  :username, :password
          c.booleans  :db_pass_update
        end

        options[:user] = options.delete(:username)
        options[:pass] = options.delete(:password)
        server.perform_request('passwd', options.merge(:key => 'passwd'))
      end

      def summary(options = {})
        Args.new(options) do |c|
          c.requires  :username
        end

        options[:user] = options.delete(:username)
        server.perform_request('accountsummary', options)
      end

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

      def list(options = {})
        Args.new(options) do |c|
          c.optionals :searchtype, :search
        end

        server.perform_request('listaccts', options) do |s|
          s.boolean_params = :suspended
        end
      end

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

      def edit_quota(options = {})
        Args.new(options) do |c|
          c.requires :username, :quota
        end

        options[:user] = options.delete(:username)
        server.perform_request('editquota', options)
      end

      def add_package(options = {})
        Args.new(options) do |c|
          c.requires :name
          c.optionals :featurelist, :quota, :ip, :cgi, :frontpage, :cpmod, :language, :maxftp, :maxsql, :maxpop, :maxlists, :maxsub, :maxpark, :maxaddon, :hasshell, :bwlimit
          c.booleans :ip, :cgi, :frontpage, :hasshell
        end

        server.perform_request('addpkg', options)
      end

      def change_package(options = {})
        Args.new(options) do |c|
          c.requires :username, :pkg
        end

        options[:user] = options.delete(:username)
        server.perform_request('changepackage', options)
      end

      def domain_user_data(options = {})
        Args.new(options) do |c|
          c.requires :domain
        end

        server.perform_request('domainuserdata', options.merge(:key => 'userdata')) do |s|
          s.boolean_params = :hascgi
        end
      end

      def suspend(options ={})
        Args.new(options) do |c|
          c.requires  :username
          c.optionals :reason
        end

        options[:user] = options.delete(:username)
        server.perform_request('suspendacct', options)
      end

      def unsuspend(options ={})
        Args.new(options) do |c|
          c.requires  :username
        end

        options[:user] = options.delete(:username)
        server.perform_request('unsuspendacct', options)
      end

      def list_suspended(options = {})
        server.perform_request('listsuspended', options)
      end

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

      def set_site_ip(options = {})
        Args.new(options) do |c|
          c.requires :ip
          c.one_of :username, :domain
        end

        options[:user] = options.delete(:username) if options[:username]
        server.perform_request('setsiteip', options)
      end

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
