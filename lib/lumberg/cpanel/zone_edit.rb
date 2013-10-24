module Lumberg
  module Cpanel
    # Public: This module allows users to modify their domains
    class ZoneEdit < Base
      # Public: Retrieve a list of your account's zones and zone file contents.
      #
      # Returns Hash API Response
      def list
        perform_request({ api_function: 'fetchzones' })
      end

      # Public: Add an A, CNAME, or TXT record to a zone file, specified by
      # line number
      #
      # options - Hash options for API call params (default: {})
      #   :domain - String addon domain for which yo wish to add an entry
      #   :name - String name of the record, aka subdomain
      #   :type - String type of the record you wish to add to the zone file.
      #           Acceptable values include A, CNAME or TXT
      #   :txt  - String text you wish to contain in your TXT record. Required
      #           parameter when you specify "TXT" in the :type parameter
      #           (default: '')
      #   :cname - String required parameter when you specify CNAME in the
      #            :type parameter (default: '')
      #   :address - String ip address to map to the subdomain. (default: '')
      #   :ttl - Integer time to live in seconds (default: 0)
      #   :class - String class to be used for the record. Ordinarily this
      #            parameter is not required (default: '')
      #
      # Returns Hash API response.
      def create(options = {})
        options[:txtdata] = options.delete(:txt)
        perform_request({ api_function: 'add_zone_record' }.merge(options))
      end

      # Public: Show dns zone for a domain
      #
      # options - Hash options for API call params (default: {})
      #   :domain - String domain that corresponds to the zone file you wish to
      #             show
      #   :get_custom_entries - Boolean parameter. Entering a value of "1" will
      #                         cause the function to return only non-essential
      #                         A and CNAME records. These will include www.*,
      #                         ftp.*, mail.* and localhost.* (default: '')
      #   :keys - String parameter that may contain a serie of values, all of
      #           which act the same way. Each value searches the data
      #           structure, like a grep, for a single hash (line of the zone
      #           file). Acceptable values include: line, ttl, name, class,
      #           address, type, txtdata, preference and exchange.
      #
      # Returns Hash API response.
      def show(options = {})
        options[:customonly] = options.delete(:get_custom_entries)
        perform_request({ api_function: 'fetchzone' }.merge(options))
      end

      # Public: Revert a zone file to its original state.
      #
      # options - Hash options for API call params (default: {})
      #   :domain - String domain that corresponds to the zone file you wish to
      #             revert
      #
      # Returns Hash API response
      def reset(options = {})
        perform_request({ api_function: 'resetzone' })
      end

      # Public: Edit an A, CNAME, or TXT record in a zone file, specified by
      # line number.  This function works nicely with "show" method to easily
      # fetch line number and record information.
      #
      # options - Hash options for API call params (default: {})
      #   :domain - String domain that corresponds to the zone you wish to edit
      #   :line - Integer line number of the zone file you wish to edit
      #   :type - The type fo record you wish to add to the zone file.
      #           Acceptable values include A, CNAME or TXT. Each type of
      #           record requires a specific parameter
      #   :txt  - String text you wish to contain in your TXT record. Required
      #           parameter when you specify "TXT" in the :type parameter
      #           (default: '')
      #   :cname - String required parameter when you specify CNAME in the
      #            :type parameter (default: '')
      #   :address - String ip address to map to the subdomain. (default: '')
      #   :ttl - Integer time to live in seconds (default: 0)
      #   :class - String class to be used for the record. Ordinarily this
      #            parameter is not required (default: '')
      #
      # Returns Hash API response.
      def edit(options = {})
        options[:Line]    = options.delete(:line)
        options[:txtdata] = options.delete(:txt)
        perform_request({ api_function: 'edit_zone_record' }.merge(options))
      end

      # Public: Remove lines from a DNS zone file. You may only remove A, TXT,
      # and CNAME records with this function.
      #
      # options - Hash options for API call params (default: {})
      #   :domain - String domain that corresponds to the zone you wish to
      #             remove a line
      #   :line - Integer line number of the zone file you wish to remove. Use
      #           "show" method to obtain the line number of a record
      #
      # Returns Hash API response.
      def remove(options = {})
        perform_request({ api_function: 'remove_zone_record' }.merge(options))
      end

      # Public: Retrieve a list of domains, created within cPanel, associated
      # with your cPanel account.
      #
      # options - Hash options for API call params (default: {})
      #   :domain - String domain parameter which allows you to append one
      #             domain name to the end of the resulting output
      #             (default: '')
      #
      # Returns Hash API response.
      def show_domains(options = {})
        perform_request({ api_function: 'fetch_cpanel_generated_domains' })
      end

      # Public: Retrieve a list of zone modifications for a specific domain.
      #
      # options - Hash options for API call params (default: {})
      #   :domain - String domain whose zone modifications you wish to view
      #
      # Returns Hash API response.
      def modifications_for(options = {})
        perform_request({ api_function: 'fetchzone_records' }.merge(options))
      end
    end
  end
end

