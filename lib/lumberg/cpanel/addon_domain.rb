module Lumberg
  module Cpanel
    class AddonDomain < Base
      # Public: Delete an addon domain. This will also remove the corresponding
      # subdomain and FTP account.
      #
      # options - Hash options for API call params (default: {}):
      #   :domain    - String addon domain to be deleted.
      #   :subdomain - String adddon domain's username followed by "_", then
      #                the addon domain's main domain, e.g.,
      #                "user_addon.com"
      #
      # Returns Hash API response.
      def remove(options = {})
        perform_request({
          api_function: "deladdondomain"
        }.merge(options))
      end

      # Public: Add an addon domain with a coresponding subdomain.
      #
      # options - Hash options for API call params (default: {}):
      #  :dir       - String path for addon domain docroot.
      #  :newdomain - String domain to use for addon domain.
      #  :subdomain - String subdomain / FTP username corresponding to new
      #               addon domain, e.g., "user".
      #
      # Returns Hash API response.
      def add(options = {})
        perform_request({
          api_function: "addaddondomain"
        }.merge(options))
      end

      # Public: Get a list of addon domains.
      #
      # options - Hash options for API call params (default: {}):
      #  :regex - String regular expression to filter search results
      #           (optional).
      #
      # Returns Hash API response.
      def list(options={})
        perform_request({
          api_function: "listaddondomains"
        }.merge(options))
      end
    end
  end
end

