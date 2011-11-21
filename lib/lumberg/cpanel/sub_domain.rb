module Lumberg
  module Cpanel
    class SubDomain < Base
      def self.api_module; "SubDomain"; end

      def addsubdomain(options = {})
        Args.new(options) do |c|
          c.requires :domain, :rootdomain
          c.optionals :dir, :disallowdot
        end

        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "addsubdomain",
          :api_username => options.delete(:api_username)
        }, {
          :domain      => options.delete(:domain),
          :rootdomain  => options.delete(:rootdomain),
          :dir         => options.delete(:dir),
          :disallowdot => options.delete(:disallowdot)
        })
      end

      def delsubdomain(options = {})
        Args.new(options) do |c|
          c.requires :domain
        end

        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "delsubdomain",
          :api_username => options.delete(:api_username)
        }, {
          :domain => options.delete(:domain)
        })
      end

      def listsubdomains(options = {})
        Args.new(options) do |c|
          c.optionals :regex
        end

        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listsubdomains",
          :api_username => options.delete(:api_username)
        }, {
          :regex => options.delete(:regex)
        })
      end
    end
  end
end
