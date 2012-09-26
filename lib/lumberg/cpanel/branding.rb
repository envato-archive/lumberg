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
          :api_function => "showpkgs",
          :api_username => options.delete(:api_username)
        }, {
          :onlyshowyours => options.delete(:onlyshowyours),
          :showroot      => options.delete(:showroot),
          :skipglobal    => options.delete(:skipglobal),
          :skiphidden    => options.delete(:skiphidden)
        })
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
          :api_function => "spritelist",
          :api_username => options.delete(:api_username)
        }, {
          :img        => options.delete(:img),
          :imgtype    => options.delete(:imgtype),
          :method     => options.delete(:method),
          :subtype    => options.delete(:subtype),
          :image      => options.delete(:image),
          :skipgroups => options.delete(:skipgroups),
        })
      end

      # Retrieve a list of icons within the x3 interface
      #
      # ==== Optional
      #  * <tt>:nvarglist</tt> - PENDING
      def list_icons(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "applist",
          :api_username => options.delete(:api_username)
        }, {
          :nvarglist => options.delete(:nvarglist)
        })
      end

      # List branding object types
      def list_object_types(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listobjecttypes",
          :api_username => options.delete(:api_username)
        })
      end

      # List branding image types
      def list_image_types(options = {})
        perform_request({
          :api_module   => self.class.api_module,
          :api_function => "listimgtypes",
          :api_username => options.delete(:api_username)
        })
      end
    end
  end
end
