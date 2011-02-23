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
          c.optionals :plan, :pkgname, :savepkg, :featurelist, :quota, :password, :ip, :cgi, 
                       :frontpage, :hasshell, :contactemail, :cpmod, :maxftp, :maxsql, :maxpop, :maxlst, 
                       :maxsub, :maxpark, :maxaddon, :bwlimit, :customip, :language, :useregns, :hasuseregns, 
                       :reseller, :forcedns, :mxcheck, :username, :domain
        end
        server.perform_request('createacct', options)
      end

      def remove(options = {})
        Args.new(options) do |c|
          c.requires  :username
          c.optionals :username, :keepdns
          c.booleans  :keepdns
        end

        options[:user] = options.delete(:username)
        server.perform_request('removeacct', options)
      end

      def change_password(options = {})
        Args.new(options) do |c|
          c.requires  :username, :pass
          c.optionals :username, :pass, :db_pass_update
          c.booleans  :db_pass_update
        end

        options[:user] = options.delete(:username)
        server.perform_request('passwd', options.merge(key: 'passwd'))
      end

      protected 
      def setup_server(value)
        if value.is_a?(Whm::Server) 
          @server = value
        else
          @server = Whm::Server.new value
        end
      end
    end
  end
end
