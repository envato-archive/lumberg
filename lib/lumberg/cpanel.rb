module Lumberg
  module Cpanel
    autoload :Base,        'lumberg/cpanel/base'
    autoload :AddonDomain, 'lumberg/cpanel/addon_domain'
    autoload :SubDomain,   'lumberg/cpanel/sub_domain'
    autoload :Park,        'lumberg/cpanel/park'

    class Args < Whm::Args; end
  end
end
