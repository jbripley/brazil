#!/usr/local/bin/ruby
require 'rio'

# Create a tab separated file of accounts in a UNIX passwd file,
# listing only the username, uid, and realname fields

rio('/etc/passwd').csv(':').columns(0,2,4) > rio(?-).csv("\t")

