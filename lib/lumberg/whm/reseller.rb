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
    end
  end
end
