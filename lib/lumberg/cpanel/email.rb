module Lumberg
  module Cpanel
    class Email < Base
      def self.api_module; "Email"; end

      # Get info about how the main email account handles undeliverable mail
      def main_discard
        perform_request(
          :api_module   => self.class.api_module,
          :api_function => "checkmaindiscard"
        )
      end

      # Add a forwarder
      #
      # ==== Required
      #  * <tt>:domain</tt> - Forwarder domain
      #  * <tt>:email</tt> - Local part ("user" if "user@domain.com")
      #  * <tt>:fwdopt</tt> - :pipe, :fwd, :system, :blackhole, or :fail
      #  * <tt>:fwdemail</tt> - Destination email address
      #
      # ==== Optional
      #  * <tt>:fwdsystem</tt> - System account to forward to. Should only be
      #                          used if "fwdopt" is set to "system"
      #  * <tt>:failmsgs</tt> - Set failure message. Only used if "fwdopt" is
      #                         set to "fail"
      #  * <tt>:pipefwd</tt> - Path to program to pipe to. Only used if 
      #                        "fwdopt" is set to "pipe"
      def add_forwarder(options = {})
        fwdopt_vals = [:pipe, :fwd, :system, :blackhole, :fail]
        unless fwdopt_vals.include?(options[:fwdopt].to_sym)
          raise "Invalid :fwdopt option"
        end

        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "addforward"
        }.merge(options))
      end

      # List forwarders
      #
      # ==== Optional
      #  * <tt>:domain</tt> - PENDING
      #  * <tt>:regex</tt> - PENDING
      def forwarders(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listforwards"
        }.merge(options))
      end

      # Retrieve a list of domains that use aliases and 
      # custom catch-all addresses
      def domains_with_aliases
        perform_request(
          :api_module   => self.class.api_module,
          :api_function => "listaliasbackups"
        )
      end

      # Add a mailing list
      #
      # === Required
      #  * <tt>:list</tt> - Mailing liist name
      #  * <tt>:password</tt> - Mailing list password
      #  * <tt>:domain</tt> - Mailing list domain
      def add_mailing_list(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "addlist",
          :api_version  => 1, # :(
          "arg-0"       => options[:list],
          "arg-1"       => options[:password],
          "arg-2"       => options[:domain]
        })
      end

      # List Mailman mailing lists
      #
      # ==== Optional
      #  * <tt>:domain</tt> - PENDING
      #  * <tt>:regex</tt> - PENDING
      def mailing_lists(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listlists"
        }.merge(options))
      end

      # List domains that can send/receive mail
      #
      # ==== Optional
      #  * <tt>:skipmain</tt> - PENDING
      def domains(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listmaildomains"
        }.merge(options))
      end

      # List mail exchanger information
      #
      # ==== Required
      #  * <tt>:domain</tt> - PENDING
      def mx(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listmxs"
        }.merge(options))
      end

      # Set mail delivery for a domain
      #
      # ==== Requires
      #  * <tt>:domain</tt> - PENDING
      #  * <tt>:delivery</tt> - PENDING
      def set_mail_delivery(options = {})
        delivery_vals = [:local, :remote, :auto, :secondary]
        unless delivery_vals.include?(options[:delivery].to_sym)
          raise "Invalid :delivery option"
        end

        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "setalwaysaccept",
          :mxcheck      => options[:delivery]
        }.merge(options))
      end

      # Check cPanel config for local mail delivery setting.
      # This function checks cPanel config, not DNS.
      #
      # ==== Optional
      #   * <tt>:domain</tt> - Domain to check. Will return settings for all
      #                        domains if omitted.
      def check_local_delivery(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "getalwaysaccept"
        }.merge(options))
      end

      # Add a new email filter. See 
      # http://docs.cpanel.net/twiki/bin/view/ApiDocs/Api2/ApiEmail#Email::storefilter
      # for gory details.
      #
      # ==== Required
      #  * <tt>:account</tt> - PENDING
      #  * <tt>:action</tt> - PENDING
      #  * <tt>:dest</tt> - PENDING
      #  * <tt>:filtername</tt> - PENDING
      #  * <tt>:match</tt> - PENDING
      #  * <tt>:opt</tt> - PENDING
      #  * <tt>:part</tt> - PENDING
      #  * <tt>:val</tt> - PENDING
      #
      # ==== Optional
      #  * <tt>:oldfiltername</tt> - PENDING
      def add_filter(options = {})
      end

      # Retrieve a list of "old-style" email filters from .filter file.
      # Lists account-level and user-level filters
      #
      # You probably want to use #filters
      def filters_
        perform_request(
          :api_module   => self.class.api_module,
          :api_function => "listfilters"
        )
      end

      # Retrieve a list of email filters
      #
      # ==== Optional 
      #  * <tt>:account</tt> - Lists user-level filters if email address given.
      #                        Lists user-level filters associated with default
      #                        address if cPanel username given.
      #                        Lists account-level filters if omitted.
      def filters(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "filterlist"
        }.merge(options))
      end

      def fetchcharmaps; end
      def listautoresponders; end
      def listdomainforwards; end

      # Add a POP account
      #
      # ==== Required
      #  * <tt>:domain</tt> - Domain for the email account
      #  * <tt>:email</tt> - Local part of email address. 
      #                      "user" if "user@domain"
      #  * <tt>:password</tt> - Password for email account
      #  * <tt>:quota</tt> - Disk space quota in MB. 0 for unlimited
      def add_account(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "addpop"
        }.merge(options))
      end

      def remove_account; end # delpop
      def edit_quota; end # editquota

      # List email accounts. Uses the cPanel-preferred
      # API call Email::listpopswithdisk
      #
      # ==== Optional
      #  * <tt>:domain</tt> - PENDING
      #  * <tt>:regex</tt> - PENDING
      def accounts(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listpopswithdisk"
        }.merge(options))
      end

      # List email accounts.
      # Uses Email::listpops; you probably want to use #accounts
      #
      # ==== Optional
      #  * <tt>:regex</tt> - PENDING
      def accounts_(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listpops"
        }.merge(options))
      end

      # List email accounts.
      # Uses Email::listpopswithimage; you probably want to use #accounts
      def accounts_with_image(options = {})
        perform_request(
          :api_module   => self.class.api_module,
          :api_function => "listpopswithimage"
        )
      end

      # List email accounts.
      # Uses Email::listpopssingle; you probably want to use #accounts
      def accounts_single(options = {})
        perform_request(
          :api_module   => self.class.api_module,
          :api_function => "listpopssingle"
        )
      end

      # Retrieve default address info
      #
      # ==== Required
      #  * <tt>:domain</tt> - Default address domain
      def default_address(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listdefaultaddresses"
        }.merge(options))
      end

      def listfilterbackups; end
      def filterlist; end
      def tracefilter; end
      def fetchautoresponder; end


      # Retrieve disk usage information for an email account
      #
      # ==== Required
      #  * <tt>:domain</tt> - "domain.com" if "user@domain.com"
      #  * <tt>:login</tt> - "user" if "user@domain.com"
      def disk_usage(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "getdiskusage"
        }.merge(options))
      end

      # Retrieve full path to a mail folder
      #
      # ==== Required
      #  * <tt>:account</tt> - Email address
      #
      # ==== Optional
      #  * <tt>:dir</tt> - The mail folder you with to query for its
      #                    full path. Defaults to "mail"
      def mail_dir(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "getabsbrowsedir"
        }.merge(options))
      end

      # Retrieve a list of mail dirs
      #
      # === Optional
      #  * <tt>:account</tt> - Email account to review
      #  * <tt>:dir</tt> - Which mail directories to display. 
      #                    "default" or "mail" will list all mail dirs.
      #                    Providing a domain will list dirs related to 
      #                    the domain.
      #  * <tt>:showdotfiles</tt> - View hidden directories? 
      def mail_dirs(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "browseboxes"
        }.merge(options))
      end


    end
  end
end
