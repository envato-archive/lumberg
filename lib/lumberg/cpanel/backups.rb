module Lumberg
  module Cpanel
    class Backups < Base
      def self.api_module; "Backups"; end

      def list(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listfullbackups",
          :api_username => options.delete(:api_username)
        })
      end
    end
  end
end
