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
        expect{  Whm::Server.new(:host => @whm_host, :hash => nil) }.to 
          raise_error(Lumberg::WhmArgumentError, "Missing WHM hash")
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
            @whm.raw_response.should be_a(Net::HTTPOK)
          end

          it "calls the proper URL and arguments" do
            JSON.should_receive(:parse).with("[]").and_return([])
            @whm.perform_request('my_function', :arg1 => 1, :arg2 => 'test')
            @whm.function.should == 'my_function'
            @whm.params.should == "arg1=1&arg2=test"
            @whm.raw_response.should be_a(Net::HTTPOK)
          end

          it "changes params to booleans when given a block" do
            req = @whm.perform_request('my_function', :block => 1) do |p|
              p.boolean_params =  :true, :false
            end

            @whm.boolean_params.should include(:true, :false)
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

    describe "#response_type" do

      use_vcr_cassette "whm/server/response_type"

      it "detects an action function" do
        @whm.perform_request('testing')
        @whm.send(:response_type).should == :action
      end

      it "detects an error function" do
        @whm.perform_request('testing_error')
        @whm.send(:response_type).should == :error
      end

      it "detects a query function" do
        @whm.perform_request('testing_query')
        @whm.send(:response_type).should == :query
      end

      it "detects an unknown function" do
        @whm.perform_request('testing_unknown')
        @whm.send(:response_type).should == :unknown
      end

      it "forces response type" do
        @whm.force_response_type = :magic
        @whm.send(:response_type).should == :magic
        @whm.perform_request('testing')
      end

      it "resets response_type each request" do
        @whm.force_response_type.should be_nil
        @whm.force_response_type = :magic
        @whm.send(:response_type).should == :magic

        @whm.force_response_type = :magic
        @whm.perform_request('testing')
        @whm.force_response_type.should be_nil
      end


      it "returns true for a successful :action" do
        @whm.perform_request('testing')
        response = @whm.send(:format_response)
        response[:success].should be(true)
      end

      it "returns true for a successful :query" do
        @whm.perform_request('testing_query')
        response = @whm.send(:format_response)
        response[:success].should be(true)
        response[:params].should have_key(:acct)
      end

      it "returns false on :error" do
        @whm.perform_request('testing_error')
        response = @whm.send(:format_response)
        response[:success].should be(false)
        response[:message].should match(/Unknown App Req/)
      end

      it "returns false on :unknown" do
        @whm.perform_request('testing_unknown')
        response = @whm.send(:format_response)
        response[:success].should be(false)
        response[:message].should match(/Unknown error occurred .*wtf.*/)
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
  end
end
