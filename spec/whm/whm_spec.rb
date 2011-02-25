require 'spec_helper'
require 'lumberg/whm'

module Lumberg
  describe Whm do
    before(:each) do
      @host = 'example.com'
    end
    context "Formatting a URL" do
      it "should be a URL" do
        Whm::format_url(@host).should == "https://example.com:2087/json-api/"
      end

      it "should be an SSL URL" do
        Whm::format_url(@host, :ssl => false).should == "http://example.com:2086/json-api/"
      end

      it "should transform the host into an SSL URL by default" do
        Whm::format_url(@host).should == "https://example.com:2087/json-api/"
      end

      it "should transform the host into an SSL URL when asked" do
        Whm::format_url(@host, :ssl => true).should == "https://example.com:2087/json-api/"
      end

      it "should transform the host into a non SSL URL when asked" do
        Whm::format_url(@host, :ssl => false).should == "http://example.com:2086/json-api/"
      end
    end

    context "Formatting the Hash" do
      it "should raise an error if hash is not a string" do
        expect{ Whm::format_hash(nil)}.to raise_error(Lumberg::WhmArgumentError, "Missing WHM hash")
      end

      it "should remove \\n's from the hash" do
        hash = Whm::format_hash("my\nhash\n")
        hash.should == 'myhash'
      end

      it "should remove whitespace from the hash" do
        hash = Whm::format_hash("    my hash ")
        hash.should == 'myhash'
      end
    end

    context "Converting to bool" do
      it "should transform all 1/0 values to bools" do
        hash = {:true => 1, :false => 0, :other => 2}
        new_hash = Whm::to_bool(hash)
        new_hash.should include(:true => true, :false => false, :other => 2)
      end

      it "should convert one specified key" do
        hash = {:true => 1, :false => 0, :other => 2}
        new_hash = Whm::to_bool(hash, :true)
        new_hash.should include(:true => true, :false => 0, :other => 2)
      end

      it "should convert all specified keys" do
        hash = {:true => 1, :false => 0, :something => 1}
        new_hash = Whm::to_bool(hash, :true, :false)
        new_hash.should include(:true => true, :false => false, :something => 1)
      end
    end

    context "Converting from bool to int" do
      it "should convert false to 0" do
        Whm::from_bool(false).should == 0
      end

      it "should convert true to 1" do
        Whm::from_bool(true).should == 1
      end

      it "should transform all falses and trues to 0 and 1" do
        hash = {:true => true, :false => false}
        Whm::from_bool(hash).should include(:true => 1, :false => 0)
      end
    end
  end
end
