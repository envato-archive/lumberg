module Lumberg
  module Cpanel
    # Public: This module allows you to gather domain and document root maps
    # from authenticated accounts.
    class DomainLookup < Base
      # Public: Retrieve parked, addon and main domains for a Cpanel account
      #
      # Examples
      #   api_args = { host: "x.x.x.x", hash: "pass", api_username: "user" }
      #   domain_lookup = Lumberg::Cpanel::DomainLookup.new(api_args.dup)
      #
      #   domain_lookup.list
      #
      # Returns Hash API response.
      def list
        perform_request({ api_function: 'getbasedomains' })
      end

      # Public: Retrieve the absolute and relative paths to a specific domain's
      # document root.
      #
      # options   - Hash options for API call params (default: {})
      #   :domain - String domain corresponding to the document root you wish
      #             to know (default: 'your main domain')
      #
      # Examples
      #   api_args = { host: "x.x.x.x", hash: "pass", api_username: "user" }
      #   domain_lookup = Lumberg::Cpanel::DomainLookup.new(api_args.dup)
      #
      #   # gets DocumentRoot for primary domain
      #   domain_lookup.document_root
      #   # gets DocumentRoot for addon domain (or subdomain)
      #   domain_lookup.document_root(domain: 'addon.example.com')
      #
      # Returns Hash API response.
      def document_root(options = {})
        perform_request({ api_function: 'getdocroot' }.merge(options))
      end
      alias :docroot :document_root

      # Public: Retrieve the full paths to all of your document roots
      #
      # Examples
      #   api_args = { host: "x.x.x.x", hash: "pass", api_username: "user" }
      #   domain_lookup = Lumberg::Cpanel::DomainLookup.new(api_args.dup)
      #
      #   domain_lookup.document_roots
      #
      # Returns Hash API response.
      def document_roots
        perform_request({ api_function: 'getdocroots' })
      end
      alias :docroots :document_roots

      # Public: Retrieve the total number of base domains associated with your
      # cPanel account.
      #
      # Examples
      #   api_args = { host: "x.x.x.x", hash: "pass", api_username: "user" }
      #   domain_lookup = Lumberg::Cpanel::DomainLookup.new(api_args.dup)
      #
      #   domain_lookup.count_domains
      #
      # Returns Hash API response.
      def count
        perform_request({ api_function: 'countbasedomains' })
      end
    end
  end
end

