Lumberg
=======

![Lumberg logo](http://i.imgur.com/xC4Sw.jpg)

Ruby library for the WHM & cPanel API. It is currently what we consider to be beta-ish. Please report any issues you find. :)

[RDoc](http://rdoc.info/github/site5/lumberg/master/frames)

Confirmed to work with ruby 1.8.7, 1.9.2 and JRuby 1.6.0 on cPanel 11.28+

Install
-------

    gem install lumberg

Usage
-----

Create a server object and connect to WHM using your host and hash:

    require 'lumberg'
    server = Lumberg::Whm::Server.new(:host => WHM_HOST, :hash => WHM_HASH)

You can access the modules of WHM by calling server.<module>. For example, server.account or server.dns. Here are the currently supported modules:

* Account
* DNS
* Reseller


Here's how to get a list of accounts:

    account = server.account
    result  = account.list

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



Account Example
---------------

Creating a new account requires only a username, domain, and password.

    result = server.account.create(:username => 'newuser', :domain => 'newuser.com', :password => 'password')
    if result[:success]
      p result[:message]
    end 

    Account Creation Ok


You can list all accounts or search for a specific account.

    result = server.account.list(:search => 'new', :searchtype => 'user')
    acct   = result[:params][:acct].first
    p "Found user '#{acct[:user]}' with domain '#{acct[:domain]}'"

    Found user 'newuser' with domain 'newuser.com'


Suspending an account is simple and the reason for suspension is optional.

    result = server.account.suspend(:username => 'newuser', :reason => 'bad user')
    p "user was suspended successfully" if result[:success]

    user was suspended successfully

We can look at the account list again to see the reason for the user's suspension.

    result = server.account.list(:search => 'new', :searchtype => 'user')
    acct   = result[:params][:acct].first
    p "user '#{acct[:user]}' was suspended with reason '#{acct[:suspendreason]}'"

    user 'newuser' was suspended with reason 'bad user'

Finally, we remove the user and delete their account.

    result = server.account.remove(:username => 'newuser')
    p result[:message]

    newuser account removed



Reseller Example
----------------

Creating a reseller works by changing the status of an existing user account, so first we create a user account and then we can create that user as a reseller.

    result = server.account.create(:username => 'rtest', :domain => 'resellerexample.com', :password => 'password')
    if result[:success] 
      result = server.reseller.create(:username => 'rtest', :makeowner => true)
      p "created reseller rtest" if result[:success]
    end     

    created reseller rtest

You can get a list of all of the reseller acccounts easily.

    result = server.reseller.list
    p result[:params][:resellers].inspect

    ["samir", "rtest"]

Suspending a reseller is pretty straightforward. It's optional to provide a reason for the suspension.

    result = server.reseller.suspend(:username => 'rtest', :reason => 'bad user')
    p "reseller was suspended successfully" if result[:success]

    user was suspended successfully
    
Deleting the reseller removes the reseller status from the user account. To also delete the user account, set the :terminatereseller argument.

    result = server.reseller.terminate(:reseller => 'rtest', :terminatereseller => true)
    p result[:message]

    Account Terminations Complete

Contributors
============

* [Justin Mazzi](http://github.com/jmazzi)
* [Tim Parkin](http://github.com/tparkin)

Note on Patches/Pull Requests
=============================
All HTTP interactions are recorded using VCR and FakeWeb. Please be sure to remove any sensitive information from your cassettes.
 
* Fork the project.
* Add yourself to the Contributors list
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
=========

Copyright (c) 2011 Site5. See LICENSE for details.
