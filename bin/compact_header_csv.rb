#!/usr/bin/env ruby

require 'csv'

CSV.open("compact_header.csv", "wb") do |csv|
  csv << ["name","phone", "email", "business", "contact", "source_id" ]
  CSV.foreach(ARGV.first) do |raw|
    csv << [raw[0], raw[1], raw[2], raw[3], raw[4], 6 ]
  end
end
