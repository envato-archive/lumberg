module Lumberg
  module Cpanel
    class SubDomain < Base
      def self.api_module; "SubDomain"; end

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
