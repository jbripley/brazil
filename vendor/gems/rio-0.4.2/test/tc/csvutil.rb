#!/usr/local/bin/ruby
if $0 == __FILE__
  Dir.chdir File.dirname(__FILE__)+'/../'
  $:.unshift File.expand_path('../lib/')
end

require 'rio'

module CSV_Util
  def records_to_rows(records)
    n_records = records.size
    rows = []
    head = records[0]
    (1...n_records).each do |n|
      record = records[n]
      row = {}
      (0...record.size).each do |ncol|
        row[head[ncol]] = row[ncol]
      end
      rows << row
    end
    rows
  end
  def records_to_strings(records)
    records.map { |values| values.join(',') }
  end
  def records_to_string(records)
    records_to_strings(records).join("\n") + "\n"
  end
  def strings_to_string(strings)
    strings.join("\n") + "\n"
  end
  def strings_to_lines(strings)
    strings.map { |s| s + "\n" }
  end
  def create_test_csv_records(n_rows,n_cols,header=true)
    records = []
    
    records << (0...n_cols).map { |n| "Head#{n}" } if header
    
    (0...n_rows).each do |nrow|
      records << (0...n_cols).map { |n| "Dat#{nrow}#{n}" }
    end
    records
  end

  def create_test_csv_data(frio,n_rows,n_cols,header=true)
    records = create_test_csv_records(n_rows,n_cols,header)
    strings = records_to_strings(records)
    lines = strings_to_lines(strings)
    string = strings_to_string(strings)
    frio < string
    [records,strings,lines,string]
  end

end
