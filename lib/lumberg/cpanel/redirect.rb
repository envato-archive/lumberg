module Lumberg
  module Cpanel
    # Public: Allows users to create and manage redirects
    class Redirect < Base
      def self.api_module; "Mime"; end

      # Public: List redirects parsed from your various .htaccess files in
      # human-readable form
      #
      # options - Hash options for API call params (default: {})
      #   :regex - String value to filter results by applying perl regurlar
      #            expressions to the "sourceurl" output key, and accepts a
      #            simple string also (default: '')
      #
      # Returns Hash API response
      def list(options = {})
        perform_request({ :api_function => 'listredirects' }.merge(options))
      end

      # Public: This function returns either the domain name entered or '** All
      # Public Domains **'.
      #
      # options - Hash options for API call params (default: {})
      #   :domain - String value. If a domain name is entered, it will be
      #             returned. If this is set to '.*', '** All Public Domains **'
      #             will be returned. (default: '')
      #   :url - String value. If a url is entered, it will be returned. If this
      #          is set to '.*' or '(.*)', '** All Requests **' will be
      #          returned (default: '')
      #
      # Returns Hash API response
      def show(options = {})
        if options[:domain] && options[:url]
          raise ArgumentError,
            "#{self.class.name}##{__method__} cannot accept both `:url` and `:domain`"
        end
        function = options[:domain].present? ? 'redirectname' : 'redirecturlname'
        perform_request({ :api_function => function }.merge(options))
      end
    end
  end
end


