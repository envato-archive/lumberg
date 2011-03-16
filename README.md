Lumberg
=======

This is a gem that does WHM stuff

Usage
-----

Create a server object

    server = Lumberg::Whm::Server.new(:host => WHM_HOST, :hash => WHM_HASH)

You can access the modules of WHM by calling server.<module>. For example, server.account or server.dns. Here's all of the supported modules:

    * Account
    * DNS
    * Reseller

Here's how to get a list of accounts:

    account = server.account
    result = account.list

Most responses will return success and a message

    p "Returned #{result[:success]} with message: #{result[:message]}"

    Returned true with message: Ok

You can grab the data you need from the results hash

    num_accounts = result[:params][:acct].size
    p "There are #{num_accounts} accounts"

    There are 6 accounts


Here's an example of what the renurned data looks like for a single account

    pp result[:params][:acct].first

    {:startdate=>false,
     :plan=>"default",
     :suspended=>false,
     :theme=>"x3",
     :shell=>"/usr/local/cpanel/bin/jailshell",
     :maxpop=>"unlimited",
     :maxlst=>"unlimited",
     :maxaddons=>"*unknown*",
     :suspendtime=>nil,
     :ip=>false,
     :maxsub=>"unlimited",
     :domain=>"bob.com",
     :maxsql=>"unlimited",
     :partition=>"home",
     :maxftp=>"unlimited",
     :user=>"bob",
     :suspendreason=>"not suspended",
     :unix_startdate=>false,
     :diskused=>false,
     :maxparked=>"*unknown*",
     :email=>"*unknown*",
     :disklimit=>"unlimited",
     :owner=>"root"}




