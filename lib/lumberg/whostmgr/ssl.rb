module Lumberg
  module Whostmgr
    class Ssl < Base
      # Public: Removes a SSL certificate
      #
      # options - Hash options for API call params (default: {}):
      #  :domain   - Domain name for the cert removal
      #
      # Returns Hash API response
      def remove(options = {})
        host = options.delete(:domain)
        perform_request({ function: "realdelsslhost", host: host })
      end

      # Public: Removes certificate data. Certificates and CSRs are grouped
      # with their associated private key in SSL Storage Manager and every
      # piece of data has a unique identifier. Whenever we're removing a SSL
      # certificate from a domain, it's good to remove its data.
      #
      # options - Hash options for API call params (default: {}):
      #           :id - String unique identifier for cert, key or CSR
      #           :type - String type
      #
      # Returns Hash API response
      def remove_data(options = {})
        perform_request({ function: "delssldata" }.merge(options))
      end
    end
  end
end
