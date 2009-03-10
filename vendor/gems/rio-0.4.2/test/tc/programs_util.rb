
module Test
  module RIO
    module Programs
      TEST_BIN_DIR = File.expand_path(Dir.pwd+'/bin')

      XPROGS = {
        'count_lines' => 'wc -l',
        'find_lines'  => 'grep',
        'list_dir'    => 'ls',
      }
      RPROGS = {
        'count_lines' => "ruby #{TEST_BIN_DIR}/count_lines.rb",
        'find_lines'  => "ruby #{TEST_BIN_DIR}/find_lines.rb",
        'list_dir'    => "ruby #{TEST_BIN_DIR}/list_dir.rb",
      }
      PROG = {
        'count_lines' => ($mswin32 ? RPROGS['count_lines'] : XPROGS['count_lines']),
        'find_lines' => ($mswin32 ? RPROGS['find_lines'] : XPROGS['find_lines']),
        'list_dir' => ($mswin32 ? RPROGS['list_dir'] : XPROGS['list_dir']),
      }
    end
  end
end
