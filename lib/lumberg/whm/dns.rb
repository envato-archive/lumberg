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
          c.optionals :name, :address, :type, :class
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
    end
  end
end
