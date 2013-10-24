module Lumberg
  module Cpanel
    class Park < Base
      # Public: Add a parked domain.
      #
      # options - Hash options for API call params (default: {}):
      #   :domain    - String domain to park.
      #   :topdomain - String domain to park on top of (optional, default:
      #                account primary domain).
      #
      # Returns Hash API response.
      def add(options = {})
        perform_request({
          api_function: "park"
        }.merge(options))
      end

      # Public: Remove a parked domain.
      #
      # options - Hash options for API call params (default: {}):
      #   :domain - String parked domain to remove.
      #
      # Returns Hash API response.
      def remove(options = {})
        perform_request({
          api_function: "unpark"
        }.merge(options))
      end

      # Public: Get a list of parked domains.
      #
      # options - Hash options for API call params (default: {}):
      #   :regex - String regular expression to filter search results
      #            (optional).
      #
      # Returns Hash API response.
      def list(options = {})
        perform_request({
          api_function: "listparkeddomains"
        }.merge(options))
      end

      # Public: Get a list addon domains.
      #
      # options - Hash options for API call params (default: {}):
      #   :regex - String regular expresion to filter search results
      #            (optional).
      #
      # Returns Hash API response.
      def list_addon_domains(options = {})
        perform_request({
          api_function: "listaddondomains"
        }.merge(options))
      end

    end
  end
end
