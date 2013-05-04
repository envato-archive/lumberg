module Lumberg
  module Cpanel
    # Public: The Passwd module allows users to change their cPanel account's
    # password.
    class Password < Base
      def self.api_module; "Passwd"; end

      # Public: Change a cPanel account's password.
      #
      # options - Hash options for API call params (default: {})
      #   :newpass - String new password for the Cpanel account
      #   :oldpass - String old password for the Cpanel account
      #
      # Examples
      #   api_args = { host: "x.x.x.x", hash: "pass", api_username: "user" }
      #   password = Lumberg::Cpanel::Password.new(api_args.dup)
      #
      #   password.modify(new: "", old: "")
      #
      # Returns Hash API response.
      def modify(options = {})
        perform_request({ :api_function => 'change_password' }.merge(options))
      end

      # Public: Enables or disables Digest Authentication for an account.
      #         Windows Vista(R), Windows(R) 7, and Windows(R) 8 require Digest
      #         Authentication support to be enabled in order to access your
      #         Web Disk over a clear text, unencrypted connection. If the
      #         server has a SSL certificate signed by a recognized certificate
      #         authority and you are able to make an SSL connection over port
      #         2078, you do not need to enable this.
      #
      # options     - Hash options for API call params (default: {})
      #   :password - String current password for your account
      #   :enable   - Boolean value indicating if Digest Authentication should
      #               be enabled or disabled for the web disk user.
      #
      # Examples
      #   api_args = { host: "x.x.x.x", hash: "pass", api_username: "user" }
      #   password = Lumberg::Cpanel::Password.new(api_args.dup)
      #
      #   password.digest_authentication(password: "", enable: true)
      #
      # Returns Hash API response.
      def digest_authentication(options = {})
        options[:enabledigest] = options.delete([:enable]) ? 1 : 0
        perform_request({ :api_function => 'set_digest_auth' }.merge(options))
      end
    end
  end
end

