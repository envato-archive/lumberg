require 'spec_helper'
require 'lumberg/whm'

describe Whm::Server do
  before(:each) do
    @login = { host: 'myhost.com', hash: 'iscool' }
  end

  it "should setup host and hash" do
    whm   = Whm::Server.new(@login)
  
    whm.host.should == @login[:host]
    whm.hash.should == @login[:hash]
  end

  it "should transform the host into an SSL URL by default" do
    whm = Whm::Server.new(@login)
    whm.url.should == "https://#{@login[:host]}:2087"
  end

  it "should transform the host into an SSL URL when asked" do
    whm = Whm::Server.new(@login.merge(:ssl => true))
    whm.url.should == "https://#{@login[:host]}:2087"
  end

  it "should transform the host into a non SSL URL" do
    whm = Whm::Server.new(@login.merge(:ssl => false))
    whm.url.should == "http://#{@login[:host]}:2086"
  end
end
