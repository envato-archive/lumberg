module Lumberg
  module Whm
    class Dns < Base
      def add_zone(options = {})
        Args.new(options) do |c|
          c.requires :domain, :ip
          c.optionals :template, :trueowner
        end

        server.perform_request('adddns', options)
      end

      def add_zone_record(options = {})
        Args.new(options) do |c|
          c.requires :zone
          c.optionals :name, :address, :type, :class, :cname, :exchange, :nsdname, :ptdrname, :preference, :ttl
        end

        server.perform_request('addzonerecord', options)
      end

      def list_zones(options = {})
        server.perform_request('listzones', options.merge(:key => 'zone'))
      end

      def get_zone_record(options = {})
        Args.new(options) do |c|
          c.requires :domain, :Line
        end

        server.perform_request('getzonerecord', options)
      end

      def dump_zone(options = {})
        Args.new(options) do |c|
          c.requires :domain
        end

        server.perform_request('dumpzone', options)
      end

      def resolve_domain(options = {})
        Args.new(options) do |c|
          c.requires :domain, "api.version".to_sym
        end

        server.perform_request('resolvedomainname', options.merge(:key => 'data'))
      end

      def edit_zone_record(options = {})
        Args.new(options) do |c|
          c.requires :domain, :Line
          c.optionals :address, :class, :cname, :exchange, :preference, :expire, :minimum, :mname,
                      :name, :nsdname, :raw, :refresh, :retry, :rname, :serial, :ttl, :type, :txtdata
        end

        server.perform_request('editzonerecord', options)
      end

      def kill_dns(options = {})
        Args.new(options) do |c|
          c.requires :domain
        end

        server.perform_request('killdns', options)
      end

      def lookup_nameserver_ip(options = {})
        Args.new(options) do |c|
          c.requires :nameserver
        end

        server.perform_request('lookupnsip', options.merge(:key => 'ip'))
      end

      def remove_zone_record(options = {})
        Args.new(options) do |c|
          c.requires :zone, :Line
        end

        server.perform_request('removezonerecord', options)
      end

      def reset_zone(options = {})
        Args.new(options) do |c|
          c.requires :domain, :zone
        end

        server.perform_request('resetzone', options)
      end

      def list_mxs(options = {})
        Args.new(options) do |c|
          c.requires :domain, "api.version".to_sym
        end

        server.perform_request('listmxs', options.merge(:key => 'data'))
      end

      def save_mx(options = {})
        Args.new(options) do |c|
          c.requires "api.version".to_sym, :domain, :name, :exchange, :preference
        end

        server.perform_request('savemxs', options)
      end
    end
  end
end
