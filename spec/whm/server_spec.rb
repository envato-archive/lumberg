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

    # These tests are skipped when running against
    # a real WHM server
    unless live_test?
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
    end
  end
end
