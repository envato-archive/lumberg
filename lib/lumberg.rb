$:.unshift(File.dirname(__FILE__))

# External Libs
require 'openssl'
require 'json'
require 'uri'
require 'faraday'
require 'faraday_middleware'
require 'logger'
require 'resolv'

# Internal Libs
require 'lumberg/format_whm'
require 'lumberg/version'
require 'lumberg/exceptions'
require 'lumberg/config'
require 'lumberg/whm'
require 'lumberg/cpanel'

module Lumberg

  extend self

  attr_accessor :configuration

  def base_path
    File.dirname(__FILE__)
  end

  self.configuration ||= Lumberg::Config.new

   # Specificy the config via block
   #
   # ==== Attributes
   #
   # * +debug+ - Set to true to log debug info to $stderr, or a file path
   #
   # ==== Example
   #
   #   Lumberg.config do |c|
   #     c.dubug "path/to/file.log"
   #   end
   def config
     yield self.configuration if block_given?
     self.configuration.options
   end

end

