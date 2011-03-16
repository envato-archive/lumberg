module Lumberg
  module Whm
    class Reseller < Base
      # Gives reseller status to an account.
      #
      # *Note:* The user must already exist to be made a reseller. This function will not create an account. If the account does not yet exist, you can use the createacct function to set it up before conferring reseller privileges.
      #
      # ==== Required 
      #  * <tt>:username</tt> - PENDING
      def create(options = {})
        Args.new(options) do |c| 
          c.requires :username 
          c.booleans :makeowner
        end
        options[:user] = options.delete(:username)
        server.perform_request('setupreseller', options)
      end

      # Lists the usernames of all resellers on the server
      def list
        # This method is funky. That is all
        result = server.perform_request('listresellers', :key => 'reseller')
        result[:success] = true
        result[:params]  = {:resellers => result.delete(:params)}
        result
      end

      # Adds IP addresses to a reseller account
      #
      # ==== Required 
      #  * <tt>:username</tt> - PENDING
      #
      # ==== Optional 
      #  * <tt>:ips</tt> - PENDING
      def add_ips(options = {})
        Args.new(options) do |c|
          c.requires :username
          c.optionals :ips
          c.booleans :delegate
        end

        options[:user] = options.delete(:username)
        server.perform_request('setresellerips', options)
      end

      # Specifies the amount of bandwidth and disk space a reseller is able to use
      #
      # ==== Required 
      #  * <tt>:username</tt> - PENDING
      #
      # ==== Optional 
      #  * <tt>:account_limit</tt> - PENDING
      #  * <tt>:bandwidth_limit</tt> - PENDING
      #  * <tt>:diskspace_limit</tt> - PENDING
      def set_limits(options = {})
        Args.new(options) do |c|
          c.requires :username
          c.optionals :account_limit, :bandwidth_limit, :diskspace_limit
          c.booleans :enable_account_limit, :enable_resource_limits, :enable_overselling,
                     :enable_overselling_bandwidth, :enable_overselling_diskspace, :enable_package_limits,
                     :enable_package_limit_numbers
        end

        options[:user] = options.delete(:username)
        server.perform_request('setresellerlimits', options)
      end

      # Terminates a reseller's main account, as well as all accounts owned by the reseller
      #
      # ==== Required 
      #  * <tt>:reseller</tt> - PENDING
      def terminate(options = {})
        Args.new(options) do |c|
          c.requires :reseller
          c.booleans :terminatereseller
        end
      
        # WTF, seriously?
        wtf = "I understand this will irrevocably remove all the "
        wtf << "accounts owned by the reseller #{options[:reseller]}"
        options[:verify]  = wtf

        server.perform_request('terminatereseller', options)
      end

      # Assigns a main, shared IP address to a reseller
      #
      # ==== Required 
      #  * <tt>:username</tt> - PENDING
      #  * <tt>:ip</tt> - PENDING
      def set_main_ip(options = {})
        Args.new(options) do |c|
          c.requires :username, :ip
        end

        options[:user] = options.delete(:username)
        server.perform_request('setresellermainip', options)
      end

      # Sets which packages resellers are able to use. It also allows you to define the number of times a package can be used by a reseller
      #
      # ==== Required 
      #  * <tt>:username</tt> - PENDING
      #  * <tt>:no_limit</tt> - PENDING
      #  * <tt>:package</tt> - PENDING
      #
      # ==== Optional 
      #  * <tt>:allowed</tt> - PENDING
      #  * <tt>:number</tt> - PENDING
      def set_package_limit(options = {})
        Args.new(options) do |c|
          c.requires :username, :no_limit, :package
          c.booleans :no_limit, :allowed
          c.optionals :allowed, :number
        end

        options[:user] = options.delete(:username)
        server.perform_request('setresellerpackagelimit', options)
      end

      # Suspends a reseller's account. The suspension will prevent the reseller from accessing his or her account
      #
      # ==== Required 
      #  * <tt>:username</tt> - PENDING
      #
      # ==== Optional 
      #  * <tt>:reason</tt> - PENDING
      def suspend(options = {})
        Args.new(options) do |c|
          c.requires :username
          c.optionals :reason
        end

        options[:user] = options.delete(:username)
        server.perform_request('suspendreseller', options)
      end

      # Unsuspends a reseller's account
      #
      # ==== Required 
      #  * <tt>:username</tt> - PENDING
      def unsuspend(options = {})
        Args.new(options) do |c|
          c.requires :username
        end

        options[:user] = options.delete(:username)
        server.perform_request('unsuspendreseller', options)
      end

      # Lists the total number of accounts owned by a reseller, as well as how many suspended accounts the reseller owns, and what the reseller's account creation limit is, if any.
      # If no reseller is specified, counts will be provided for the reseller who is currently logged in.
      # 
      # *Note:* Counts for other users will only be provided if the user issuing the function call has root-level permissions or owns the provided account.
      #
      # ==== Required 
      #  * <tt>:username</tt> - PENDING
      def account_counts(options = {})
        Args.new(options) do |c|
          c.requires :username
        end

        options[:user] = options.delete(:username)
        server.perform_request('acctcounts', options.merge(:key => 'reseller'))
      end

      # Defines a reseller's nameservers. Additionally, you may use it to reset a reseller's nameservers to the default settings
      #
      # ==== Required 
      #  * <tt>:username</tt> - PENDING
      #
      # ==== Optional 
      #  * <tt>:nameservers</tt> - PENDING
      def set_nameservers(options = {})
        Args.new(options) do |c|
          c.requires :username
          c.optionals :nameservers
        end

        options[:user] = options.delete(:username)
        server.perform_request('setresellernameservers', options)
      end

      # Shows account statistics for a specific reseller's accounts
      #
      # ==== Required 
      #  * <tt>:reseller</tt> - PENDING
      def stats(options = {})
        Args.new(options) do |c|
          c.requires :reseller
        end

        server.perform_request('resellerstats', options)
      end

      # Lists the saved reseller ACL lists on the server
      def list_acls
        server.perform_request('listacls', {:key => 'acls'})
      end

      # Creates a new reseller ACL list
      #
      # ==== Required 
      #  * <tt>:acllist</tt> - PENDING
      def save_acl_list(options = {})
        optional_args = [
                  "acl-add-pkg", "acl-add-pkg-ip", "acl-add-pkg-shell", "acl-all", "acl-allow-addoncreate", 
                  "acl-allow-parkedcreate", "acl-allow-unlimited-disk-pkgs", "acl-allow-unlimited-pkgs", 
                  "acl-clustering", "acl-create-acct", "acl-create-dns", "acl-demo-setup", "acl-disallow-shell", 
                  "acl-edit-account", "acl-edit-dns", "acl-edit-mx", "acl-edit-pkg", "acl-frontpage", 
                  "acl-kill-acct", "acl-kill-dns", "acl-limit-bandwidth", "acl-list-accts", "acl-mailcheck",
                  "acl-mod-subdomains", "acl-news", "acl-onlyselfandglobalpkgs", "acl-park-dns", "acl-passwd", 
                  "acl-quota", "acl-rearrange-accts", "acl-res-cart", "acl-status", "acl-resftp", "acl-restart", 
                  "acl-show-bandwidth", "acl-ssl", "acl-ssl-gencrt", "acl-stats", "acl-suspend-acct", "acl-upgrade-account"
        ].collect { |option| option.to_sym }

        Args.new(options) do |c|
          c.requires :acllist
          c.booleans *optional_args 
          c.optionals *optional_args
        end

        server.perform_request('saveacllist', options.merge(:key => 'results'))
      end

      # Sets the ACL for a reseller, or modifies specific ACL items for a reseller
      #
      # ==== Required 
      #  * <tt>:reseller</tt> - PENDING
      #
      # ==== Optional 
      #  * <tt>:acllist</tt> - PENDING
      #  * <tt>:*optional_args</tt> - PENDING
      def set_acls(options = {})
        optional_args = [
                  "acl-add-pkg", "acl-add-pkg-ip", "acl-add-pkg-shell", "acl-all", "acl-allow-addoncreate", 
                  "acl-allow-parkedcreate", "acl-allow-unlimited-disk-pkgs", "acl-allow-unlimited-pkgs", 
                  "acl-clustering", "acl-create-acct", "acl-create-dns", "acl-demo-setup", "acl-disallow-shell", 
                  "acl-edit-account", "acl-edit-dns", "acl-edit-mx", "acl-edit-pkg", "acl-frontpage", 
                  "acl-kill-acct", "acl-kill-dns", "acl-limit-bandwidth", "acl-list-accts", "acl-mailcheck",
                  "acl-mod-subdomains", "acl-news", "acl-onlyselfandglobalpkgs", "acl-park-dns", "acl-passwd", 
                  "acl-quota", "acl-rearrange-accts", "acl-res-cart", "acl-status", "acl-resftp", "acl-restart", 
                  "acl-show-bandwidth", "acl-ssl", "acl-ssl-gencrt", "acl-stats", "acl-suspend-acct", "acl-upgrade-account"
        ].collect { |option| option.to_sym }

        Args.new(options) do |c|
          c.requires :reseller
          c.booleans *optional_args
          c.optionals :acllist, *optional_args
        end

        server.perform_request('setacls', options)
      end

      # Removes reseller status from an account
      #
      #  *Note:* This function will not delete the account; it will only remove its reseller status
      def unsetup(options = {})
        Args.new(options) do |c|
          c.requires :username
        end

        options[:user] = options.delete(:username)
        server.perform_request('unsetupreseller', options)
      end
    end
  end
end
