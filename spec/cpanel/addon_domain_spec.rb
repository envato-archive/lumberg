require "spec_helper"

module Lumberg
  describe Cpanel::AddonDomain do
    before(:each) do
      @login    = { host: @whm_host, hash: @whm_hash }
      @server   = Whm::Server.new(@login.dup)

      @api_username = "lumberg"
      @addond = Cpanel::AddonDomain.new(
        server:       @server.dup,
        api_username: @api_username
      )
    end

    describe "#remove" do
      use_vcr_cassette "cpanel/addon_domain/remove"

      it "removes an addon domain" do
        # Create the addon domain to be removed
        @addond.add(
          dir:       "public_html/test-addon.com/",
          newdomain: "test-addon.com",
          subdomain: "testadd"
        )

        result = @addond.remove(
          domain:    "test-addon.com",
          subdomain: "testadd_lumberg-test.com"
        )

        result[:params][:data][0][:result].should == 1
      end

    end

    describe "#add" do
      use_vcr_cassette "cpanel/addon_domain/add"

      it "adds an addon domain" do
        result = @addond.add(
          dir:       "public_html/test-magic.com/",
          newdomain: "test-magic.com",
          subdomain: "tmagic"
        )
        result[:params][:data][0][:result].should == 1

        # Remove the addon domain
        result = @addond.remove(
          domain:    "test-magic.com",
          subdomain: "tmagic_lumberg-test.com"
        )
      end
    end

    describe "#list" do
      use_vcr_cassette "cpanel/addon_domain/list"

      context "addon domains exist on the account" do
        let(:result) { @addond.list }
        subject { result[:params][:data] }

        it "returns an array with info for each addon domain" do
          subject.should be_an(Array)
          subject.each {|info|
            info.keys.should include(
              :domainkey, :status, :dir, :reldir, :subdomain, :rootdomain,
              :fullsubdomain, :domain, :basedir
            )
          }
        end
      end

      context "addon domains do not exist on the account" do
        before { @addond.api_username = "minimal" }
        after { @addond.api_username = "lumberg" }

        it "returns an empty array" do
          @addond.list[:params][:data].should be_empty
        end
      end
    end
  end
end
