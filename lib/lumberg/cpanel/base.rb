module Lumberg
  module Cpanel
    class Base < Whm::Base
      attr_accessor :api_username

      # Public: Gets cPanel API module name based on class name. This method
      # should be overriden in subclasses where the cPanel API module name
      # and the class name don't match up.
      #
      # Returns String cPanel API module name.
      def self.api_module
        self.name.split("::").last
      end

      # Public: Initialize a new cPanel API interface.
      #
      # options - Hash options (default: {}):
      #   :api_username - String username to set as the default account
      #                   username for cPanel API calls (optional).
      def initialize(options = {})
        @api_username = options.delete(:api_username)

        super options
      end

      # Public: Perform a cPanel API method call.
      #
      # options - Hash options for API call params (default: {}):
      #   :api_function - String API function name to call.
      #   :api_module   - String API module on which API function will be
      #                   called (optional, default: self.class.api_module).
      #   :response_key - String key used to select desired part of API
      #                   response (optional, default: "cpanelresult").
      #   :api_username - String account username for API call (optional,
      #                   default: @api_username)
      #   :api_version  - Integer cPanel API version to use (optional,
      #                   default: 2)
      #
      # Returns Hash API response.
      def perform_request(options = {})
        options[:api_username] ||= api_username

        api_module = options.delete(:api_module) || self.class.api_module
        params = {
          response_key:              options.delete(:response_key) || "cpanelresult",
          cpanel_jsonapi_user:       options.delete(:api_username),
          cpanel_jsonapi_module:     api_module,
          cpanel_jsonapi_func:       options.delete(:api_function),
          cpanel_jsonapi_apiversion: options.delete(:api_version) || 2,
        }.merge(options)

        server.perform_request("cpanel", params)
      end
    end
  end
end
