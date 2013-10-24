module Lumberg
  module Cpanel
    # Public: Allows users to access networking functions
    class Net < Base
      # Public: Perform a traceroute back to your local IP address while
      # displaying packet speed at each hop in milliseconds.
      #
      # Returns Hash API response
      def traceroute
        perform_request({ api_function: 'traceroute' })
      end

      # Public: Performs an A record DNS query for the hostname presented via
      # the 'host' variable, with a 60 second timeout. If more than one A record
      # exists for a given FQDN, all will be returned.
      #
      # options - Hash options for API call params (default: {})
      #   :host - String fully qualified domain name, either host.domain.com or
      #           domain.com
      #
      # Returns Hash API response
      def query_hostname(options = {})
        perform_request({ api_function: 'dnszone' }.merge(options))
      end
    end
  end
end

