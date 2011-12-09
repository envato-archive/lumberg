module Lumberg
  module Cpanel
    class Email < Base
      def self.api_module; "Email"; end

      def checkmaindiscard; end

      # List forwarders
      #
      # ==== Optional
      #  * <tt>:domain</tt> - PENDING
      #  * <tt>:regex</tt> - PENDING
      def forwarders(options = {})
        Args.new(options) do |c|
          c.optionals :domain, :regex
        end

        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listforwards",
          :api_username => options.delete(:api_username)
        }, {
          :domain => options.delete(:domain),
          :regex  => options.delete(:regex)
        })
      end

      # List Mailman mailing lists
      #
      # ==== Optional
      #  * <tt>:domain</tt> - PENDING
      #  * <tt>:regex</tt> - PENDING
      def mailing_lists(options = {})
        Args.new(options) do |c|
          c.optionals :domain, :regex
        end

        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listlists",
          :api_username => options.delete(:api_username)
        }, {
          :domain => options.delete(:domain),
          :regex  => options.delete(:regex)
        })
      end

      def getalwaysaccept; end
      def listmaildomains; end
      def listmxs; end
      def listfilters; end
      def fetchcharmaps; end
      def listautoresponders; end
      def listdomainforwards; end

      # List email accounts. Uses the cPanel-preferred
      # API call Email::listpopswithdisk
      #
      # ==== Optional
      #  * <tt>:domain</tt> - PENDING
      #  * <tt>:regex</tt> - PENDING
      def accounts(options = {})
        Args.new(options) do |c|
          c.optionals :domain, :nearquotaonly, :no_validate, :regex
        end

        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listpopswithdisk",
          :api_username => options.delete(:api_username)
        }, {
          :domain        => options.delete(:domain),
          :regex         => options.delete(:regex),
          :nearquotaonly => options.delete(:nearquotaonly),
          :no_validate   => options.delete(:no_validate)
        })
      end

      # List email accounts.
      # Uses Email::listpops
      #
      # ==== Optional
      #  * <tt>:regex</tt> - PENDING
      def accounts_(options = {})
        Args.new(options) do |c|
          c.optionals :regex
        end

        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listpopswithdisk",
          :api_username => options.delete(:api_username)
        }, {
          :regex         => options.delete(:regex),
        })
      end

      def accounts_with_image(options = {})
      end

      def accounts_single(options = {})
      end


      def listdefaultaddresses; end
      def getabsbrowsedir; end
      def browseboxes; end
      def filterlist; end
      def tracefilter; end
      def fetchautoresponder; end
      def getdiskusage; end

      def listfilterbackups; end
      def listaliasbackups; end

    end
  end
end
