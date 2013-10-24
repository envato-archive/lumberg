module Lumberg
  module Cpanel
    # Public: Allows you to create random data
    class RandomData < Base
      def self.api_module; "Rand" ; end

      # Public: Retrieve a random string
      #
      # options - Hash options for API call params (default: {})
      #   :length - Integer length of the random string you wish to receive
      #
      # Examples
      #   api_args = { host: "x.x.x.x", hash: "pass", api_username: "user" }
      #   random_data = Lumberg::Cpanel::RandomData.new(api_args.dup)
      #
      #   random_data.show
      #
      # Returns Hash API response
      def show(options = {})
        perform_request({ api_function: 'getranddata' }.merge(options))
      end
    end
  end
end

