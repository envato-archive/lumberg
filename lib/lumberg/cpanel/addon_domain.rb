module Lumberg
  module Cpanel
    class AddonDomain < Base
      def self.api_module; "AddonDomain"; end

      # Delete an addon domain. This will also remove the corresponding
      # subdomain and FTP account
      #
      # ==== Required
      #  * <tt>:domain</tt> - PENDING
      #  * <tt>:subdomain</tt> - PENDING
      def remove(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "deladdondomain"
        }.merge(options))
      end

      # Add an addon domain with a coresponding subdomain
      #
      # ==== Required
      #  * <tt>:dir</tt> - PENDING
      #  * <tt>:newdomain</tt> - PENDING
      #  * <tt>:subdomain</tt> - PENDING
      def add(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "addaddondomain"
        }.merge(options))
      end

      # List addon domains
      #
      # ==== Optional
      #  * <tt>:regex</tt> - PENDING
      def list(options={})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listaddondomains"
        }.merge(options))
      end
    end
  end
end

