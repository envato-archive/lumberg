require 'spec_helper'
require 'lumberg/logger'

module Lumberg
  describe Logger do
    it "records message as info by default" do
      Logging.logger(STDOUT).should_receive(:info)
      Logger::add("message")
    end
    
    it "records given message as warning" do
      Logging.logger(STDOUT).should_receive(:warn).with("message")
      Logger::add("message", :warn)
    end
    
    it "changes logger output" do
      Logging.should_receive(:logger).with(:out)
      Logger::switch_to(:out)
    end
  end
end
