require 'spec_helper'

describe Lumberg::Config do
  before(:each) do
    @config = Lumberg::Config.new
  end

  describe "#new" do
    it "sets up the @config hash" do
      @config.options.should == {}
    end
  end

  describe "#[]" do
    it "behaves like an array" do
      @config.options[:something] = 1
      @config[:something].should == 1
    end
  end

  describe "#debug" do
    it "configures net/http to log to console" do
      @config.options[:debug].should be_nil
      @config.debug true
      @config.options[:debug].should == true
    end
  end
end
