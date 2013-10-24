module Lumberg
  module Cpanel
    class DnsLookup < Base
      # Public: Basic DNS functionality. This function will return the ip
      # address associated with a domain. If multiple addresses are associated
      # with that domain, only one will be returned
      #
      # options   - Hash options for API call params (default: {})
      #   :domain - String domain you wish to lookup
      #
      # Examples
      #   api_args = { host: "x.x.x.x", hash: "pass", api_username: "user" }
      #   dns_lookup = Lumberg::Cpanel::DnsLookup.new(api_args.dup)
      #
      #   dns_lookup.name_to_ip(domain: 'google.com')
      #
      # Returns Hash API response.
      def name_to_ip(options = {})
        perform_request({ api_function: 'name2ip' }.merge(options))
      end
    end
  end
end
