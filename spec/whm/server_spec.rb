require 'spec_helper'

# Requests will need an "Authorization" header with 
# WHM username:hash"
module Lumberg
  describe Whm::Server do
    before(:each) do
      @login    = { host: @whm_host, hash: @whm_hash }
      @whm      = Whm::Server.new(@login.dup)
      @url_base = "https://myhost.com:2087/json-api"
    end

    context "Setting up the server host, username, url, and hash" do
      it "should setup host and hash" do
        @whm.hash.should == @login[:hash]
        @whm.host.should == @login[:host]
      end

      it "should set the url" do
        @whm.url.should == "https://#{@login[:host]}:2087/json-api/"
      end

      it "should default to 'root' as the username" do
        @whm.user.should == 'root'
      end

      it "should allow setting of the username" do
        @whm = Whm::Server.new(@login.merge(user: 'bob'))
        @whm.user.should == 'bob'
      end
    end
   
    context "Performing an HTTP request" do
      describe "perform_request" do
        describe "calling my_function" do
          use_vcr_cassette "whm/server/my_function", :record => :new_episodes

          it "should verify SSL certs for HTTP requests"

          it "should call the proper URL" do
            JSON.should_receive(:parse).with("[]").and_return([])
            @whm.send(:perform_request, 'my_function')
            @whm.function.should == 'my_function'
            @whm.params.should be_empty
            @whm.raw_response.should be_a(Net::HTTPOK)
          end

          it "should call the proper URL and arguments" do
            JSON.should_receive(:parse).with("[]").and_return([])
            @whm.send(:perform_request, 'my_function', arg1: 1, arg2: 'test')
            @whm.function.should == 'my_function'
            @whm.params.should == "arg1=1&arg2=test"
            @whm.raw_response.should be_a(Net::HTTPOK)
          end
        end

        describe "calling applist" do
          use_vcr_cassette "whm/server/applist", :record => :new_episodes

          it "should set a response message" do
            @whm = Whm::Server.new(host: @whm_host, hash: @whm_hash)
            @whm.send(:perform_request, 'applist')
            @whm.function.should == 'applist'
          end
        end
      end
    end

    context "Parsing response" do
      describe "response_type" do

        use_vcr_cassette "whm/server/response_type", :record => :new_episodes

        it "should detect an action function" do
          @whm.send(:perform_request, 'testing')
          @whm.send(:response_type).should == :action
        end

        it "should detect an error function" do
          @whm.send(:perform_request, 'testing_error')
          @whm.send(:response_type).should == :error
        end

        it "should detect a query function" do
          @whm.send(:perform_request, 'testing_query')
          @whm.send(:response_type).should == :query
        end

        it "should detect an unknown function" do
          @whm.send(:perform_request, 'testing_unknown')
          @whm.send(:response_type).should == :unknown
        end
      end
    end

    describe "format_response should return true when successful" do

      use_vcr_cassette "whm/server/response_type", :record => :new_episodes

      it "should return true for a successful :action" do
        @whm.send(:perform_request, 'testing')
        response = @whm.send(:format_response)
        response[:success].should be(true)
      end

      it "should return true for a successful :query" do
        @whm.send(:perform_request, 'testing_query')
        response = @whm.send(:format_response)
        response[:success].should be(true)
        response[:params].should have_key('acct')
      end

      it "should return false on :error" do
        @whm.send(:perform_request, 'testing_error')
        response = @whm.send(:format_response)
        response[:success].should be(false)
        response[:message].should match(/Unknown App Req/)
      end

      it "should return false on :unknown" do
        @whm.send(:perform_request, 'testing_unknown')
        response = @whm.send(:format_response)
        response[:success].should be(false)
        response[:message].should match(/Unknown error occurred .*wtf.*/)
      end
    end
  end
end
