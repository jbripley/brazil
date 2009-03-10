# Copyright (c) 2005,2006,2007,2008 Christopher Kleckner
# All rights reserved
#
# This file is part of the Rio library for ruby.
#
# Rio is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# Rio is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Rio; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#


# This is disgraceful -- a hack required to exert control over how rubygems builds
# documentation for Rio. My desire to have the command "gem install rio" build the
# docs correctly overrides my sense of propriety in this case. I apologize to anyone
# who should have to look at this ugliness. 

# Begin UGLY
module Generators #:nodoc: all
  #####################################################################
  #
  # Handle common markup tasks for the various Html classes
  #

  module MarkUp

    # Convert a string in markup format into HTML. We keep a cached
    # SimpleMarkup object lying around after the first time we're
    # called per object.

    def markup(str, remove_para=false)
      return '' unless str
      unless defined? @markup
        #p 'RIO MARKUP'
        @markup = SM::SimpleMarkup.new

        # class names, variable names, file names, or instance variables
#        @markup.add_special(/(
#                               \b([A-Z]\w*(::\w+)*[.\#]\w+)  #    A::B.meth
#                             | \b([A-Z]\w+(::\w+)*)       #    A::B..
#                             | \#\w+[!?=]?                #    #meth_name 
#                             | \b\w+([_\/\.]+\w+)+[!?=]?  #    meth_name
#                             )/x, 
#                            :CROSSREF)
        meth_name_re = '\w+[!?=]?|<{1,2}|>{1,2}|\[\]|\||\/|\+@?|={2,3}|=~'
        @markup.add_special(/(
                               \b([A-Z]\w*(::\w+)*[.\#](#{meth_name_re}))  #    A::B.meth
                             | \b([A-Z]\w+(::\w+)*)       #    A::B..
                             | \#(#{meth_name_re})                #    #meth_name 
                             | \b\w+([_\/\.]+\w+)+[!?=]?  #    meth_name
                             )/x, 
                            :CROSSREF)

        # external hyperlinks
        @markup.add_special(/((link:|https?:|mailto:|ftp:|www\.)\S+\w)/, :HYPERLINK)

        # and links of the form  <text>[<url>]
        @markup.add_special(/(((\{.*?\})|\b\S+?)\[\S+?\.\S+?\])/, :TIDYLINK)
#        @markup.add_special(/\b(\S+?\[\S+?\.\S+?\])/, :TIDYLINK)

      end
      unless defined? @html_formatter
        @html_formatter = HyperlinkHtml.new(self.path, self)
      end

      # Convert leading comment markers to spaces, but only
      # if all non-blank lines have them

      if str =~ /^(?>\s*)[^\#]/
        content = str
      else
        content = str.gsub(/^\s*(#+)/)  { $1.tr('#',' ') }
      end

      res = @markup.convert(content, @html_formatter)
      if remove_para
        res.sub!(/^<p>/, '')
        res.sub!(/<\/p>$/, '')
      end
      res
    end
  end
end
module Generators
  class HyperlinkHtml < SM::ToHtml
    def handle_special_CROSSREF(special)
      #p 'handle_special_CROSSREF'
      name = special.text
      if name[0,1] == '#'
        lookup = name[1..-1]
        name = lookup unless Options.instance.show_hash
      else
        lookup = name
      end

      if /([A-Z].*)[.\#](.*)/ =~ lookup
        container = $1
        method = $2
        ref = @context.find_symbol(container, method)
      else
        ref = @context.find_symbol(lookup)
      end

      if ref and ref.document_self
        #print "#{name} =>"
        #name.sub!(/^(RIO::)?IF::.+\#/,'Rio#')
        name.sub!(/^(RIO::)?IF::.+\#/,'')
        #name.sub!(/^#/,'Rio#')
        name.sub!(/^#/,'')
        #puts " #{name}"
        if %w[Rio Grande String].include?(name) or name =~ /^(Dir)/
        #if %w[Rio Grande String].include?(name)
          name
        else
          "<a href=\"#{ref.as_href(@from_path)}\">#{name}</a>"
        end
      else
        name
      end
    end
  end
end
# End UGLY
