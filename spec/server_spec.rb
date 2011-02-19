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
    
      whm.host.should == @login[:host]
      whm.hash.should == @login[:hash]
    end

    it "should transform the host into an SSL URL by default" do
      whm = Whm::Server.new(@login)
      whm.url.should == "https://#{@login[:host]}:2087/json-api/"
    end

    it "should transform the host into an SSL URL when asked" do
      whm = Whm::Server.new(@login.merge(:ssl => true))
      whm.url.should == "https://#{@login[:host]}:2087/json-api/"
    end

    it "should transform the host into a non SSL URL when asked" do
      whm = Whm::Server.new(@login.merge(:ssl => false))
      whm.url.should == "http://#{@login[:host]}:2086/json-api/"
    end

    it "should default to 'root' as the username" do
      whm = Whm::Server.new(@login)
      whm.user.should == 'root'
    end
  end

  context "Formatting the Hash" do
    it "should raise an error if hash is not a string" do
      expect{ Whm::Server.new(@login.merge(hash: nil)) }.to raise_error Lumberg::WhmArgumentError
    end

    it "should remove \\n's from the hash" do
      @login = @login.merge(hash: "my\nhash")
      whm = Whm::Server.new(@login)
      whm.hash.should == 'myhash'
    end

    it "should remove whitespace from the hash" do
      @login = @login.merge(hash: "my hash")
      whm = Whm::Server.new(@login)
      whm.hash.should == 'myhash'
    end
  end
end
