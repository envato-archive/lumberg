require 'spec_helper'
require 'lumberg/whm'
require 'lumberg/cpanel'

module Lumberg
  describe Cpanel::Base do
    before(:each) do
      @login  = { :host => @whm_host, :hash => @whm_hash }
      @server = Whm::Server.new(@login.dup)
      @base   = Cpanel::Base.new(:server => @server)
    end

    describe "#initialize" do
      context "a server instance or server hash is passed in" do
        it "allows a server instance to be passed in" do
          @base.server.should be_a(Whm::Server)
        end

        it "allows a server hash to be passed in" do
          base = Cpanel::Base.new(:server => @login)
          base.server.should be_a(Whm::Server)
        end

        it "caches the server instance" do
          Cpanel::Base.class_variable_get(:@@server).should eql(@base.server)
        end
      end

      context "nothing is passed in" do
        context "a server instance is cached" do
          it "loads the cached server instance" do
            base = Cpanel::Base.new
            base.server.should eql(
              Cpanel::Base.class_variable_get(:@@server)
            )
          end
        end

        context "server instance is not cached" do
          before { Cpanel::Base.class_variable_set(:@@server,nil) }

          it "raises an error" do
            expect {
              Cpanel::Base.new
            }.to raise_error(
              WhmArgumentError, /Missing required param/
            )
          end
        end
      end
    end
  end
end
