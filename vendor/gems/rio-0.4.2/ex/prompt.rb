#!/usr/local/bin/ruby

require 'rio'

ans = rio(?-).chomp.print("Type Something: ").gets
rio(?-).puts("You typed '#{ans}'")

# Could also be written like this
#
#stdio = rio(?-).chomp
#ans = stdio.print("Type Something: ").gets
#stdio.puts("You typed '#{ans}'")
#
# Or even this
#
#stdio = rio(?-).chomp
#stdio.puts("You typed '#{stdio.print("Type Something: ").gets}'")
#
# Or this
#
#rio(?-).puts("You typed '#{rio(?-).chomp.print("Type Something: ").gets}'")
#


__END__
