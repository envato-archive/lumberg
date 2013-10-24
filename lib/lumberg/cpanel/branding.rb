module Lumberg
  module Cpanel
    class Branding < Base
      # Public: Get list of branding packages.
      #
      # options - Hash options for API call params (default: {}):
      #  :onlyshowyours - Return only packages that the user owns?
      #                   String "1" or "0" (optional).
      #  :showroot      - Only return system branding packages?
      #                   String "1" or "0" (optional).
      #  :skipglobal    - Only return customized branding packages?
      #                   String "1" or "0" (optional).
      #  :skiphidden    - Skip branding packages owned by the user?
      #                   String "1" or "0" (optional).
      #
      # Returns Hash API response.
      def list_pkgs(options = {})
        perform_request({
          api_function: "showpkgs"
        }.merge(options))
      end

      # Public: Get URL locations for specific sprites.
      #
      # options - Hash options for API call params (default: {}):
      #  :img        - String branding object label for the image you want to
      #                retrieve.
      #  :imgtype    - String branding image type you want to retrieve, e.g.,
      #                "icon" or "heading".
      #  :method     - String specification for returned value options.
      #                Acceptable values are: "only_filetype_gif",
      #                "skip_filetype_gif", "snap_to_smallest_width", and
      #                "scale_60percent".
      #  :subtype    - String branding image subtype, e.g., "img", "bg",
      #                "compleximg".
      #  :image      - String parameter allows you to force appropriate
      #                output by setting it to "heading" (optional).
      #  :skipgroups - String parameter allows you to specify whether or not
      #                to include "img" values that begin with "group_" in
      #                the output. "1" indicates that you wish to skip "img"
      #                values that begin with "group_" (optional).
      #
      # Returns Hash API response.
      def list_sprites(options = {})
        perform_request({
          api_function: "spritelist"
        }.merge(options))
      end

      # Public: Retrieve a list of icons within the x3 interface.
      #
      # options - Hash options for API call params (default: {}):
      #  :nvarglist - String parameter allows you to specify the order in
      #               which you wish to have groups returned, separated by
      #               pipes, e.g., "mail|files|domains|logs". This is the
      #               last filter on the data and is stored in your
      #               xmaingroupsorder NVDATA variable (optional).
      #
      # Returns Hash API response.
      def list_icons(options = {})
        perform_request({
          api_function: "applist"
        }.merge(options))
      end

      # Public: Get list of branding object types.
      #
      # options - Hash options for API call params (default: {}):
      #
      # Returns Hash API response.
      def list_object_types(options = {})
        perform_request({
          api_function: "listobjecttypes"
        }.merge(options))
      end

      # Public: Get list of branding image types.
      #
      # options - Hash options for API call params (default: {}):
      #
      # Returns Hash API response.
      def list_image_types(options = {})
        perform_request({
          api_function: "listimgtypes"
        }.merge(options))
      end
    end
  end
end
