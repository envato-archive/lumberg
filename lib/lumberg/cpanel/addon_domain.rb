module Lumberg
  module Cpanel
    class AddonDomain < Base

      # Delete an addon domain. This will also remove the corresponding
      # subdomain and FTP account
      #
      # ==== Required
      #  * <tt>:domain</tt> - PENDING
      #  * <tt>:subdomain</tt> - PENDING
      def deladdondomain(options = {})
        Args.new(options) do |c|
          c.requires :domain, :subdomain
        end
      end

      # Add an addon domain with a coresponding subdomain
      #
      # ==== Required
      #  * <tt>:dir</tt> - PENDING
      #  * <tt>:newdomain</tt> - PENDING
      #  * <tt>:subdomain</tt> - PENDING
      def addaddondomain(options = {})
        Args.new(options) do |c|
          c.requires :dir, :newdomain, :subdomain
        end
      end

      # List addon domains
      #
      # ==== Optional
      #  * <tt>:regex</tt> - PENDING
      def listaddondomains
        Args.new(options) do |c|
          c.optional :regex
        end
      end
    end
  end
end

