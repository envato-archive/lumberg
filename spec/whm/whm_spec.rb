require 'spec_helper'
require 'lumberg/whm'

module Lumberg
  describe Whm do
    describe "#to_bool" do
      it "converts all 1/0 values to bools" do
        hash = {:true => 1, :false => 0, :other => 2}
        new_hash = Whm::to_bool(hash)
        new_hash.should include(:true => true, :false => false, :other => 2)
      end

      it "converts signle specified key" do
        hash = {:true => 1, :false => 0, :other => 2}
        new_hash = Whm::to_bool(hash, :true)
        new_hash.should include(:true => true, :false => 0, :other => 2)
      end

      it "converts all specified keys" do
        hash = {:true => 1, :false => 0, :something => 1}
        new_hash = Whm::to_bool(hash, :true, :false)
        new_hash.should include(:true => true, :false => false, :something => 1)
      end
    end

    describe "#from_bool" do
      it "converts false to 0" do
        Whm::from_bool(false).should == 0
      end

      it "converts true to 1" do
        Whm::from_bool(true).should == 1
      end

      it "converts all falses and trues to 0 and 1" do
        hash = {:true => true, :false => false}
        Whm::from_bool(hash).should include(:true => 1, :false => 0)
      end
    end
  end
end
