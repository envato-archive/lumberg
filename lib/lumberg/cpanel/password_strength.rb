module Lumberg
  module Cpanel
    # Public: This module provides access to cPanel's password scoring system.
    class PasswordStrength < Base
      def self.api_module; "PasswdStrength"; end

      # Public: Retrieve the strength of a specified password. This API call
      #         is only available in cPanel & WHM 11.32.
      #
      # options - Hash options for API call params (default: {})
      #   :password - String password to test strength
      #
      # Examples
      #   api_args = { host: "x.x.x.x", hash: "pass", api_username: "user" }
      #   passwd_strength = Lumberg::Cpanel::PasswordStrength.new(api_args.dup)
      #
      #   passwd_strength.strength(password: "weakpass")
      #
      # Returns Hash API response.
      def strength(options = {})
        perform_request(options.merge( :api_function => 'get_password_strength' ))
      end

      # Public: Return the required password strength for a specific
      #         application.
      #
      # options - Hash options for API call params (default: {})
      #   :app - String The application corresponding to the password strength
      #          you would like to retrieve. Accepted values include 'htaccess',
      #          'passwd', 'ftp', 'createacct', 'bandmin', 'cpaddons', 'pop',
      #          'sshkey', 'postgres', 'webdisk', and 'mysql'.
      #
      # Examples
      #   api_args = { host: "x.x.x.x", hash: "pass", api_username: "user" }
      #   password_strength = Lumberg::Cpanel::PasswordStrength.new(api_args.dup)
      #
      #   password_strength.required_strength(app: 'htaccess')
      #
      # Returns Hash API response.
      def required_strength(options = {})
        perform_request(options.merge( :api_function => 'get_required_strength' ))
      end

      # Public: Return password strength settings set in WHM's 'Main >>
      #         Security Center >> Password Strength Configuration' section.
      #         If this requirement is in place, this function will return
      #         all password strength requirements on a per-application basis.
      #
      # options - Hash options for API call params (default: {})
      #
      # Examples
      #   api_args = { host: "x.x.x.x", hash: "pass", api_username: "user" }
      #   password_strength = Lumberg::Cpanel::PasswordStrength.new(api_args.dup)
      #
      #   password_strength.all_required_strengths
      #
      # Returns Hash API response.
      def all_required_strengths(options = {})
        perform_request(options.merge( :api_function => 'appstrengths' ))
      end
    end
  end
end

