module Lumberg
  module Cpanel
    class Park < Base
      def self.api_module; "Park"; end

      # Add a parked domain
      #
      # ==== Required
      #  * <tt>:domain</tt> - PENDING
      #
      # ==== Optional
      #  * <tt>:topdomain</tt> - PENDING
      def add(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "park"
        }.merge(options))
      end

      # Remove a parked domain
      #
      # ==== Required
      #  * <tt>:domain</tt> - PENDING
      def remove(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "unpark"
        }.merge(options))
      end

      # List parked domains
      #
      # ==== Optional
      #  * <tt>:regex</tt> - PENDING
      def list(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listparkeddomains"
        }.merge(options))
      end

      # List addon domains
      #
      # ==== Optional
      #  * <tt>:regex</tt> - PENDING
      def list_addon_domains(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listaddondomains"
        }.merge(options))
      end

    end
  end
end
