module Lumberg
  module Cpanel
    class Base < Whm::Base
      attr_accessor :api_username

      def initialize(options = {})
        Args.new(options) do |c|
          c.requires  :server, :api_username
        end

        @api_username = options.delete(:api_username)

        super options
      end

      def perform_request(options = {}, call_options = {})
        if !options[:api_username] && !api_username.nil?
          options[:api_username] = api_username
        end

        Args.new(options) do |c|
          c.requires :api_username, :api_module, :api_function
          c.optionals :api_version, :key
        end

        params = {
          :key                       => options.delete(:key) || "cpanelresult",
          :cpanel_jsonapi_user       => options.delete(:api_username),
          :cpanel_jsonapi_module     => options.delete(:api_module),
          :cpanel_jsonapi_func       => options.delete(:api_function),
          :cpanel_jsonapi_apiversion => options.delete(:api_version) || 2
        }.merge(options).merge(call_options)

        server.perform_request("cpanel", params)
      end
    end
  end
end
