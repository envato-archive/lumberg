require 'spec_helper'

# Requests will need an "Authorization" header with 
# WHM username:hash"
describe Whm::Server do
  before(:each) do
    if ENV['WHM_REAL']
      @whm_hash = ENV['WHM_HASH'].dup
      @whm_host = ENV['WHM_HOST'].dup
    else
      @whm_hash = 'iscool'
      @whm_host = 'myhost.com'
    end
    @login    = { host: @whm_host, hash: @whm_hash }
    @whm      = Whm::Server.new(@login.dup)
    @url_base = "https://myhost.com:2087/json-api"
  end

  context "Setting up the server host, username, url, and hash" do
    it "should setup host and hash" do
      @whm.hash.should == @login[:hash]
    end

    it "should set the url" do
      @whm.url.should == "https://#{@login[:host]}:2087/json-api/"
    end

    it "should default to 'root' as the username" do
      @whm.user.should == 'root'
    end
  end
 
  context "Performing an HTTP request" do
    describe "my_function" do
      use_vcr_cassette "my_function", :record => :new_episodes

      it "should verify SSL certs for HTTP requests"

      it "should call the proper URL" do
        JSON.should_receive(:parse).with("[]").and_return([])
        @whm.perform_request('my_function')
        @whm.function.should == 'my_function'
        @whm.params.should be_empty
        @whm.raw_response.should be_a(Net::HTTPOK)
      end

      it "should call the proper URL and arguments" do
        JSON.should_receive(:parse).with("[]").and_return([])
        @whm.perform_request('my_function', arg1: 1, arg2: 'test')
        @whm.function.should == 'my_function'
        @whm.params.should == "arg1=1&arg2=test"
        @whm.raw_response.should be_a(Net::HTTPOK)
      end
    end

    describe "applist" do
      use_vcr_cassette "applist", :record => :new_episodes

      it "should set a response message" do
        @whm = Whm::Server.new(host: @whm_host, hash: @whm_hash)
        @whm.perform_request('applist')
        @whm.function.should == 'applist'
      end
    end
  end
end
