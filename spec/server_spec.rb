require 'spec_helper'

# Requests will need an "Authorization" header with 
# WHM username:hash"
describe Whm::Server do
  before(:each) do
    @login = { host: 'myhost.com', hash: 'iscool' }
    @url_base = "https://myhost.com:2087/json-api"
  end

  context "Setting up the server host, username, url, and hash" do
    it "should setup host and hash" do
      whm = Whm::Server.new(@login.dup)
      whm.hash.should == @login[:hash]
    end

    it "should set the url" do
      whm = Whm::Server.new(@login.dup)
      whm.url.should == "https://#{@login[:host]}:2087/json-api/"
    end

    it "should default to 'root' as the username" do
      whm = Whm::Server.new(@login.dup)
      whm.user.should == 'root'
    end
  end

  context "Performing a HTTP request" do
    it "should call the proper URL" do
      whm = Whm::Server.new(@login.dup)
      whm.perform_request('my_function').should == "#{@url_base}/my_function?"
    end

    it "should call the proper URL and arguments" do
      whm = Whm::Server.new(@login.dup)
      whm.perform_request('my_function', arg1: 1, arg2: 'test').should == "#{@url_base}/my_function?arg1=1&arg2=test"
    end
  end
end
