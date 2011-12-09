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
        Args.new(options) do |c|
          c.requires :domain, :subdomain
        end

        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "deladdondomain",
          :api_username => options.delete(:api_username)
        }, {
          :domain    => options.delete(:domain),
          :subdomain => options.delete(:subdomain)
        })
      end

      # Add an addon domain with a coresponding subdomain
      #
      # ==== Required
      #  * <tt>:dir</tt> - PENDING
      #  * <tt>:newdomain</tt> - PENDING
      #  * <tt>:subdomain</tt> - PENDING
      def add(options = {})
        Args.new(options) do |c|
          c.requires :dir, :newdomain, :subdomain
        end

        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "addaddondomain",
          :api_username => options.delete(:api_username)
        }, {
          :dir       => options.delete(:dir),
          :newdomain => options.delete(:newdomain),
          :subdomain => options.delete(:subdomain)
        })
      end

      # List addon domains
      #
      # ==== Optional
      #  * <tt>:regex</tt> - PENDING
      def list(options={})
        Args.new(options) do |c|
          c.optionals :regex
        end

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

