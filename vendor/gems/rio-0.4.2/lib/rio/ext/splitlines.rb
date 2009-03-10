#--
# =============================================================================== 
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
# =============================================================================== 
#++
#
# To create the documentation for Rio run the command
#  ruby build_doc.rb
# from the distribution directory.
#
# Suggested Reading
# * RIO::Doc::SYNOPSIS
# * RIO::Doc::INTRO
# * RIO::Doc::HOWTO
# * RIO::Doc::EXAMPLES
# * RIO::Rio
#


# begin
#   require 'faster_csv'  # first choice--for speed

#   # A CSV compatible interface for FasterCSV.
#   module CSV  # :nodoc:
#     def self.parse_line( line, field_sep=nil, row_sep=nil )
#       FasterCSV.parse_line( line, :col_sep => field_sep || ",",
#                                   :row_sep => row_sep   || :auto )
#     end
    
#     def self.generate_line( array, field_sep=nil, row_sep=nil )
#       FasterCSV.generate_line( array, :col_sep => field_sep || ",",
#                                       :row_sep => row_sep   || "" )
#     end
#   end
# rescue LoadError
#   require 'csv'         # second choice--slower but standard
# end

module RIO
  module Ext
    module SplitLines
      module Cx
        def splitlines(sep=',',&block) 
          #p callstr('splitlines',sep) 
          cx['split_lines_sep'] = sep
          cxx('splitlines',true,&block) 
        end
        def splitlines?() cxx?('splitlines') end 
        def splitlines_(sep=',',rs=nil) 
          cx['split_lines_sep'] = sep
          cxx_('splitlines',true) 
        end
        protected :splitlines_
        def columns(*ranges,&block)
          if skipping?
            cx['skipping'] = false
            skipcolumns(*args,&block)
          else
            @cnames = nil
            cx['col_args'] = ranges.flatten
            cxx('columns',true,&block)
          end
        end
        def skipcolumns(*ranges,&block)
          @cnames = nil
          cx['nocol_args'] = ranges.flatten
          cxx('columns',true,&block)
        end
        def columns?() 
          cxx?('columns') 
        end 
      end
    end
  end
end
module RIO
  module Ext
    module SplitLines
      module Input

        protected

        def to_rec_(raw_rec)
          #_init_cols_from_line(raw_rec) if @recno == 0
          #p "#{callstr('to_rec_',raw_rec.inspect,@recno)} ; itertype=#{cx['stream_itertype']}"
          case cx['stream_itertype']
          when 'lines' 
            raw_rec
          when 'records'
            _l2record(raw_rec,cx['split_lines_sep'])
          else
            _l2record(raw_rec,cx['split_lines_sep'])
          end
        end

        private

        def trim(fields)
          #p callstr('trim',fields)
          ycols = cx['col_args']
          ncols = cx['nocol_args']
          return [] if ncols and ncols.empty?
          if ycols.nil? and ncols.nil?
            return fields
          end
          ncols = [] if ncols.nil?
          ycols = [(0...fields.size)] if ycols.nil? or ycols.empty?
          cols = []
          fields.each_index { |i|
            yes = nil
            no = nil
            ycols.each { |yc|
              if yc === i
                yes = true
                break
              end
            }
            ncols.each { |nc|
              if nc === i
                no = true
                break
              end
            }

            cols << i if yes and !no
          }
          tfields = []
          cols.each do |i|
            tfields << fields[i]
          end
          tfields
        end
        def parse_line_(line,sep)
          #p callstr('parse_line_',line,sep)
          line.split(sep)
        end
        def _l2a(line,sep)
          parse_line_(line,dep)
        end
        def _l2record(line,sep)
          #p callstr('_l2record',line,sep)
          trim(parse_line_(line,sep))
        end

        def _init_cols_from_line(line)
          ary = _l2record(line,cx['split_lines_sep'])
          _init_cols_from_ary(ary)
        end

        def _init_cols_from_num(num)
          fake_rec = (0...num).map { |n| "Column#{num}" }
          _init_cols_from_ary(fake_rec)
        end
        def _init_cols_from_hash(hash)
          _init_cols_from_ary(hash.keys)
        end
        def _init_cols_from_ary(ary)
          #p callstr('_init_cols_from_ary',ary)
          if columns?
            cx['col_names'] = []
            cx['col_nums'] = []

            ary.each_with_index do |cname,idx|
              cx['col_args'].each do |arg|
                if arg === ( arg.kind_of?(::Regexp) || arg.kind_of?(::String) ? cname : idx )
                  cx['col_names'] << cname
                  cx['col_nums'] << idx
                end
              end
            end
          else
            cx['col_names'] = ary
          end
          cx.values_at('col_nums','col_names')
        end

      end
    end

    module SplitLines
      module Output

        public

        def putrow(*argv)
          row = ( argv.length == 1 && argv[0].kind_of?(::Array) ? argv[0] : argv )
          self.puts(row.join(self.cx['split_lines_sep']))
        end
        def putrow!(*argv)
          putrow(*argv)
          close
        end

        protected

        def put_(arg,sep=cx['split_lines_sep'])
          #p callstr('put_',arg.inspect,fs,rs)
          puts(_to_line(arg,sep))
        end

        def cpfrom_array_(ary)
          #p callstr('copy_from_array',ary.inspect)
          if ary.empty?
            super
          else
            if ary[0].kind_of? ::Array
              super
            else
              put_(ary)
            end
          end
        end

        private

        def _to_line(arg,sep=cx['split_lines_sep'])
          #p callstr('_to_line',arg.inspect,fs,rs)
          case arg
          when ::Array
            _ary_to_line(arg,sep)
          when ::Hash
            _ary_to_line(arg.values,sep)
          else
            arg
          end
        end

        def _ary_to_line(ary,sep)
          ary.join(sep)
        end
        public
      end
    end
  end
end
__END__
