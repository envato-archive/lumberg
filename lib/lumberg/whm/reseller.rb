module Lumberg
  module Whm
    class Reseller < Base
      def create(options = {})
        Args.new(options) do |c| 
          c.requires :username 
          c.booleans :makeowner
        end
        options[:user] = options.delete(:username)
        server.perform_request('setupreseller', options)
      end

      def list
        # This method is funky. That is all
        result = server.perform_request('listresellers', :key => 'reseller')
        result[:success] = true
        result[:params]  = {:resellers => result.delete(:params)}
        result
      end

      def add_ips(options = {})
        Args.new(options) do |c|
          c.requires :username
          c.optionals :ips
          c.booleans :delegate
        end

        options[:user] = options.delete(:username)
        server.perform_request('setresellerips', options)
      end

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

      def set_main_ip(options = {})
        Args.new(options) do |c|
          c.requires :username, :ip
        end

        options[:user] = options.delete(:username)
        server.perform_request('setresellermainip', options)
      end

      def set_package_limit(options = {})
        Args.new(options) do |c|
          c.requires :username, :no_limit, :package
          c.booleans :no_limit, :allowed
          c.optionals :allowed, :number
        end

        options[:user] = options.delete(:username)
        server.perform_request('setresellerpackagelimit', options)
      end

      def suspend(options = {})
        Args.new(options) do |c|
          c.requires :username
          c.optionals :reason
        end

        options[:user] = options.delete(:username)
        server.perform_request('suspendreseller', options)
      end

      def unsuspend(options = {})
        Args.new(options) do |c|
          c.requires :username
        end

        options[:user] = options.delete(:username)
        server.perform_request('unsuspendreseller', options)
      end

      def account_counts(options = {})
        Args.new(options) do |c|
          c.requires :username
        end

        options[:user] = options.delete(:username)
        server.perform_request('acctcounts', options.merge(:key => 'reseller'))
      end

      def set_nameservers(options = {})
        Args.new(options) do |c|
          c.requires :username
          c.optionals :nameservers
        end

        options[:user] = options.delete(:username)
        server.perform_request('setresellernameservers', options)
      end

      def stats(options = {})
        Args.new(options) do |c|
          c.requires :reseller
        end

        server.perform_request('resellerstats', options)
      end

      def list_acls
        server.perform_request('listacls', {:key => 'acls'})
      end

      def save_acl_list(options = {})
        Args.new(options) do |c|
          c.requires :acllist
          c.booleans "acl-add-pkg".to_sym, "acl-add-pkg-ip".to_sym, "acl-add-pkg-shell".to_sym, "acl-all".to_sym, "acl-allow-addoncreate".to_sym, "acl-allow-parkedcreate".to_sym, "acl-allow-unlimited-disk-pkgs".to_sym, "acl-allow-unlimited-pkgs".to_sym, "acl-clustering".to_sym, "acl-create-acct".to_sym, "acl-create-dns".to_sym, "acl-demo-setup".to_sym, "acl-disallow-shell".to_sym, "acl-edit-account".to_sym, "acl-edit-dns".to_sym, "acl-edit-mx".to_sym, "acl-edit-pkg".to_sym, "acl-frontpage".to_sym, "acl-kill-acct".to_sym, "acl-kill-dns".to_sym, "acl-limit-bandwidth".to_sym, "acl-list-accts".to_sym, "acl-mailcheck".to_sym, "acl-mod-subdomains".to_sym, "acl-news".to_sym, "acl-onlyselfandglobalpkgs".to_sym, "acl-park-dns".to_sym, "acl-passwd".to_sym, "acl-quota".to_sym, "acl-rearrange-accts".to_sym, "acl-res-cart".to_sym, "acl-status".to_sym, "acl-resftp".to_sym, "acl-restart".to_sym, "acl-show-bandwidth".to_sym, "acl-ssl".to_sym, "acl-ssl-gencrt".to_sym, "acl-stats".to_sym, "acl-suspend-acct".to_sym, "acl-upgrade-account".to_sym
          c.optionals "acl-add-pkg".to_sym, "acl-add-pkg-ip".to_sym, "acl-add-pkg-shell".to_sym, "acl-all".to_sym, "acl-allow-addoncreate".to_sym, "acl-allow-parkedcreate".to_sym, "acl-allow-unlimited-disk-pkgs".to_sym, "acl-allow-unlimited-pkgs".to_sym, "acl-clustering".to_sym, "acl-create-acct".to_sym, "acl-create-dns".to_sym, "acl-demo-setup".to_sym, "acl-disallow-shell".to_sym, "acl-edit-account".to_sym, "acl-edit-dns".to_sym, "acl-edit-mx".to_sym, "acl-edit-pkg".to_sym, "acl-frontpage".to_sym, "acl-kill-acct".to_sym, "acl-kill-dns".to_sym, "acl-limit-bandwidth".to_sym, "acl-list-accts".to_sym, "acl-mailcheck".to_sym, "acl-mod-subdomains".to_sym, "acl-news".to_sym, "acl-onlyselfandglobalpkgs".to_sym, "acl-park-dns".to_sym, "acl-passwd".to_sym, "acl-quota".to_sym, "acl-rearrange-accts".to_sym, "acl-res-cart".to_sym, "acl-status".to_sym, "acl-resftp".to_sym, "acl-restart".to_sym, "acl-show-bandwidth".to_sym, "acl-ssl".to_sym, "acl-ssl-gencrt".to_sym, "acl-stats".to_sym, "acl-suspend-acct".to_sym, "acl-upgrade-account".to_sym
        end

        server.perform_request('saveacllist', options.merge(:key => 'results'))
      end

      def set_acls(options = {})
        Args.new(options) do |c|
          c.requires :reseller
          c.booleans "acl-add-pkg".to_sym, "acl-add-pkg-ip".to_sym, "acl-add-pkg-shell".to_sym, "acl-all".to_sym, "acl-allow-addoncreate".to_sym, "acl-allow-parkedcreate".to_sym, "acl-allow-unlimited-disk-pkgs".to_sym, "acl-allow-unlimited-pkgs".to_sym, "acl-clustering".to_sym, "acl-create-acct".to_sym, "acl-create-dns".to_sym, "acl-demo-setup".to_sym, "acl-disallow-shell".to_sym, "acl-edit-account".to_sym, "acl-edit-dns".to_sym, "acl-edit-mx".to_sym, "acl-edit-pkg".to_sym, "acl-frontpage".to_sym, "acl-kill-acct".to_sym, "acl-kill-dns".to_sym, "acl-limit-bandwidth".to_sym, "acl-list-accts".to_sym, "acl-mailcheck".to_sym, "acl-mod-subdomains".to_sym, "acl-news".to_sym, "acl-onlyselfandglobalpkgs".to_sym, "acl-park-dns".to_sym, "acl-passwd".to_sym, "acl-quota".to_sym, "acl-rearrange-accts".to_sym, "acl-res-cart".to_sym, "acl-status".to_sym, "acl-resftp".to_sym, "acl-restart".to_sym, "acl-show-bandwidth".to_sym, "acl-ssl".to_sym, "acl-ssl-gencrt".to_sym, "acl-stats".to_sym, "acl-suspend-acct".to_sym, "acl-upgrade-account".to_sym
          c.optionals :acllist, "acl-add-pkg".to_sym, "acl-add-pkg-ip".to_sym, "acl-add-pkg-shell".to_sym, "acl-all".to_sym, "acl-allow-addoncreate".to_sym, "acl-allow-parkedcreate".to_sym, "acl-allow-unlimited-disk-pkgs".to_sym, "acl-allow-unlimited-pkgs".to_sym, "acl-clustering".to_sym, "acl-create-acct".to_sym, "acl-create-dns".to_sym, "acl-demo-setup".to_sym, "acl-disallow-shell".to_sym, "acl-edit-account".to_sym, "acl-edit-dns".to_sym, "acl-edit-mx".to_sym, "acl-edit-pkg".to_sym, "acl-frontpage".to_sym, "acl-kill-acct".to_sym, "acl-kill-dns".to_sym, "acl-limit-bandwidth".to_sym, "acl-list-accts".to_sym, "acl-mailcheck".to_sym, "acl-mod-subdomains".to_sym, "acl-news".to_sym, "acl-onlyselfandglobalpkgs".to_sym, "acl-park-dns".to_sym, "acl-passwd".to_sym, "acl-quota".to_sym, "acl-rearrange-accts".to_sym, "acl-res-cart".to_sym, "acl-status".to_sym, "acl-resftp".to_sym, "acl-restart".to_sym, "acl-show-bandwidth".to_sym, "acl-ssl".to_sym, "acl-ssl-gencrt".to_sym, "acl-stats".to_sym, "acl-suspend-acct".to_sym, "acl-upgrade-account".to_sym
        end

        server.perform_request('setacls', options)
      end

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
