module Lumberg
  module Cpanel
    class Ssl < Base
      def self.api_module; "SSL"; end

      # Public: Install an SSL certificate, key, and cabundle.
      #
      # options - Hash options for API call params (default: {}):
      #  :cabundle - Contents of the CA bundle file (optional)
      #  :crt      - Contents of the certificate file
      #  :domain   - Domain name for the cert (optional)
      #  :key      - Contents of the key file associated with the CSR
      #  :subject - String subject line.
      #
      # Returns Hash API response.
      def installssl(options = {})
        perform_request({
          :api_function => "installssl"
        }.merge(options))
      end

      # Public: List CSRs associated with your cPanel account.
      #
      # options - Hash options for API call params (default: {}):
      #
      # Returns Hash API response.
      def listcsrs(options = {})
        perform_request({
          :api_function => "listcsrs",
        }.merge(options))
      end

      # Public: Print a specific Certificate Signing Request.
      #
      # options - Hash options for API call params (default: {}):
      #   :domain   - The name of the domain the CSR was generated for.
      #   :textmode - 0 for human readable, 1 for binary.
      #
      # Returns Hash API response.
      def showcsr(options = {})
        perform_request({
          :api_function => "showcsr",
          :api_version  => 1,
          :user         => options[:user],
          :response_key => "data",
          "arg-0"       => options[:domain],
          "arg-1"       => options[:textmode]
        })
      end

      # Public: Print a key that has already been generated.
      #
      # options - Hash options for API call params (default: {}):
      #   :domain   - The name of the domain the CSR was generated for.
      #   :textmode - 0 for human readable, 1 for binary.
      #
      # Returns Hash API response.
      def showkey(options = {})
        perform_request({
          :api_function => "showkey",
          :api_version  => 1,
          :user         => options[:user],
          :response_key => "data",
          "arg-0"       => options[:domain],
          "arg-1"       => options[:textmode]
        })
      end

      # Public: Print the current cert for a specific host.
      #
      # options - Hash options for API call params (default: {}):
      #
      # Returns Hash API response.
      def showcrt(options = {})
        perform_request({
          :api_function => "showcrt",
          :api_version  => 1,
          :user         => options[:user],
          :response_key => "data",
          "arg-0"       => options[:domain],
          "arg-1"       => options[:textmode]
        })
      end

      # Public: List SSL certificates currently installed for a cPanel account.
      #
      # options - Hash options for API call params (default: {}):
      #
      # Returns Hash API response.
      def listcrts(options = {})
        perform_request({
          :api_function => "listcrts",
        }.merge(options))
      end

      # Public: List SSL keys associated with a domain.
      #
      # options - Hash options for API call params (default: {}):
      #
      # Returns Hash API response.
      def listkeys(options = {})
        perform_request({
          :api_function => "listkeys",
        }.merge(options))
      end

      # Public: Fetch the cabundle that corresponds to the certificate
      #
      # options - Hash options for API call params (default: {}):
      #  :crt   - Contents of the certificate file
      #
      # Returns Hash API response.
      def fetchcabundle(options = {})
        perform_request({
          :api_function => "fetchcabundle",
        }.merge(options))
      end

      # Public: Query for SSL related items installed via cPanel
      #
      # options   - Hash options for API call params (default: {}):
      #  :domains - The domains you wish to query.
      #  :items   - The type of SSL items for which you wish to query.
      #             Acceptable values include 'key', 'crt', and 'csr'.
      #
      # Returns Hash API response.
      def listsslitems(options = {})
        perform_request({
          :api_function => "listsslitems",
        }.merge(options))
      end

      # Public: Generate a certificate signing request.
      #
      # options - Hash options for API call params (default: {}):
      #  :city     - The city in which your server resides.
      #  :company  - The name of the company.
      #  :companydivision - The division of your company.
      #  :country  - A two letter abbreviation for the country.
      #  :email    - A valid email address that will correspond to the csr.
      #  :host     - The domain that corresponds to the csr.
      #  :state    - A two letter abbreviation that corresponds to the state.
      #  :password - The password of the csr.
      #
      # Returns Hash API response.
      def gencsr(options = {})
        perform_request({
          :api_function => "gencsr",
          :response_key => "cpanelresult",
        }.merge(options))
      end

      # Public: Generate a self-signed SSL certificate for a specific domain.
      #
      # options - Hash options for API call params (default: {}):
      #  :city     - The city in which your server resides.
      #  :company  - The name of the company.
      #  :companydivision - The division of your company.
      #  :country  - A two letter abbreviation for the country.
      #  :email    - A valid email address that will correspond to the csr.
      #  :host     - The domain that corresponds to the csr.
      #  :state    - A two letter abbreviation that corresponds to the state.
      #
      # Returns Hash API response.
      def gencrt(options = {})
        perform_request({
          :api_function => "gencrt",
        }.merge(options))
      end

      # Public: Generate an SSL key. You must have access to the 'sslmanager'.
      #
      # options - Hash options for API call params (default: {}):
      #  :host       - The domain that corresponds to the csr.
      #  :keysize    - The size of the key
      #                Optional, may range from 1024 to 4096.
      #
      # Returns Hash API response.
      def genkey(options = {})
        perform_request({
          :api_function => "genkey",
        }.merge(options))
      end

      # Public: Upload an SSL certificate.
      #
      # options - Hash options for API call params (default: {}):
      #  :crt    - Contents of the SSL certificate
      #
      # Returns Hash API response.
      def uploadcrt(options = {})
        perform_request({
          :api_function => "uploadcrt",
        }.merge(options))
      end
    end
  end
end
