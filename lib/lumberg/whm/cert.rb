module Lumberg
  module Whm
    class Cert < Base

      # Displays the SSL certificate, private key, and CA bundle/intermediate
      # certificate associated with a specified domain. Alternatively, it can
      # display the private key and CA bundle associated with a specified cert
      #
      # ==== Required
      #  * <tt>:domain</tt> - PENDING
      #  * <tt>:crtdata</tt> - PENDING
      #
      # ==== Optional
      #  * <tt>none</tt> - PENDING
      def fetchsslinfo(options = {})
        server.force_response_type = :ssl
        result = server.perform_request('fetchsslinfo', options)
      end

      # Public: Generates a Certificate Signing Request
      #
      # options - Hash options for API call params (default: {}):
      #           :city     - The city in which your server resides.
      #           :company  - The name of the company.
      #           :company_division - The division of your company.
      #           :country  - A two letter abbreviation for the country.
      #           :email    - A valid email address that will correspond to
      #                       the certificate signing request
      #           :host     - The domain that corresponds to the csr.
      #           :state    - A two letter abbreviation that corresponds to the
      #                       state.
      #           :pass     - The password of the csr.
      #           :xemail   - Email address to which the certificate will be
      #                       sent (String)
      #           :noemail  - (Boolean) and dependent value. Set to "1" when
      #                       :xemail is empty
      #
      # Returns Hash API response.
      def generatessl(options = {})
        options[:co]  = options.delete(:company)
        options[:cod] = options.delete(:company_division)

        server.force_response_type = :ssl
        result = server.perform_request('generatessl', options)
      end

      # Install an SSL certificate
      #
      # ==== Required
      #  * <tt>:user</tt> - PENDING
      #  * <tt>:domain</tt> - PENDING
      #  * <tt>:cert</tt> - PENDING
      #  * <tt>:key</tt> - PENDING
      #  * <tt>:cab</tt> - PENDING
      #  * <tt>:ip</tt> - PENDING
      #
      # ==== Optional
      #  * <tt>none</tt> - PENDING
      def installssl(options = {})
        result = server.perform_request('installssl', options)
      end

      # List all the domains on the server that have SSL certificates installed
      #
      # ==== Required
      #  * <tt>none</tt> - PENDING
      #
      # ==== Optional
      #  * <tt>none</tt> - PENDING
      def listcrts(options = {})
        server.force_response_type = :ssl
        result = server.perform_request('listcrts', options.merge(response_key: 'crt'))
      end
    end
  end
end
