module Lumberg
  module Cpanel
    class BoxTrapper < Base
      def self.api_module; "BoxTrapper"; end

      # List email accounts and their BoxTrapper statuses
      #
      # ==== Optional
      #  * <tt>:regex</tt> - PENDING
      def list(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "accountmanagelist",
          :api_username => options.delete(:api_username)
        }, {
          :regex  => options.delete(:regex)
        })
      end
    end
  end
end
