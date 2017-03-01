require "xml2csv/version"
require 'xml2csv/adapters/base_adapter'
require 'xml2csv/adapters/config_adapter'
require 'yaml'
require 'csv'
require 'nokogiri'
require 'slop'
require 'byebug'

module Xml2Csv
  def self.process
    opts = Slop.parse(help: true) do 
      banner "Usage: xml2csv [options] xml_file csv_file"
      on :c, :config=, 'config'
      on :t, :header, 'output with names header'
    end

    unless opts.config? && File.exist?(opts[:config])
      puts "You mast select config file!"
      puts opts.help
      exit
    end

    xml_file = ARGV.shift
    unless xml_file
      puts "You must select xml file!"
      exit
    end

    csv_file = ARGV.shift
    unless csv_file
      puts "You must select csv file!"
      exit
    end
    parsed = BaseAdapter.instance(opts[:config], xml_file)
    CSV.open(csv_file, "wb") do |csv|
      csv << parsed.item_keys if opts.header?
      parsed.each_item do |data|
        csv << data
      end
    end
  end
end
