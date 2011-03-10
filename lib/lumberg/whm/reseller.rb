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
    end
  end
end
