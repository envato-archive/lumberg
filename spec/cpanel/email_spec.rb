require "spec_helper"

module Lumberg
  describe Cpanel::Email do
    let(:domain) { "lumberg-test.com" }
    let(:server) { Whm::Server.new(host: @whm_host, hash: @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:email) do
      described_class.new(
        server:       server,
        api_username: api_username
      )
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
          list:     "add-test",
          domain:   domain,
          password: "s3cr3t5"
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
          list:     "test-list",
          domain:   domain,
          password: "s3cr3t5"
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

      it "adds a forwarder" do
        email.add_forwarder(
          domain:   domain,
          email:    local,
          fwdopt:   :fwd,
          fwdemail: "foo@bar.com"
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
          domain:   domain,
          email:    local,
          fwdopt:   :fwd,
          fwdemail: "foo@bar.com"
        )
      end

      it "returns a list of forwarders" do
        email.forwarders[:params][:data].find {|f|
          f[:dest] == "#{local}@#{domain}"
        }.should_not be_nil
      end
    end

    describe "#domains_with_aliases" do
      let(:local) { "alias-test" }

      use_vcr_cassette("cpanel/email/domains_with_aliases")

      before do
        email.add_forwarder(
          domain:   domain,
          email:    local,
          fwdopt:   :fwd,
          fwdemail: "foo@bar.com"
        )
      end

      it "gets a list of domains that have aliases" do
        email.domains_with_aliases[:params][:data][0][:domain].should == domain
      end
    end

    describe "#add_account" do
      let(:local) { "account-test" }

      use_vcr_cassette "cpanel/email/add_account"

      it "adds an email account" do
        email.add_account(
          domain:   domain,
          email:    local,
          password: "magicpants",
          quota:    0
        )

        email.accounts[:params][:data].find {|a|
          a[:email] == "#{local}@#{domain}"
        }.should_not be_nil
      end
    end

    describe "#edit_quota" do
      let(:local) { "account-test" }

      use_vcr_cassette "cpanel/email/edit_quota"

      it "modifies an email account quota" do
        old_quota = email.accounts[:params][:data].find { |a|
          a[:email] == "#{local}@#{domain}"
        }[:_diskquota]

        email.edit_quota(
          domain: domain,
          email:  local,
          quota:  10
        )

        new_quota = email.accounts[:params][:data].find {|a|
          a[:email] == "#{local}@#{domain}"
        }[:_diskquota].to_i

        new_quota.should_not == old_quota
      end
    end

    describe "#remove" do
      let(:local) { "account-test" }

      use_vcr_cassette "cpanel/email/remove"

      it "removes an email account" do
        email.remove(
          domain: domain,
          email:  "#{local}@#{domain}"
        )

        email.accounts[:params][:data].find {|a|
          a[:email] == "#{local}@#{domain}"
        }.should be_nil
      end
    end


    describe "#accounts" do
      let(:local)         { "test-account" }
      let(:email_address) { "#{local}@#{domain}" }

      use_vcr_cassette("cpanel/email/accounts")

      before(:each) do
        email.add_account(
          domain:   domain,
          email:    local,
          password: "sauce",
          quota:    0
        )
      end

      context ":style option is :with_disk" do
        it "uses Email::listpopswithdisk" do
          email.should_receive(:perform_request).with(
            hash_including(api_function: "listpopswithdisk")
          )

          email.accounts(style: :with_disk)
        end

        it "is the default seting" do
          email.should_receive(:perform_request).with(
            hash_including(api_function: "listpopswithdisk")
          )

          email.accounts
        end

        it "returns a list of email accounts" do
          data = email.accounts(style: :with_disk)[:params][:data]
          data.any? {|d| d[:email] == email_address }.should be_true
        end
      end

      context ":style option is :without_disk" do
        it "uses Email::listpops" do
          email.should_receive(:perform_request).with(
            hash_including(api_function: "listpops")
          )

          email.accounts(style: :without_disk)
        end

        it "returns a list of email accounts" do
          data = email.accounts(style: :without_disk)[:params][:data]
          data.any? {|d| d[:email] == email_address }.should be_true
        end
      end

      context ":style option is :with_image" do
        it "uses Email::listpopswithimage" do
          email.should_receive(:perform_request).with(
            hash_including(api_function: "listpopswithimage")
          )

          email.accounts(style: :with_image)
        end

        it "returns a list of email accounts" do
          data = email.accounts(style: :with_image)[:params][:data]
          data.any? {|d| d[:email] == email_address }.should be_true
        end
      end

      context ":style option is :single" do
        it "uses Email::listpopssingle" do
          email.should_receive(:perform_request).with(
            hash_including(api_function: "listpopssingle")
          )

          email.accounts(style: :single)
        end

        it "returns a list of email accounts" do
          data = email.accounts(style: :single)[:params][:data]
          data.any? {|d| d[:email] == email_address }.should be_true
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

    describe "#add_mx" do
      use_vcr_cassette("cpanel/email/add_mx")

      it "adds an mx record" do
        email.add_mx(
          domain:     domain,
          exchange:   "mail.#{domain}",
          preference: 2
        )[:params][:data][0][:status].should eq(1)
      end
    end

    describe "#change_mx" do
      use_vcr_cassette("cpanel/email/change_mx")

      it "changes an existing mx record" do
        email.add_mx(
          domain:        domain,
          exchange:      "mail.#{domain}",
          oldpreference: 2,
          preference:    1
        )[:params][:data][0][:status].should eq(1)
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

    describe "#delete_mx" do
      use_vcr_cassette("cpanel/email/delete_mx")

      it "delete an existing mx record" do
        email.delete_mx(
          domain:     domain,
          exchange:   "mail.#{domain}",
          preference: 1
        )[:params][:data][0][:status].should eq(1)
      end
    end

    describe "#set_mx_type" do
      use_vcr_cassette("cpanel/email/set_mx_type")

      it "sets an existing mx record to use remote" do
        email.set_mx_type(
          domain:  domain,
          mxcheck: "remote"
        )[:params][:data][0][:detected].should  == "remote"
      end
    end

    describe "#set_mail_delivery" do
      let(:detected) do
        email.mx(domain: domain)[:params][:data][0][:detected]
      end

      use_vcr_cassette("cpanel/email/set_mail_delivery")

      context "remote delivery" do
        use_vcr_cassette("cpanel/email/set_mail_delivery.remote")

        it "sets remote mail delivery" do
          email.set_mail_delivery(
            domain:   domain,
            delivery: :remote
          )

          detected.should == "remote"
        end
      end

      context "local delivery" do
        use_vcr_cassette("cpanel/email/set_mail_delivery.local")

        it "sets local mail delivery" do
          email.set_mail_delivery(
            domain:   domain,
            delivery: :local
          )

          detected.should == "local"
        end
      end
    end

    describe "#check_local_delivery" do
      context "local delivery" do
        use_vcr_cassette("cpanel/email/check_local_delivery.local")

        before do
          email.set_mail_delivery(
            domain:   domain,
            delivery: :local
          )
        end

        it "returns 1" do
          email.check_local_delivery(
            domain: domain
          )[:params][:data][0][:alwaysaccept].should == 1
        end
      end

      context "remote delivery" do
        use_vcr_cassette("cpanel/email/check_local_delivery.remote")

        before do
          email.set_mail_delivery(
            domain:   domain,
            delivery: :remote
          )
        end

        it "returns 0" do
          email.check_local_delivery(
            domain: domain
          )[:params][:data][0][:alwaysaccept].should == 0
        end
      end
    end

    describe "#add_filter" do
      let(:local)       { "filters-test" }
      let(:filter_name) { "fail filter" }

      use_vcr_cassette("cpanel/email/add_filter")

      before do
        email.add_account(
          email:    local,
          domain:   domain,
          password: "abcdefg",
          quota:    0
        )
      end

      it "adds an email filter" do
        result = email.add_filter(
          account:    "#{local}@#{domain}",
          filtername: filter_name,
          action1:    "fail",
          match1:     "is",
          opt1:       "and",
          part1:      "$header_from:",
          val1:       "hi"
        )[:params][:data][0]

        result[:error].should == 0
        result[:account].should == "#{local}@#{domain}"
        result[:ok].should == 1
      end
    end

    describe "#filters" do
      let(:local)       { "filters-test" }
      let(:filter_name) { "fail filter" }

      use_vcr_cassette("cpanel/email/filters")

      before do
        email.add_account(
          email:    local,
          domain:   domain,
          password: "abcdefg",
          quota:    0
        )

        email.add_filter(
          account:    "#{local}@#{domain}",
          filtername: filter_name,
          action1:    "fail",
          match1:     "is",
          opt1:       "and",
          part1:      "$header_from:",
          val1:       "hi"
        )
      end

      it "returns a list of email filters" do
        email.filters(
          account: "#{local}@#{domain}"
        )[:params][:data][0][:filtername].should == filter_name
      end

      context ":old_style option truthy" do
        it "uses deprecated Email::listfilters" do
          email.should_receive(:perform_request).with(
            hash_including(api_function: "listfilters")
          )

          email.filters(
            account:   "#{local}@#{domain}",
            old_style: true
          )
        end
      end

      context ":old_style option falsy" do
        it "uses Email::filterlist" do
          email.should_receive(:perform_request).with(
            hash_including(api_function: "filterlist")
          )

          email.filters(
            account:   "#{local}@#{domain}",
            old_style: false
          )
        end

        it "is the default setting" do
          email.should_receive(:perform_request).with(
            hash_including(api_function: "filterlist")
          )

          email.filters
        end
      end
    end

    describe "#acceptable_encodings" do
      use_vcr_cassette "cpanel/email/acceptable_encodings"

      subject do
        email.acceptable_encodings[:params][:data].find { |m| m[:map] == "utf-8" }[:map]
      end

      it "lists Cpanel's acceptable character encodings" do
        should == "utf-8"
      end
    end

    describe "#listautoresponders" do
      use_vcr_cassette("cpanel/email/listautoresponders")
      subject { email.listautoresponders[:params][:data][0] }
      should { be_nil }
    end

    describe "#listdomainforwards" do
      use_vcr_cassette("cpanel/email/listdomainforwards")
      subject { email.listdomainforwards[:params][:data][0] }
      should { be_nil }
    end

    describe "#disk_usage" do
      let(:local) { "disk-usage-test" }

      use_vcr_cassette("cpanel/email/disk_usage")

      before do
        email.add_account(
          domain:   domain,
          email:    local,
          password: "s00pers3cr3t",
          quota:    0
        )
      end

      it "gets disk usage information for an email account" do
        email.disk_usage(
          domain: domain,
          login:  local
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
          domain:   domain,
          email:    local,
          password: "s00pers3cr3t",
          quota:    0
        )
      end

      it "gets disk usage information for an email account" do
        email.mail_dir(
          account: "#{local}@#{domain}"
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
          domain:   domain,
          email:    local,
          password: "s00pers3cr3t",
          quota:    0
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
          domain: domain
        )[:params][:data][0][:domain].should == domain
      end
    end

    describe "#set_default_address" do
      use_vcr_cassette("cpanel/email/set_default_address")

      it "sets the default forwarding address for a domain" do
        email.set_default_address(
          domain:   'hello.com',
          fwdopt:   :fwd,
          fwdemail: "foo@bar.com"
        )[:params][:data].first.should == 'success'
      end
    end

    describe "#listfilterbackups" do
      pending
    end

    describe "#filterlist" do
      pending
    end

    describe "#tracefilter" do
      pending
    end

    describe "#fetchautoresponder" do
      pending
    end
  end
end
