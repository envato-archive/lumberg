require 'spec_helper'

# Requests will need an "Authorization" header with
# WHM username:hash"
module Lumberg
  describe Whm::Server do
    before(:each) do
      @login    = { :host => @whm_host, :hash => @whm_hash }
      @whm      = Whm::Server.new(@login.dup)
      @url_base = "https://myhost.com:2087/json-api"
    end

    context "Setting up the server host, username, url, and hash" do
      it "should setup host and hash" do
        @whm.hash.should == @login[:hash]
        @whm.host.should == @login[:host]
      end

      it "should set the url" do
        @whm.base_url.should == "https://#{@login[:host]}:2087/json-api/"
      end

      it "should default to 'root' as the username" do
        @whm.user.should == 'root'
      end

      it "should allow setting of the username" do
        @whm = Whm::Server.new(@login.merge(:user => 'bob'))
        @whm.user.should == 'bob'
      end

      it "should default to false for basic_auth" do
        @whm.basic_auth.should be_false
      end

      it "should allow setting of basic_auth" do
        @whm = Whm::Server.new(@login.merge(:basic_auth => true))
        @whm.basic_auth.should be_true
      end
    end

    describe "#format_url" do
      it "converts the host into an SSL URL by default" do
        @whm.send(:format_url).should == "https://myhost.com:2087/json-api/"
      end

      it "converts the host into an SSL URL when asked" do
        @whm = Whm::Server.new(@login.dup.merge(:ssl => true))
        @whm.send(:format_url).should == "https://myhost.com:2087/json-api/"
      end

      it "converts the host into a non SSL URL when asked" do
        @whm = Whm::Server.new(@login.dup.merge(:ssl => false))
        @whm.send(:format_url).should == "http://myhost.com:2086/json-api/"
      end
    end

    describe "#format_hash" do
      it "raises an error if hash is not a string" do
        expect{  Whm::Server.new(:host => @whm_host, :hash => 1) }.
          to raise_error(Lumberg::WhmArgumentError, "Missing WHM hash")
      end

      it "removes \\n's from the hash" do
        hash =  "my\nhash\n\n\n\n"
        @whm = Whm::Server.new(:host => @whm_host, :hash => hash)
        @whm.hash.should == 'myhash'
      end

      it "removes whitespace from the hash" do
        hash = "    my hash "
        @whm = Whm::Server.new(:host => @whm_host, :hash => hash)
        @whm.hash.should == 'myhash'
      end
    end

    describe "#perform_request" do
      # These tests are skipped when running against
      # a real WHM server
      unless live_test?
        describe "my_function" do
          use_vcr_cassette "whm/server/my_function"

          it "calls the proper URL" do
            JSON.should_receive(:parse).with("[]").and_return([])
            @whm.perform_request('my_function')
            @whm.function.should == 'my_function'
            @whm.params.should be_empty
          end

          it "calls the proper URL and arguments" do
            JSON.should_receive(:parse).with("[]").and_return([])
            @whm.perform_request('my_function', :arg1 => 1, :arg2 => 'test')
            @whm.function.should == 'my_function'
            @whm.params.should == {:arg1 => 1, :arg2 => 'test'}
          end

          it "changes params to booleans when given a block" do
            req = @whm.perform_request('my_function', :block => 1) do |p|
              p.boolean_params =  :true, :false
            end
            req[:params].should include(:true => true, :false => false, :other => 2)
          end

        end
      end

      describe "@ssl_verify" do
        it "does not verify SSL certs for HTTP requests by default" do
          @whm.ssl_verify.should be(false)
        end

        it "verifies SSL certs for HTTP requests when asked" do
          @whm.ssl_verify = true
          @whm.ssl_verify.should be(true)
        end

        it "does not verify SSL certs for HTTP requests when asked" do
          @whm.ssl_verify = false
          @whm.ssl_verify.should be(false)
        end
      end

      context "calling applist" do
        use_vcr_cassette "whm/server/applist"

        it "sets a response message" do
          @whm = Whm::Server.new(:host => @whm_host, :hash => @whm_hash)
          @whm.perform_request('applist')
          @whm.function.should == 'applist'
        end
      end
    end

    describe "#gethostname" do
      use_vcr_cassette "whm/server/gethostname"

      it "returns the hostname" do
        result = @whm.get_hostname
        result[:success].should be_true
        result[:params][:hostname].should == "myhost.com"
      end
    end

    describe "#version" do
      use_vcr_cassette "whm/server/version"

      it "returns the version of cPanel and WHM" do
        result = @whm.version
        result[:success].should be_true
        result[:params][:version].should == "11.28.64"
      end
    end

    describe "#loadavg" do
      use_vcr_cassette "whm/server/loadavg"

      it "returns the server's load average" do
        result = @whm.load_average
        result[:success].should be_true
        result[:params].should include(:one, :five, :fifteen)
      end
    end

    describe "#systemloadavg" do
      use_vcr_cassette "whm/server/systemloadavg"

      it "returns the server's load average with metadata" do
        result = @whm.system_load_average("api.version".to_sym => 1)
        result[:params][:one].should == "0.00"
        result[:params][:five].should == "0.04"
        result[:params][:fifteen].should == "0.01"
      end
    end

    describe "#getlanglist" do
      use_vcr_cassette "whm/server/getlanglist"

      it "returns the list of languages" do
        result = @whm.languages
        result[:params].size.to_i.should == 19
        result[:params].should include "english"
      end
    end

    describe "#account" do
      it "has an account accessor" do
        @whm.account.should be_an(Whm::Account)
      end

      it "returns the same thing twice" do
        @whm.account.should be_a(Whm::Account)
        @whm.account.should respond_to(:list)

        @whm.account.should be_a(Whm::Account)
        @whm.account.should respond_to(:list)
      end

    end

    describe "#dns" do
      it "has an dns accessor" do
        @whm.dns.should be_an(Whm::Dns)
      end
    end

    describe "#reseller" do
      it "has an reseller accessor" do
        @whm.reseller.should be_an(Whm::Reseller)
      end
    end

    describe "#method_missing" do
      it "caches @vars" do
        Whm.should_receive(:const_get).once.and_return(Whm::Account)
        @whm.account
        @whm.account
      end

      it "raises to super" do
        expect { @whm.asdf }.to raise_error(NoMethodError)
      end
    end

    describe "#list_ips" do
      use_vcr_cassette "whm/server/listips"

      it "lists all the ip addresses" do
        result = @whm.list_ips
        result[:params][0][:ip].should == "123.123.123.123"
        result[:params][0][:used].should == 1
        result[:params].should have(242).ips
      end
    end

    describe "#add_ip" do
      use_vcr_cassette "whm/server/addip"

      it "requires an ip address" do
        requires_attr('ip') { @whm.add_ip(:netmask => '255.255.255.250') }
      end

      it "requires a netmask" do
        requires_attr('netmask') { @whm.add_ip(:ip => '123.123.123.123') }
      end

      it "adds the ip address" do
        result = @whm.add_ip(:ip => '208.77.188.166', :netmask => '255.255.255.0')
        result[:success].should be_true
      end
    end

    describe "#delete_ip" do
      use_vcr_cassette "whm/server/delip"

      it "requires an ip address" do
        requires_attr('ip') { @whm.delete_ip }
      end

      it "deletes the ip address" do
        result = @whm.delete_ip(:ip => '208.77.188.166')
        result[:success].should be_true
      end
    end

    describe "#set_hostname" do
      use_vcr_cassette "whm/server/sethostname"

      it "requires a hostname" do
        requires_attr('hostname') { @whm.set_hostname }
      end

      it "changes the server's hostname" do
        result = @whm.set_hostname(:hostname => "myhost.com")
        result[:success].should be_true
      end
    end

    describe "#set_resolvers" do
      use_vcr_cassette "whm/server/setresolvers"

      it "requires a nameserver1" do
        requires_attr('nameserver1') { @whm.set_resolvers }
      end

      it "configures the nameservers" do
        result = @whm.set_resolvers(:nameserver1 => "123.123.123.123", :nameserver2 => "123.123.123.124")
        result[:success].should be_true
      end
    end

    describe "#show_bandwidth" do
      use_vcr_cassette "whm/server/showbw"

      it "shows the bandwidth information" do
        result = @whm.show_bandwidth(:year => 2011, :month => 5)
        result[:params][:month].to_i.should == 5
        result[:params][:acct].should have(3).accounts
      end
    end
  end
end
