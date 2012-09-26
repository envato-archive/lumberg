require 'spec_helper'
require 'lumberg/whm'
require 'lumberg/cpanel'

module Lumberg
  describe Cpanel::Email do
    let(:domain) { "lumberg-test.com" }

    before(:each) do
      @login  = { :host => @whm_host, :hash => @whm_hash }
      @server = Whm::Server.new(@login.dup)

      @api_username = "lumberg"
      @email = Cpanel::Email.new(
        :server       => @server.dup,
        :api_username => @api_username
      )
    end

    describe "::api_module" do
      subject { @email.class::api_module }
      it { should == "Email" }
    end

    describe "#mailing_lists" do
      use_vcr_cassette "cpanel/email/mailing_lists"

      subject { @email.mailing_lists[:params][:data] }
      it { should be_an(Array) }

      it "returns an array with info for each mailing list" do
        subject.each {|info|
          info.keys.should include(
            :humandiskused, :list, :desthost, :diskused, :listid
          )
        }
      end
    end

    describe "#forwarders" do
      use_vcr_cassette "cpanel/email/forwarders"

      subject { @email.forwarders[:params][:data] }
      it { should be_an(Array) }

      it "returns an array with info for each forwarder" do
        subject.each {|info|
          info.keys.should include(
            :uri_dest, :forward, :html_dest, :uri_forward, :dest, :html_forward
          )
        }
      end
    end

    describe "#accounts" do
      use_vcr_cassette "cpanel/email/accounts"

      subject { @email.accounts[:params][:data] }
      it { should be_an(Array) }

      it "returns an array with info for each email account" do
        subject.each {|info|
          info.keys.should include(
            :txtdiskquota, :diskquota, :diskusedpercent, :diskused,
            :humandiskquota, :_diskused, :login, :email, :domain, :user,
            :humandiskused, :diskusedpercent20, :_diskquota
          )
        }
      end
    end

    describe "#accounts_" do
      use_vcr_cassette "cpanel/email/accounts_"

      subject { @email.accounts_[:params][:data] }
      it { should be_an(Array) }

      it "returns an array with info for each email account" do
        subject.each {|info| info.keys.should include(:login, :email) }
      end
    end

    describe "#accounts_with_image" do
      use_vcr_cassette "cpanel/email/accounts_with_image"

      subject { @email.accounts_with_image[:params][:data] }
      it { should be_an(Array) }

      it "returns an array with info for each email account" do
        subject.each {|info| info.keys.should include(:login, :email) }
      end
    end

    describe "#accounts_single" do
      use_vcr_cassette "cpanel/email/accounts_single"

      subject { @email.accounts_single[:params][:data] }
      it { should be_an(Array) }

      it "returns an array with info for each email account" do
        subject.each {|info| info.keys.should include(:login, :email) }
      end
    end

    describe "#domains" do
      use_vcr_cassette "cpanel/email/domains"

      subject { @email.domains[:params][:data] }
      it { should be_an(Array) }

      it "returns an array with info for each domain" do
        subject.each {|info| info.keys.should include(:domain) }
      end
    end

    describe "#mx" do
      use_vcr_cassette "cpanel/email/mx"

      subject { @email.mx(:domain => domain)[:params][:data] }
      it { should be_an(Array) }

      it "returns an array with info for each mail exchanger" do
        #puts YAML.dump(subject)
        subject.each {|info|
          info.keys.should include(
            :mxcheck, :entries, :statusmsg, :detected, :secondary, :remote,
            :status, :alwaysaccept, :mx, :domain, :local
          )

          info[:entries].each {|entry|
            entry.keys.should include(
              :priority, :mx, :domain, :entrycount, :row
            )
          }
        }
      end
    end

    describe "#set_mail_delivery" do
      use_vcr_cassette "cpanel/email/set_mail_delivery"

      it "should raise an error if given an invalid delivery option" do
        expect {
          @email.set_mail_delivery(
            :domain   => domain,
            :delivery => :invalid
          )
        }.to raise_error("Invalid :delivery option")
      end

      context "remote delivery" do
        subject {
          @email.set_mail_delivery(
            :domain   => domain,
            :delivery => "remote"
          )[:params][:data].first
        }

        it { should be_a(Hash) }
        its([:mxcheck])   { should == "remote" }
        its([:secondary]) { should == 0 }
        its([:remote])    { should == 1 }
        its([:local])     { should == 0 }

        it "returns info for the mail exchanger" do
          subject.keys.should include(
            :mxcheck, :statusmsg, :checkmx, :detected, :results,
            :secondary, :remote, :status, :local
          )
        end
      end

      context "local delivery" do
        subject {
          @email.set_mail_delivery(
            :domain   => domain,
            :delivery => "local"
          )[:params][:data].first
        }

        it { should be_a(Hash) }
        its([:mxcheck])   { should == "local" }
        its([:secondary]) { should == 0 }
        its([:remote])    { should == 0 }
        its([:local])     { should == 1 }

        it "returns info for the mail exchanger" do
          subject.keys.should include(
            :mxcheck, :statusmsg, :checkmx, :detected, :results,
            :secondary, :remote, :status, :local
          )
        end
      end
    end

  end
end
