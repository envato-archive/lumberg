module Lumberg
  module Cpanel
    autoload :Base,        'lumberg/cpanel/base'
    autoload :AddonDomain, 'lumberg/cpanel/addon_domain'

    class Args < Whm::Args; end
  end
end
