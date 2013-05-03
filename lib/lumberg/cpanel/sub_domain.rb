module Lumberg
  module Cpanel
    class SubDomain < Base
      # Public: Add a subdomain.
      #
      # options - Hash options for API call params (default: {}):
      #   :domain      - String local part of the subdomain to add.
      #                  "sub" if "sub.domain.com".
      #   :rootdomain  - String domain on which to add the subdomain.
      #   :dir         - String docroot for subdomain (optional, default:
      #                  "public_html/[:domain value]")
      #   :disallowdot - String value (optional). Set to "1" to strip "."
      #                  chars from specified :domain value.
      #
      # Returns Hash API response.
      def add(options = {})
        perform_request({
          :api_function => "addsubdomain"
        }.merge(options))
      end

      # Public: Remove a subdomain.
      #
      # options - Hash options for API call params (default: {}):
      #   :domain - String subdomain to delete.
      #
      # Returns Hash API response.
      def remove(options = {})
        perform_request({
          :api_function => "delsubdomain"
        }.merge(options))
      end

      # Public: Get list of subdomains.
      #
      # options - Hash options for API call params (default: {}):
      #   :regex - String regular expression to filter results (optional).
      #
      # Returns Hash API response.
      def list(options = {})
        perform_request({
          :api_function => "listsubdomains"
        }.merge(options))
      end
    end
  end
end
