module Lumberg
  module Cpanel
    class Branding < Base
      def self.api_module; "Branding"; end

      # List branding packages
      #
      # ==== Optional
      #  * <tt>:onlyshowyours</tt> - PENDING
      #  * <tt>:showroot</tt> - PENDING
      #  * <tt>:skipglobal</tt> - PENDING
      #  * <tt>:skiphidden</tt> - PENDING
      def list_pkgs(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "showpkgs"
        }.merge(options))
      end

      # Retrieve URL locations for specific sprites
      #
      # ==== Required
      #  * <tt>:img</tt> - PENDING
      #  * <tt>:imgtype</tt> - PENDING
      #  * <tt>:method</tt> - PENDING
      #  * <tt>:subtype</tt> - PENDING
      #
      # ==== Optional
      #  * <tt>:image</tt> - PENDING
      #  * <tt>:skipgroups</tt> - PENDING
      def list_sprites(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "spritelist"
        }.merge(options))
      end

      # Retrieve a list of icons within the x3 interface
      #
      # ==== Optional
      #  * <tt>:nvarglist</tt> - PENDING
      def list_icons(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "applist"
        }.merge(options))
      end

      # List branding object types
      def list_object_types(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listobjecttypes"
        }.merge(options))
      end

      # List branding image types
      def list_image_types(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listimgtypes"
        }.merge(options))
      end
    end
  end
end
