#!/usr/bin/env ruby

require 'csv'

emails = []
CSV.open("compact.csv", "wb") do |csv|
  CSV.foreach(ARGV.first) do |raw|
    email = raw[2]
    next if emails.include?(email)
    csv << raw
    emails << email 
  end
end
