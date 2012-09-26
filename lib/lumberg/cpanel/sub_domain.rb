module Lumberg
  module Cpanel
    class SubDomain < Base
      def self.api_module; "SubDomain"; end

      # Add a subdomain
      #
      # ==== Required
      #  * <tt>:domain</tt> - PENDING
      #  * <tt>:rootdomain</tt> - PENDING
      #
      # ==== Optional
      #  * <tt>:dir</tt> - PENDING
      #  * <tt>:disallowdot</tt> - PENDING
      def add(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "addsubdomain",
          :api_username => options.delete(:api_username)
        }, {
          :domain      => options.delete(:domain),
          :rootdomain  => options.delete(:rootdomain),
          :dir         => options.delete(:dir),
          :disallowdot => options.delete(:disallowdot)
        })
      end

      # Remove a subdomain
      #
      # ==== Required
      #  * <tt>:domain</tt> - PENDING
      def remove(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "delsubdomain",
          :api_username => options.delete(:api_username)
        }, {
          :domain => options.delete(:domain)
        })
      end

      # List subdomains
      #
      # ==== Optional
      #  * <tt>:regex</tt> - PENDING
      def list(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listsubdomains",
          :api_username => options.delete(:api_username)
        }, {
          :regex => options.delete(:regex)
        })
      end
    end
  end
end
