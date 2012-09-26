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
          :api_function => "park",
          :api_username => options.delete(:api_username)
        }, {
          :domain    => options.delete(:domain),
          :topdomain => options.delete(:topdomain)
        })
      end

      # Remove a parked domain
      #
      # ==== Required
      #  * <tt>:domain</tt> - PENDING
      def remove(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "unpark",
          :api_username => options.delete(:api_username)
        }, {
          :domain => options.delete(:domain)
        })
      end

      # List parked domains
      #
      # ==== Optional
      #  * <tt>:regex</tt> - PENDING
      def list(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listparkeddomains",
          :api_username => options.delete(:api_username)
        }, {
          :regex => options.delete(:regex)
        })
      end

      # List addon domains
      #
      # ==== Optional
      #  * <tt>:regex</tt> - PENDING
      def list_addon_domains(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listaddondomains",
          :api_username => options.delete(:api_username)
        }, {
          :regex => options.delete(:regex)
        })
      end

    end
  end
end
