$:.unshift(File.dirname(__FILE__))

# External Libs
require 'json'
require 'uri'
require 'net/http'
require 'net/https'

# Internal Libs
require 'lumberg/version'
require 'lumberg/exceptions'
require 'lumberg/whm/args'
require 'lumberg/whm'

module Lumberg
  class << self
    def base_path
      File.dirname(__FILE__)
    end
  end
end
