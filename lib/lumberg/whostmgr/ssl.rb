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

      # Public: Generates a SSL certificate
      #
      # options - Hash options for API call params (default: {})
      #           :city     - The city in which your server resides.
      #           :company  - The name of the company.
      #           :company_division - The division of your company.
      #           :country  - A two letter abbreviation for the country (ISO-3166-1).
      #           :email    - A valid email address that will correspond to
      #                       the certificate signing request
      #           :host     - The domain that corresponds to the csr.
      #           :state    - A two letter abbreviation that corresponds to the
      #                       state.
      #           :pass     - The password of the csr.
      #
      # Returns a Hash API response.
      def create(options = {})
        options[:countryName]            = options.delete(:country).upcase
        options[:stateOrProvinceName]	   = options.delete(:state)
        options[:localityName]		       = options.delete(:city)
        options[:organizationName]	     = options.delete(:company)
        options[:organizationalUnitName] = options.delete(:company_division)
        options[:domains]                = options.delete(:host)
        options[:emailAddress]      		 = options.delete(:email)

        perform_request({ function: "dogencrt" }.merge(options))
      end
    end
  end
end
