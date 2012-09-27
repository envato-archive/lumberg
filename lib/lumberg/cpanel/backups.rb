module Lumberg
  module Cpanel
    class Backups < Base
      def self.api_module; "Backups"; end

      def list(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listfullbackups"
        }.merge(options))
      end
    end
  end
end
