require 'spec_helper'
require 'lumberg/whm'
require 'lumberg/cpanel'

module Lumberg
  describe Cpanel::AddonDomain do
    before(:each) do
      @login    = { :host => @whm_host, :hash => @whm_hash }
      @server   = Whm::Server.new(@login.dup)
      @addond   = Cpanel::AddonDomain.new(:server => @server.dup)
    end

    describe "#deladdondomain" do
      it "requires domain" do
        requires_attr("domain") { @addond.deladdondomain }
      end

      it "requires subdomain" do
        requires_attr("subdomain") {
          @addond.deladdondomain(:domain => "example.com")
        }
      end
    end

    describe "#addaddondomain" do
      it "requires dir" do
        requires_attr("dir") { @addond.addaddondomain }
      end

      it "requires newdomain" do
        requires_attr("newdomain") {
          @addond.addaddondomain(:dir => "/some/path")
        }
      end

      it "requires subdomain" do
        requires_attr("subdomain") {
          @addond.addaddondomain(:dir => "/some/path", :newdomain => "new.com")
        }
      end
    end

    describe "#listaddondomains" do
    end
  end
end
