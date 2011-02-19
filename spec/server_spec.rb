require 'spec_helper'

# Requests will need an "Authorization" header with 
# WHM username:hash"
describe Whm::Server do
  before(:each) do
    @login = { host: 'myhost.com', hash: 'iscool' }
  end

  context "Setting up the server host, username, url, and hash" do
    it "should setup host and hash" do
      whm = Whm::Server.new(@login)
      whm.hash.should == @login[:hash]
    end

    it "should set the url" do
      whm = Whm::Server.new(@login)
      whm.url.should == "https://#{@login[:host]}:2087/json-api/"
    end

    it "should default to 'root' as the username" do
      whm = Whm::Server.new(@login)
      whm.user.should == 'root'
    end
  end

end
