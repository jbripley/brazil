#!/usr/local/bin/ruby

require 'rio/prompt'

case answer = RIO.prompt("What is the crux of the biscuit: ")
when /the apostrophe/i 
  puts 'Billy was a Mountain'
else 
  puts "You typed '#{answer}'"
end
