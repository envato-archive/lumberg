# - When instantiating an object in the cPanel namespace,
#   accept a :whm_host/:whm_hash hash to create a new @server
#   object or accept a server object directly
# - Cache the @server as a class variable of Lumberg::Cpanel::Base
#   so that it is accessible to all Cpanel namespace classes
#   that inhereit from it
# - If a Cpanel namespace object is instantiated again with
#   :whm_host/:whm_hash or a server arg, then the new information
#   will be cached and used -- this would change the connections
#   for all existing objects(?)

require 'spec_helper'
require 'lumberg/whm'
require 'lumberg/cpanel'

module Lumberg
  describe Cpanel do
  end
end
