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

      # Generates a CSR
      #
      # ==== Required
      #  * <tt>:xemail</tt> - PENDING
      #  * <tt>:host</tt> - PENDING
      #  * <tt>:country</tt> - PENDING
      #  * <tt>:state</tt> - PENDING
      #  * <tt>:city</tt> - PENDING
      #  * <tt>:co</tt> - PENDING
      #  * <tt>:cod</tt> - PENDING
      #  * <tt>:email</tt> - PENDING
      #  * <tt>:pass</tt> - PENDING
      #
      # ==== Optional
      #  * <tt>none</tt> - PENDING
      def generatessl(options = {})
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
        cert_key = options[:key]
        # Compensate automatic removal of options[:key]
        result = server.perform_request('installssl', options) do |serv|
          serv.instance_variable_get(:@params)[:key] = cert_key
        end
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
        result = server.perform_request('listcrts', options.merge(:key => 'crt'))
      end
    end
  end
end
