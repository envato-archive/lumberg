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

      # List domains that can send/receive mail
      #
      # ==== Optional
      #  * <tt>:skipmain</tt> - PENDING
      def domains(options = {})
        Args.new(options) do |c|
          c.optionals :skipmain
        end

        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listmaildomains",
          :api_username => options.delete(:api_username)
        }, {
          :skipmain => options.delete(:skipmain)
        })
      end

      # List mail exchanger information
      #
      # ==== Optional
      #  * <tt>:domain</tt> - PENDING
      def mx(options = {})
        Args.new(options) do |c|
          c.optionals :domain
        end

        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listmxs",
          :api_username => options.delete(:api_username)
        }, {
          :domain => options.delete(:domain)
        })
      end

      # Set mail delivery for a domain
      #
      # ==== Requires
      #  * <tt>:domain</tt> - PENDING
      #  * <tt>:delivery</tt> - PENDING
      def set_mail_delivery(options = {})
        Args.new(options) do |c|
          c.requires :domain, :delivery
        end

        delivery_vals = [:local, :remote, :auto, :secondary]
        unless delivery_vals.include?(options[:delivery].to_sym)
          raise "Invalid :delivery option"
        end

        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "setalwaysaccept",
          :api_username => options.delete(:api_username)
        }, {
          :domain  => options.delete(:domain),
          :mxcheck => options.delete(:delivery)
        })
      end

      def getalwaysaccept; end
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
      # Uses Email::listpops; you probably want to use #accounts
      #
      # ==== Optional
      #  * <tt>:regex</tt> - PENDING
      def accounts_(options = {})
        Args.new(options) do |c|
          c.optionals :regex
        end

        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listpops",
          :api_username => options.delete(:api_username)
        }, {
          :regex => options.delete(:regex),
        })
      end

      # List email accounts.
      # Uses Email::listpopswithimage; you probably want to use #accounts
      def accounts_with_image(options = {})
        perform_request(
          :api_module   => self.class.api_module,
          :api_function => "listpopswithimage",
          :api_username => options.delete(:api_username)
        )
      end

      # List email accounts.
      # Uses Email::listpopssingle; you probably want to use #accounts
      def accounts_single(options = {})
        perform_request(
          :api_module   => self.class.api_module,
          :api_function => "listpopssingle",
          :api_username => options.delete(:api_username)
        )
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
