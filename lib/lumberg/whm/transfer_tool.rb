module Lumberg
  module Whm
    class TransferTool < Base

      # Public: Creates a new transfer session.
      #
      # options - Hash options for API call params. (default: {})
      #   :host              - String hostname of the remote server.
      #   :user              - String username to connect on remote server.
      #   :password          - String password for account specified above.
      #
      # Returns Hash API Response.
      def create(options = {})
        default_options = { remote_server_type: 'auto',
                            port: 22,
                            root_escalation_method: 'sudo',
                            transfer_threads: 2,
                            restore_threads: 2,
                            unrestricted_restore: 1,
                            compressed: 1,
                            unencrypted: 0,
                            use_backups: 1,
                            low_priority: 0,
                            enable_custom_pkgacct: 0 }

        options.merge!("api.version" => "1")

        server.force_response_type = :xfer

        server.perform_request(
          'create_remote_root_transfer_session',
          default_options.merge(options)
        )
      end

      # Public: Checks a given transfer session ID.
      #
      # transfer_session_id - String ID of the transfer session.
      #
      # Returns Hash API Response.
      def check(transfer_session_id)
        options = { transfer_session_id: transfer_session_id }

        server.force_response_type = :xfer

        server.perform_request(
          'retrieve_transfer_session_remote_analysis',
          options.merge("api.version" => "1")
        )
      end

      # Public: Validates a system user, preventing account conflicts.
      #
      # username - String username to validate.
      #
      # Returns Hash API Response.
      def validate_user(username)
        options = { user: username }

        server.force_response_type = :xfer

        server.perform_request(
          'validate_system_user',
          options.merge("api.version" => "1")
        )
      end

      # Public: Enqueues a transfer session.
      #
      # options - Hash options for API call params. (default: {})
      #   :transfer_session_id - String ID of the transfer session.
      #   :queue               - String transfer queue name. Can be one of the
      #                          following: LegacyAccountBackup,
      #                          FeatureListRemoteRoot, PackageRemoteRoot,
      #                          AccountLocal, AccountRemoteRoot and
      #                          AccountRemoteUser.
      #                          (default: 'AccountRemoteRoot')
      #   :size                - Integer account size in Bytes.
      #   :other_arguments     - Doc here
      #   https://documentation.cpanel.net/display/SDK/WHM+API+1+-+enqueue_transfer_item
      #
      # Returns Hash API Reponse.
      def enqueue(options = {})
        default_options = { "api.version" => "1" }

        options["module"] = options.delete(:queue) || "AccountRemoteRoot"

        if %w(AccountRemoteRoot AccountRemoteUser AccountLocal).include?(options["module"])
          options[:localuser] = options.delete(:localuser) || options[:user]
        end

        server.force_response_type = :xfer

        server.perform_request('enqueue_transfer_item', default_options.merge(options))
      end

      # Public: Starts or restarts a transfer.
      #
      # transfer_session_id - String ID of the transfer session.
      #
      # Returns Hash API Response.
      def start(transfer_session_id)
        options = { transfer_session_id: transfer_session_id }

        server.force_response_type = :xfer

        server.perform_request(
          'start_transfer_session',
          options.merge("api.version" => "1")
        )
      end

      # Public: Gets migration status.
      #
      # transfer_session_id - String ID of the transfer session.
      #
      # Returns Hash API Response.
      def status(transfer_session_id)
        options = { transfer_session_id: transfer_session_id }

        server.force_response_type = :xfer

        server.perform_request(
          'get_transfer_session_state',
          options.merge("api.version" => "1")
        )
      end

      # Public: Shows transfer log.
      #
      # transfer_session_id - String ID of the transfer session.
      # type                - Symbol log type, can be either `:common` or
      #                       `:error`. (default: :common)
      #
      # Returns Hash API Response.
      def show_log(transfer_session_id, log_type = :common)
        options = { logfile: log_type == :common ? 'master.log' : 'master.error_log',
                    transfer_session_id: transfer_session_id }

        server.force_response_type = :xfer

        server.perform_request(
          'fetch_transfer_session_log',
          options.merge("api.version" => "1")
        )
      end

      # Public: Pauses a given transfer session.
      #
      # transfer_session_id - String ID of the transfer session.
      #
      # Returns Hash API Response.
      def pause(transfer_session_id)
        options = { transfer_session_id: transfer_session_id }

        server.force_response_type = :xfer

        server.perform_request(
          'pause_transfer_session',
          options.merge("api.version" => "1")
        )
      end
    end
  end
end
