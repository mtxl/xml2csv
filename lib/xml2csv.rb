require "xml2csv/version"
require 'xml2csv/adapters/base_adapter'
require 'xml2csv/adapters/config_adapter'
require 'yaml'
require 'csv'
require 'nokogiri'
require 'slop'
require 'byebug'

module Xml2Csv

  def self.convert_csv(config, source, params ={} )
    output_dir = params[:output_dir] || "output"
    header = params[:header] || false

    parsed = BaseAdapter.instance(config, source)

    csv_file = File.join(output_dir,File.basename(source, ".xml"))+".csv"

    CSV.open(csv_file, "wb") do |csv|
      csv << parsed.header if header
      parsed.each_item do |data|
        csv << data
      end
    end
  end

  def self.process
    opts = Slop.parse(help: true) do 
      banner "Usage: xml2csv [options] xml_source"
      banner "       xml_source may be file or directory"
      on :c, :config=, 'config'
      on :t, :header, 'csv with names header'
      on :o, :output, 'output directory'
    end

    unless opts.config? && File.exist?(opts[:config])
      puts "You mast select config file!"
      puts opts.help
      exit
    end

    xml_source = ARGV.shift
    unless xml_source
      puts "You must select xml file!"
      exit
    else
      if File.directory?(xml_source)
        xml_source = Dir.glob("#{xml_source}/*.xml")
      else
        xml_source = [xml_source]
      end
    end

    xml_source.each do |source_file|
      convert_csv(opts[:config], source_file, opts.to_hash)
    end

  end
end
