module Lumberg
  module Whm
    # Some WHM functions require different params for the same 'thing'
    # e.g. some accept 'username' while others accept 'user' 
    # Be sure to keep our API consistent and work around those inconsistencies internally 
    class Account
      attr_reader :server

      def initialize(options = {})
        Args.new(options) do |c|
          c.requires :server
        end
     
        setup_server options.delete(:server) 
      end

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
          c.requires  :username, :pass
          c.booleans  :db_pass_update
        end

        options[:user] = options.delete(:username)
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
          server.perform_request('limitbw', options)
        end
      end

      def list_accounts(options = {})
        Args.new(options) do |c|
          c.optionals :searchtype, :search
        end

        server.perform_request('listaccts', options)
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
          resp = server.perform_request('myprivs', options.merge(:key => 'privs', :bool => true))
          # if you get this far, it's successful
          resp[:success] = true
          resp
        end
      end

      protected 
      def setup_server(value)
        if value.is_a?(Whm::Server) 
          @server = value
        else
          @server = Whm::Server.new value
        end
      end

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
