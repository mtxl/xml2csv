#!/usr/bin/env ruby

require 'csv'

exclude_industries = %w(Искусство ЖКХ Туризм Строительство)
CSV.open("excluded_emails.csv", "wb") do |csv|
  CSV.foreach(ARGV.first) do |raw|
#    puts raw[5].split(",").first
    csv << [raw[2]] if exclude_industries.include?(raw[5].split(",").first)
  end
end
