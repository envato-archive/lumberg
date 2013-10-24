module Lumberg
  module Cpanel
    # Public: Allows users to edit domain keys
    class DomainKeys < Base
      def self.api_module ; "DKIMUI" ; end

      # Public: Install DomainKeys for your cPanel account
      #
      # Returns Hash API response
      def add
        perform_request({ api_function: "install" })
      end

      # Public: Remove DomainKeys corresponding to your domain
      #
      # Returns Hash API response
      def remove
        perform_request({ api_function: "uninstall" })
      end

      # Public: Check to see if your domain has DomainKeys installed
      #
      # Returns Hash API response
      def installed
        perform_request({ api_function: "installed" })
      end

      # Public: Check to see if DomainKeys are available on the server
      #
      # Returns Hash API response
      def available
        perform_request({ api_function: "available" })
      end
    end
  end
end

