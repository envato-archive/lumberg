module Lumberg
  module Cpanel
    class Base < Whm::Base
      attr_accessor :api_username

      def initialize(options = {})
        @api_username = options.delete(:api_username)

        super options
      end

      def perform_request(options = {})
        if !options[:api_username] && !api_username.nil?
          options[:api_username] = api_username
        end

        params = {
          :key                       => options[:key] || "cpanelresult",
          :cpanel_jsonapi_user       => api_username,
          :cpanel_jsonapi_module     => options[:api_module],
          :cpanel_jsonapi_func       => options[:api_function],
          :cpanel_jsonapi_apiversion => options[:api_version] || 2
        }.merge(options)

        server.perform_request("cpanel", params)
      end
    end
  end
end
