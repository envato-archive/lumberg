require "spec_helper"

module Lumberg
  describe Cpanel::Email do
    let(:domain) { "lumberg-test.com" }
    let(:server) { Whm::Server.new(:host => @whm_host, :hash => @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:email) do
      described_class.new(
        :server       => server,
        :api_username => api_username
      )
    end

    describe "::api_module" do
      subject { email.class::api_module }

      it { should == "Email" }
    end

    describe "#main_discard" do
      use_vcr_cassette("cpanel/email/main_discard")

      it "gets info about main email account undeliverable mail handling" do
        email.main_discard[:params][:data][0].should have_key(:status)
      end
    end

    describe "#add_mailing_list" do
      use_vcr_cassette("cpanel/email/add_mailing_list")

      it "adds a mailing list" do
        email.add_mailing_list(
          :list     => "add-test",
          :domain   => domain,
          :password => "s3cr3t5"
        )

        email.mailing_lists[:params][:data].find {|l|
          l[:list] == "add-test@#{domain}"
        }.should_not be_nil
      end
    end

    describe "#mailing_lists" do
      use_vcr_cassette("cpanel/email/mailing_lists")

      before do
        email.add_mailing_list(
          :list     => "test-list",
          :domain   => domain,
          :password => "s3cr3t5"
        )
      end

      it "returns a list of mailing lists" do
        email.mailing_lists[:params][:data].find {|l|
          l[:list] == "test-list@#{domain}"
        }.should_not be_nil
      end
    end

    describe "#add_forwarder" do
      let(:local) { "fwd-test" }

      use_vcr_cassette("cpanel/email/add_forwarder")

      it "raises if fwdopt is invalid" do
        expect {
          email.add_forwarder(:fwdopt => :invalid)
        }.to raise_error
      end

      it "adds a forwarder" do
        email.add_forwarder(
          :domain   => domain,
          :email    => local,
          :fwdopt   => :fwd,
          :fwdemail => "foo@bar.com"
        )

        email.forwarders[:params][:data].find {|f|
          f[:dest] == "#{local}@#{domain}"
        }.should_not be_nil
      end
    end

    describe "#forwarders" do
      let(:local) { "test-fwd" }

      use_vcr_cassette("cpanel/email/forwarders")

      before do
        email.add_forwarder(
          :domain   => domain,
          :email    => local,
          :fwdopt   => :fwd,
          :fwdemail => "foo@bar.com"
        )
      end

      it "returns a list of forwarders" do
        email.forwarders[:params][:data].find {|f|
          f[:dest] == "#{local}@#{domain}"
        }.should_not be_nil
      end
    end

    describe "#add_account" do
      let(:local) { "account-test" }

      use_vcr_cassette("cpanel/email/add_account")

      it "adds an email account" do
        email.add_account(
          :domain   => domain,
          :email    => local,
          :password => "magicpants",
          :quota    => 0
        )

        email.accounts[:params][:data].find {|a|
          a[:email] == "#{local}@#{domain}"
        }.should_not be_nil
      end
    end

    describe "account list methods" do
      let(:local) { "test-account" }

      use_vcr_cassette("cpanel/email/accounts")

      before(:each) do
        email.add_account(
          :domain   => domain,
          :email    => local,
          :password => "sauce",
          :quota    => 0
        )
      end

      describe "#accounts" do
        it "returns a list of email accounts" do
          email.accounts[:params][:data].find {|a|
            a[:email] == "#{local}@#{domain}"
          }.should_not be_nil
        end
      end

      describe "#accounts_" do
        it "returns a list of email accounts" do
          email.accounts_[:params][:data].find {|a|
            a[:email] == "#{local}@#{domain}"
          }.should_not be_nil
        end
      end

      describe "#accounts_with_image" do
        it "returns a list of email accounts" do
          email.accounts_with_image[:params][:data].find {|a|
            a[:email] == "#{local}@#{domain}"
          }.should_not be_nil
        end
      end
    end

    describe "#domains" do
      use_vcr_cassette("cpanel/email/domains")

      it "returns a list of domains" do
        email.domains[:params][:data].find {|d|
          d[:domain] == domain
        }.should_not be_nil
      end
    end

    describe "#mx" do
      use_vcr_cassette("cpanel/email/mx")

      it "returns info for each mail exchanger" do
        email.mx[:params][:data][0][:entries].find {|m|
          m[:domain] == domain
        }.should_not be_nil
      end
    end

    describe "#set_mail_delivery" do
      let(:detected) do
        email.mx(:domain => domain)[:params][:data][0][:detected]
      end

      use_vcr_cassette("cpanel/email/set_mail_delivery")

      it "raises when given an invalid delivery option" do
        expect {
          email.set_mail_delivery(
            :domain   => domain,
            :delivery => :invalid
          )
        }.to raise_error
      end

      context "remote delivery" do
        use_vcr_cassette("cpanel/email/set_mail_delivery.remote")

        it "sets remote mail delivery" do
          email.set_mail_delivery(
            :domain   => domain,
            :delivery => :remote
          )

          detected.should == "remote"
        end
      end

      context "local delivery" do
        use_vcr_cassette("cpanel/email/set_mail_delivery.local")

        it "sets local mail delivery" do
          email.set_mail_delivery(
            :domain   => domain,
            :delivery => :local
          )

          detected.should == "local"
        end
      end
    end

    describe "#disk_usage" do
      let(:local) { "disk-usage-test" }

      use_vcr_cassette("cpanel/email/disk_usage")

      before do
        email.add_account(
          :domain   => domain,
          :email    => local,
          :password => "s00pers3cr3t",
          :quota    => 0
        )
      end

      it "gets disk usage information for an email account" do
        email.disk_usage(
          :domain => domain,
          :login  => local
        )[:params][:data].find {|d|
          d[:login] == local && d[:domain] == domain
        }.should_not be_nil
      end
    end

    describe "#mail_dir" do
      let(:local) { "mail-dir-test" }

      use_vcr_cassette("cpanel/email/mail_dir")

      before do
        email.add_account(
          :domain   => domain,
          :email    => local,
          :password => "s00pers3cr3t",
          :quota    => 0
        )
      end

      it "gets disk usage information for an email account" do
        email.mail_dir(
          :account => "#{local}@#{domain}"
        )[:params][:data][0][:absdir].should match(
          /\/mail\/#{domain}\/#{local}/
        )
      end
    end

    describe "#mail_dirs" do
      let(:local) { "mail-dirs-test" }

      use_vcr_cassette("cpanel/email/mail_dirs")

      before do
        email.add_account(
          :domain   => domain,
          :email    => local,
          :password => "s00pers3cr3t",
          :quota    => 0
        )
      end

      it "gets a list of mail-related directories" do
        email.mail_dirs[:params][:data].find {|m|
          m[:fullpath] =~ /\/mail\/#{domain}/
        }.should_not be_nil
      end
    end

    describe "#default_address" do
      use_vcr_cassette("cpanel/email/default_address")

      it "gets default address info for a domain" do
        email.default_address(
          :domain => domain
        )[:params][:data][0][:domain].should == domain
      end
    end
  end
end
