$:.unshift(File.dirname(__FILE__))

require 'openssl'
require 'json'
require 'uri'
require 'faraday'
require 'faraday_middleware'
require 'logger'
require 'resolv'

require 'lumberg/format_whm'
require 'lumberg/version'
require 'lumberg/exceptions'
require 'lumberg/config'
require 'lumberg/whm'
require 'lumberg/cpanel'
require 'lumberg/whostmgr'

module Lumberg
  extend self

  attr_accessor :configuration

  # Gets the current path
  #
  # Returns the path (really)
  def base_path
    File.dirname(__FILE__)
  end

  self.configuration ||= Lumberg::Config.new

  # Sets the config via block
  #
  # debug - Set to true to log information to $stderr or a file path
  #
  # Examples
  #   Lumberg.config do |c|
  #     c.debug "path/to/file.log"
  #   end
  #
  # Returns config options
  def config
    yield self.configuration if block_given?
    self.configuration.options
  end
end

