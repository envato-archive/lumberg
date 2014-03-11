require 'spec_helper'

module Lumberg
  describe Cpanel::MysqlDb do
    let(:server) { Whm::Server.new(host: @whm_host, hash: @whm_hash) }
    let(:api_username) { "lumberg" }
    let(:mysql_db) do
      described_class.new(
        server: server,
        api_username: api_username
      )
    end

    describe "#add_db" do
      use_vcr_cassette("cpanel/mysql_db/add_db")

      it "adds a db" do
        mysql_db.add_db(dbname: 'cpanel')[:params][:result].should_not be_nil
      end
    end

    describe "#add_user" do
      use_vcr_cassette("cpanel/mysql_db/add_user")

      it "should add a user" do
        mysql_db.add_user(username: 'first', password: 'first_pass')[:params][:result].should_not be_nil
      end
    end

    describe "#add_user_db" do
      use_vcr_cassette("cpanel/mysql_db/add_user_db")

      it "should add a user to a db" do
        mysql_db.add_user_db(dbname: 'lumberg_cpanel', dbuser: 'lumberg_first',
                             perms_list: 'all')[:params][:result].should_not be_nil
      end
    end

    describe "#number_of_dbs" do
      use_vcr_cassette("cpanel/mysql_db/number_of_dbs")

      it "gets number of dbs" do
        mysql_db.number_of_dbs[:params][:result].should eq("1")
      end
    end

    describe "#check_db" do
      use_vcr_cassette("cpanel/mysql_db/check_db")

      it "should check db" do
        mysql_db.check_db(dbname: 'lumberg_cpanel')[:params][:result].should_not be_nil
      end
    end

    describe "#repair_db" do
      use_vcr_cassette("cpanel/mysql_db/repair_db")

      it "should repair the db" do
        mysql_db.repair_db(dbname: 'lumberg_cpanel')[:params][:result].should_not be_nil
      end
    end

    describe "#update_privs" do
      use_vcr_cassette("cpanel/mysql_db/update_privs")

      it "should update privileges" do
        mysql_db.update_privs[:params][:result].should_not be_nil
      end
    end

    describe "#init_cache" do
      use_vcr_cassette("cpanel/mysql_db/init_cache")

      it "should refresh the cache of MySQL information" do
        mysql_db.init_cache[:params][:result].should_not be_nil
      end
    end

    describe "#del_user_db" do
      use_vcr_cassette("cpanel/mysql_db/del_user_db")

      it "should disallow a user from accessing a db" do
        mysql_db.del_user_db(dbname: 'lumberg_cpanel', dbuser: 'lumberg_first')[:params][:result].should_not be_nil
      end
    end

    describe "#del_user" do
      use_vcr_cassette("cpanel/mysql_db/del_user")

      it "should delete a user" do
        mysql_db.del_user(dbuser: 'lumberg_first')[:params][:result].should_not be_nil
      end
    end

    describe "#del_db" do
      use_vcr_cassette("cpanel/mysql_db/del_db")

      it "should delete db" do
        mysql_db.del_db(dbname: 'lumberg_cpanel')[:params][:result].should_not be_nil
      end
    end

    describe "#add_host" do
      use_vcr_cassette("cpanel/mysql_db/add_host")

      it "should add host" do
        mysql_db.add_host(hostname: 'cpanel_test.com')[:params][:result].should_not be_nil
      end
    end

    describe "#del_host" do
      use_vcr_cassette("cpanel/mysql_db/del_host")

      it "should delete host" do
        mysql_db.del_host(host: 'cpanel_test.com')[:params][:result].should_not be_nil
      end
    end
  end
end
