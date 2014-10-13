# Lumberg [![Lumberg Build Status][Build Icon]][Build Status]

![Lumberg logo](http://i.imgur.com/xC4Sw.jpg)

Ruby library for the WHM & cPanel API. It is currently what we consider to be
beta-ish. Please report any issues you find. :)

[RDoc](http://rdoc.info/github/site5/lumberg/master/frames)

Confirmed to work with ruby 1.9.3, 2.0.0, 2.1.3 and JRuby 1.9 mode on
cPanel 11.28+

[Build Status]: http://travis-ci.org/site5/lumberg
[Build Icon]: https://secure.travis-ci.org/site5/lumberg.png?branch=master


## Install

    gem install lumberg


## Usage

Create a server object and connect to WHM using your host and hash:

```ruby
require 'lumberg'
server = Lumberg::Whm::Server.new(
  host: WHM_HOST,
  hash: WHM_HASH
)
```

If you are using HTTP Basic Authentication with a username/password:

```ruby
server = Lumberg::Whm::Server.new(
  host:       WHM_HOST,
  user:       USERNAME,
  hash:       'my_password',
  basic_auth: true
)
```

You can access the modules of WHM by calling `server.<module>`. For example,
`server.account` or `server.dns`. Here are the currently supported modules:

* Account
* DNS
* Reseller

Here's how to get a list of accounts:

```ruby
account = server.account
result  = account.list
```

Most responses will return success and a message

```ruby
p "Returned #{result[:success]} with message: #{result[:message]}"

Returned true with message: Ok
```

You can grab the data you need from the results hash

```ruby
num_accounts = result[:params][:acct].size
p "There are #{num_accounts} accounts"

There are 6 accounts
```

Here's an example of what the returned data looks like for a single account

```ruby
pp result[:params][:acct].first

{
  startdate:      false,
  plan:           "default",
  suspended:      false,
  theme:          "x3",
  shell:          "/usr/local/cpanel/bin/jailshell",
  maxpop:         "unlimited",
  maxlst:         "unlimited",
  maxaddons:      "*unknown*",
  suspendtime:    nil,
  ip:             false,
  maxsub:         "unlimited",
  domain:         "bob.com",
  maxsql:         "unlimited",
  partition:      "home",
  maxftp:         "unlimited",
  user:           "bob",
  suspendreason:  "not suspended",
  unix_startdate: false,
  diskused:       false,
  maxparked:      "*unknown*",
  email:          "*unknown*",
  disklimit:      "unlimited",
  owner:          "root"
}
```


### Account Example

Creating a new account requires only a username, domain, and password.

```ruby
result = server.account.create(
  username: 'newuser',
  domain:   'newuser.com',
  password: 'password'
)

if result[:success]
  p result[:message]
end

Account Creation Ok
```

You can list all accounts or search for a specific account.

```ruby
result = server.account.list(search: 'new', searchtype: 'user')
acct   = result[:params][:acct].first
p "Found user '#{acct[:user]}' with domain '#{acct[:domain]}'"

Found user 'newuser' with domain 'newuser.com'
```


Suspending an account is simple and the reason for suspension is optional.

```ruby
result = server.account.suspend(username: 'newuser', reason: 'bad user')
p "user was suspended successfully" if result[:success]

user was suspended successfully
```

We can look at the account list again to see the reason for the user's
suspension.

```ruby
result = server.account.list(search: 'new', searchtype: 'user')
acct   = result[:params][:acct].first
p "user '#{acct[:user]}' was suspended with reason '#{acct[:suspendreason]}'"

user 'newuser' was suspended with reason 'bad user'
```

Finally, we remove the user and delete their account.

```ruby
result = server.account.remove(username: 'newuser')
p result[:message]

newuser account removed
```


### Reseller Example

Creating a reseller works by changing the status of an existing user account,
so first we create a user account and then we can create that user as a reseller.

```ruby
result = server.account.create(
  username: 'rtest',
  domain:   'resellerexample.com',
  password: 'password'
)

if result[:success]
  result = server.reseller.create(username: 'rtest', makeowner: true)
  p "created reseller rtest" if result[:success]
end

created reseller rtest
```

You can get a list of all of the reseller accounts easily.

```
result = server.reseller.list
p result[:params][:resellers].inspect

["samir", "rtest"]
```

Suspending a reseller is pretty straightforward. It's optional to provide a
reason for the suspension.

```ruby
result = server.reseller.suspend(username: 'rtest', reason: 'bad user')
p "reseller was suspended successfully" if result[:success]

user was suspended successfully
```

Deleting the reseller removes the reseller status from the user account. To
also delete the user account, set the `:terminatereseller` argument.

```ruby
result = server.reseller.terminate(reseller: 'rtest', terminatereseller: true)
p result[:message]

Account Terminations Complete
```

### Accessing cPanel API

[cPanel API](http://docs.cpanel.net/twiki/bin/view/SoftwareDevelopmentKit/ApiIntroduction)
interface is provided by the `Lumberg::Cpanel` module. Classes within the module
correspond to cPanel API modules. cPanel API module coverage is currently
incomplete and we're seeking contributions. Check out [Extending
Lumberg::Cpanel](#extending-lumbergcpanel) for details on how you can help.

#### cPanel 11.3x vs 11.4x

Prefer Lumberg _v2.0.0.pre10_ if you're running cPanel 11.3x.

We're targeting cPanel 11.4x from Lumberg _v2.0.0.pre11_ and above.

#### Email example

```ruby
# Create an interface object for cPanel API Email module
email = Lumberg::Cpanel::Email.new(
  server:       server,  # An instance of Lumberg::Server
  api_username: "jerry"  # User whose cPanel we'll be interacting with
)

# Get a list of email accounts
email.accounts[:params][:data] #=> Array of info hashes for each email account

# Add an email forwarder to forward mail for my-forwarder@domain.com to
# dest@other-domain.com
email.add_forwarder(
  domain:   "domain.com",
  email:    "my-forwarder",
  fwdopt:   "fwd",
  fwdemail: "dest@other-domain.com"
)

```

## Contributing

### Extending Lumberg::Cpanel

1. Find a cPanel API module that isn't already covered. See
   [cPanel API documentation](http://docs.cpanel.net/twiki/bin/view/SoftwareDevelopmentKit/ApiIntroduction)
   for a full list of available API modules.

2. Create a file (underscore style) in `lib/lumberg/cpanel/` named after the
   cPanel API module you're working on. If the cPanel API module is "LangMods"
   name the file "lang_mods.rb". You'll define your class here. `require` this
   file from `lib/lumberg/cpanel.rb`.

3. Define a class that inherits from `Lumberg::Cpanel::Base`:
   ```ruby
   # Create a class for (fictional) "SomeModule" API module
   module Lumberg
     module Cpanel
       class SomeModule < Base
       end
     end
   end
   ```
   The cPanel API module name is normally inferred from the class name, e.g., if
   the class name is `Email` the cPanel "Email" API module will be used. If the
   cPanel API module you're working with doesn't match up with Ruby class naming
   convention, override the `::api_module` class method:
   ```ruby
   module Lumberg
     module Cpanel
       class SslInfo
         def self.api_module; "SSLInfo"; end
       end
     end
   end
   ```
4. Fill in the methods.
   ```ruby
   module Lumberg
     module Cpanel
       class Branding
         # Public: Get URL locations for specific sprites.
         #
         # options - Hash options for API call params (default: {}):
         #  :img        - String branding object label for the image you want to
         #                retrieve.
         #  :imgtype    - String branding image type you want to retrieve, e.g.,
         #                "icon" or "heading".
         #  :method     - String specification for returned value options.
         #                Acceptable values are: "only_filetype_gif",
         #                "skip_filetype_gif", "snap_to_smallest_width", and
         #                "scale_60percent".
         #  :subtype    - String branding image subtype, e.g., "img", "bg",
         #                "compleximg".
         #  :image      - String parameter allows you to force appropriate
         #                output by setting it to "heading" (optional).
         #  :skipgroups - String parameter allows you to specify whether or not
         #                to include "img" values that begin with "group_" in
         #                the output. "1" indicates that you wish to skip "img"
         #                values that begin with "group_" (optional).
         #
         # Returns Hash API response.
         def list_sprites(options = {})
           perform_request({
            api_function: "spritelist"
           }.merge(options))
         end
       end
     end
   end
   ```

   - In many cases, you'll name your methods to match up
     with the documented cPanel API methods. However, the documented method
     names are sometimes a bit lengthy, confusing, or otherwise unwieldy; feel
     free to give your corresponding method an improved name.
   - Use [TomDoc](http://tomdoc.org/) documentation for your methods.
     Be sure to document all required and optional parameters from the
     cPanel API documentation.
   - All methods should take an options arg that defaults to {}.
     These options should be merged onto the options passed to
     #perform_request to allow overriding of :api_username or
     other parameters.

### Sanitizing VCR cassettes
All HTTP interactions are recorded using VCR and FakeWeb. Please be sure to remove
sensitive data from your cassettes. A Rake task is provided for this purpose:
```
WHM_HOST=my-cpanel-server.com WHM_HASH=$(cat my-access-hash) bundle exec rake sanitize_cassettes
```
Once you've sanitized your cassettes, manually verify that there's no sensitive
information still present (check URLs, authorization params, etc.).

### Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with Rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a
  commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2012-2014 Site5.com. See LICENSE for details.
