module Lumberg
  module Cpanel
    # Public: Allows users to create and manage GnuPG keys
    class Gpg < Base
      # Public: List public GPG keys installed for the user
      #
      # Returns Hash API response
      def list
        perform_request({ :api_function => 'listgpgkeys' })
      end

      # Public: Count the number of public GPG keys installed for a user. You
      # must have access to the 'gpg' feature to use this function.
      #
      # Returns Hash API response
      def count
        perform_request({ :api_function => 'number_of_public_keys' })
      end

      # Public: List GPG private (secret) keys associated with a user
      #
      # Returns Hash API response
      def list_private
        perform_request({ :api_function => 'listsecretgpgkeys' })
      end

      # Public: Count the number of private GPG keys installed for a user
      #
      # Returns Hash API response
      def count_private
        perform_request({ :api_function => 'number_of_private_keys' })
      end
    end
  end
end

