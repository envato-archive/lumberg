module Lumberg
  module Whm
    class Dns < Base
      # Creates a DNS zone. All zone information other than domain name and IP address is created based on the standard zone template in WHM.
      # Your MX, nameserver, domain PTR, and A records will all be generated automatically
      def add_zone(options = {})
        Args.new(options) do |c|
          c.requires :domain, :ip
          c.optionals :template, :trueowner
        end

        server.perform_request('adddns', options)
      end

      # Adds a DNS zone record to the server
      def add_zone_record(options = {})
        Args.new(options) do |c|
          c.requires :zone
          c.optionals :name, :address, :type, :class, :cname, :exchange, :nsdname, :ptdrname, :preference, :ttl
        end

        server.perform_request('addzonerecord', options)
      end

      # Generates a list of all domains and corresponding DNS zones associated with your server
      def list_zones(options = {})
        server.perform_request('listzones', options.merge(:key => 'zone'))
      end

      # Return zone records for a domain.
      # 
      # To use this function most effectively, you may first wish to run the dumpzone function for the domain(s) whose record(s) you wish to retrieve. 
      # The Line output variable from that function call can then be used as a reference to create the input for this function.
      def get_zone_record(options = {})
        Args.new(options) do |c|
          c.requires :domain, :Line
        end

        server.perform_request('getzonerecord', options)
      end

      # Displays the DNS zone configuration for a specific domain
      def dump_zone(options = {})
        Args.new(options) do |c|
          c.requires :domain
        end

        server.perform_request('dumpzone', options)
      end

      # Attempts to resolve an IP address for a specified domain name
      def resolve_domain(options = {})
        Args.new(options) do |c|
          c.requires :domain, "api.version".to_sym
        end

        server.perform_request('resolvedomainname', options.merge(:key => 'data'))
      end

      # Allows you to edit a DNS zone record on the server.
      #
      # To use this function most effectively, you should first run the dumpzone function for the domain(s) whose record(s) you wish to edit. 
      # The output of that function call will be used as a reference to create the input for this function.
      def edit_zone_record(options = {})
        Args.new(options) do |c|
          c.requires :domain, :Line
          c.optionals :address, :class, :cname, :exchange, :preference, :expire, :minimum, :mname,
                      :name, :nsdname, :raw, :refresh, :retry, :rname, :serial, :ttl, :type, :txtdata
        end

        server.perform_request('editzonerecord', options)
      end

      # Deletes a DNS zone
      def kill_dns(options = {})
        Args.new(options) do |c|
          c.requires :domain
        end

        server.perform_request('killdns', options)
      end

      # Obtains the IP address of a registered nameserver from the root nameservers
      def lookup_nameserver_ip(options = {})
        Args.new(options) do |c|
          c.requires :nameserver
        end

        server.perform_request('lookupnsip', options.merge(:key => 'ip'))
      end

      # Allows you to remove a DNS zone record from the server.
      # 
      # To use this function most effectively, you should first run the dumpzone function for the domain(s) whose record(s) you wish to remove. 
      # The output of that function call will be used as a reference to create the input for this function.
      def remove_zone_record(options = {})
        Args.new(options) do |c|
          c.requires :zone, :Line
        end

        server.perform_request('removezonerecord', options)
      end

      # Restore a DNS zone to its default values. This includes any subdomain DNS records associated with the domain.
      # 
      # This function can be useful for restoring DNS zones that have become corrupted or have been improperly edited. 
      # It will also restore zone file subdomains listed in the server's httpd.conf file, along with default settings for new accounts.
      def reset_zone(options = {})
        Args.new(options) do |c|
          c.requires :domain, :zone
        end

        server.perform_request('resetzone', options)
      end

      # This function will list a specified domain's MX records
      #
      # *This function is only available in version 11.27/11.28+*
      def list_mxs(options = {})
        Args.new(options) do |c|
          c.requires :domain, "api.version".to_sym
        end

        server.perform_request('listmxs', options.merge(:key => 'data'))
      end

      # This function will add an MX record
      #
      # *This function is only available in version 11.27/11.28+*
      def save_mx(options = {})
        Args.new(options) do |c|
          c.requires "api.version".to_sym, :domain, :name, :exchange, :preference
        end

        server.perform_request('savemxs', options)
      end
    end
  end
end
