require 'spec_helper'
require 'lumberg/whm'
require 'lumberg/cpanel'

module Lumberg
  describe Cpanel::Base do
    before(:each) do
      @login  = { :host => @whm_host, :hash => @whm_hash }
      @server = Whm::Server.new(@login.dup)
      @base   = Cpanel::Base.new(:server => @server, :api_username => "foodawg")
    end

    describe "#initialize" do
      it "assigns api_username param to @api_username" do
        @base.api_username.should == "foodawg"
      end

      it "allows a server instance to be passed in" do
        @base.server.should be_a(Whm::Server)
      end

      it "allows a server hash to be passed in" do
        base = Cpanel::Base.new(:server => @login, :api_username => "foodawg")
        base.server.should be_a(Whm::Server)
      end

    end

    describe "#perform_request" do
      let(:valid_options) {{
        :api_username => "foodawg",
        :api_module   => "SomeModule",
        :api_function => "some_function"
      }}

      context "requires api_username" do
        it "loads saved api_username if api_username not specified" do
          @base.server.should_receive(:perform_request).with(
            anything,
            hash_including(
              :cpanel_jsonapi_module   => "SomeModule",
              :cpanel_jsonapi_func     => "some_function",
              :cpanel_jsonapi_user     => "foodawg"
            )
          )
          @base.perform_request(:api_module => "SomeModule", :api_function => "some_function")
        end
      end

      context "optional api_version is specified" do
        it "should perform the request with specified API version" do
          @base.server.should_receive(:perform_request).with(
            anything,
            hash_including(:cpanel_jsonapi_apiversion => 1234)
          )
          @base.perform_request(valid_options.merge(:api_version => 1234))
        end
      end

      context "optional api_version is not specified" do
        it "should set API version to 2" do
          @base.server.should_receive(:perform_request).with(
            anything,
            hash_including(:cpanel_jsonapi_apiversion => 2)
          )
          @base.perform_request(valid_options)
        end
      end

      context "optional key is specified" do
        it "should perform the request with specified key" do
          @base.server.should_receive(:perform_request).with(
            anything,
            hash_including(:key => "some_key")
          )
          @base.perform_request(valid_options.merge(:key => "some_key"))
        end
      end

      context "optional key is not specified" do
        it "should set key to \"cpanelresult\"" do
          @base.server.should_receive(:perform_request).with(
            anything,
            hash_including(:key => "cpanelresult")
          )
          @base.perform_request(valid_options)
        end
      end

      it "should perform the request with \"cpanel\" function" do
        @base.server.should_receive(:perform_request).with("cpanel", anything)
        @base.perform_request(valid_options)
      end

      it "should accept additional call parameters" do
        @base.server.should_receive(:perform_request).with(
          anything,
          hash_including(:awesome => "sauce")
        )
        @base.perform_request(valid_options.merge({ :awesome => "sauce" }))
      end

      context "@api_username is not nil" do
        it "uses @api_username as default for api_username param" do
          @base.api_username = "foodawg"
          @base.server.should_receive(:perform_request).with(
            anything,
            hash_including(:cpanel_jsonapi_user => "foodawg")
          )

          options = valid_options
          options.delete(:api_username)
          @base.perform_request(options)
        end
      end
    end

  end
end
