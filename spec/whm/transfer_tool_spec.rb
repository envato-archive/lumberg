require 'spec_helper'
require 'lumberg/whm'

module Lumberg
  describe Whm::TransferTool do
    let(:source_server) { '192.168.1.100' }
    let(:username)      { 'mylogin' }
    let(:password)      { 't00r' }
    let(:xfer_id)       { 'x' }

    before do
      @server    = Whm::Server.new(host: @whm_host, hash: @whm_hash)
      @xfer_tool = Whm::TransferTool.new(server: @server.dup)
    end

    describe '#create' do
      use_vcr_cassette 'whm/transfer_tool/create'

      subject { @xfer_tool.create host: source_server, user: username, password: password }

      its([:success]) { should be_true }
      its([:message]) { should eq 'OK' }
      its([:params])  { should include :transfer_session_id }

      it 'has a session ID' do
        subject[:params][:transfer_session_id].should_not be_empty
      end
    end

    describe '#check' do
      use_vcr_cassette 'whm/transfer_tool/check'

      subject { @xfer_tool.check xfer_id }

      its([:success]) { should be_true }
      its([:message]) { should eq 'OK' }
      its([:params])  { should include :transfer_session_id }

      it 'has local server data' do
        subject[:params][:local].should_not be_empty
      end

      it 'has remote server data' do
        subject[:params][:remote].should_not be_empty
      end
    end

    describe '#validate_user' do
      use_vcr_cassette 'whm/transfer_tool/validate_user'

      subject { @xfer_tool.validate_user 'another' }

      its([:success]) { should be_true }
      its([:message]) { should eq 'OK' }

      it 'checks if user does not exist on local server' do
        subject[:params][:exists].should eq 0
      end

      it 'checks if account is not reserved' do
        subject[:params][:reserved].should eq 0
      end

      it 'checks if it is possible to create an account with that given login' do
        subject[:params][:valid_for_new].should eq 1
      end

      it 'checks if it is possible to migrate account to local server' do
        subject[:params][:valid_for_transfer].should eq 1
      end
    end

    describe '#enqueue' do
      use_vcr_cassette 'whm/transfer_tool/enqueue'

      subject do
        @xfer_tool.enqueue(
          transfer_session_id: xfer_id,
          size: 73682944, user: 'another')
      end

      its([:success]) { should be_true }
      its([:message]) { should eq 'OK' }
      its([:params])  { should be_nil }
    end

    describe '#start' do
      use_vcr_cassette 'whm/transfer_tool/start'

      subject { @xfer_tool.start xfer_id }

      its([:success]) { should be_true }
      its([:message]) { should eq 'OK' }
      its([:params])  { should include :pid }

      it 'sets PID for current migration' do
        subject[:params][:pid].should be_an Integer
      end
    end

    describe '#status' do
      use_vcr_cassette 'whm/transfer_tool/status'

      subject { @xfer_tool.status xfer_id }

      its([:success]) { should be_true }
      its([:message]) { should eq 'OK' }
      its([:params])  { should include :state_name }

      it 'returns current status' do
        subject[:params][:state_name].should_not be_empty
      end
    end

    describe '#show_log' do
      use_vcr_cassette 'whm/transfer_tool/show_log'

      subject { @xfer_tool.show_log xfer_id }

      its([:success]) { should be_true }
      its([:message]) { should eq 'OK' }
      its([:params])  { should include :log }

      it 'shows log for current transfer' do
        subject[:params][:log].should_not be_empty
      end
    end

    describe '#pause' do
      use_vcr_cassette 'whm/transfer_tool/pause'

      subject { @xfer_tool.pause xfer_id }

      its([:success]) { should be_true }
      its([:message]) { should eq 'OK' }
      its([:params])  { should be_nil }
    end
  end
end
