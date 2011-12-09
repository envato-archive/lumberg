module Lumberg
  module Cpanel
    class Park < Base
      def self.api_module; "Park"; end

      def add(options = {})
        Args.new(options) do |c|
          c.requires :domain
          c.optionals :topdomain
        end

        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "park",
          :api_username => options.delete(:api_username)
        }, {
          :domain    => options.delete(:domain),
          :topdomain => options.delete(:topdomain)
        })
      end

      def remove(options = {})
        Args.new(options) do |c|
          c.requires :domain
        end

        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "unpark",
          :api_username => options.delete(:api_username)
        }, {
          :domain => options.delete(:domain)
        })
      end

      def list(options = {})
        Args.new(options) do |c|
          c.optionals :regex
        end

        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listparkeddomains",
          :api_username => options.delete(:api_username)
        }, {
          :regex => options.delete(:regex)
        })
      end

      def list_addon_domains(options = {})
        Args.new(options) do |c|
          c.optionals :regex
        end

        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listaddondomains",
          :api_username => options.delete(:api_username)
        }, {
          :regex => options.delete(:regex)
        })
      end

    end
  end
end
