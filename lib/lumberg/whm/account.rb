module Lumberg
  module Whm
    class Account
      include Args

      attr_reader :server

      def initialize(options = {})
        requires!(options, :server)
     
        setup_server options.delete(:server) 
      end

      # WHM functions
      def create(options = {})
        requires!(options, :username, :domain, :password)
        booleans!(options, :savepkg, :ip, :cgi, :frontpage, :hasshell, :useregns, :reseller, :forcedns)
        valid_options!(options, :plan, :pkgname, :savepkg, :featurelist, :quota, :password, :ip, :cgi, 
                       :frontpage, :hasshell, :contactemail, :cpmod, :maxftp, :maxsql, :maxpop, :maxlst, 
                       :maxsub, :maxpark, :maxaddon, :bwlimit, :customip, :language, :useregns, :hasuseregns, 
                       :reseller, :forcedns, :mxcheck, :username, :domain)
        server.perform_request('createacct', options)
      end

      def remove(options = {})
        requires!(options, :user)
        valid_options!(options, :user, :keepdns)
        booleans!(options, :keepdns)

        server.perform_request('removeacct', options)
      end

      def change_password(options = {})
        requires!(options, :user, :pass)
        valid_options!(options, :user, :pass, :db_pass_update)
        booleans!(options, :db_pass_update)

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
