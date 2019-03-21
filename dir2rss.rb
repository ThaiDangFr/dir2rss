#!/usr/bin/env ruby
require 'logger'
require 'fileutils'
require 'optparse'
require 'pp'
require 'rss'


def filesize(size)
  units = ['B', 'KiB', 'MiB', 'GiB', 'TiB', 'Pib', 'EiB']

  return '0.0 B' if size == 0
  exp = (Math.log(size) / Math.log(1024)).to_i
  exp = 6 if exp > 6 

  '%.1f %s' % [size.to_f / 1024 ** exp, units[exp]]
end




$logger = Logger.new(STDOUT)
$logger.level = Logger::ERROR



begin

  options = {}
  optparse = OptionParser.new do |opts|
    opts.banner = "Usage: #{__FILE__} [options]"

    options[:verbose] = false
    opts.on('-v', '--verbose', 'Output more information') do
      options[:verbose] = true
      $logger.level = Logger::DEBUG
    end

    opts.on('--directory DIRECTORY', 'Directory with files' ) do |dir|
      options[:dir] = dir
    end

    opts.on('--baseURL BASEURL', 'URL to append to' ) do |baseurl|
      options[:baseurl] = baseurl
    end

    opts.on( '-h', '--help', 'Display this screen' ) do
      puts opts
      exit
    end
  end

  optparse.parse!
  # change $logger format
  $logger.formatter = proc do |severity, datetime, progname, msg|
    date_format = datetime.strftime("%d-%m-%Y %H:%M:%S.%6N")
    "#{severity[0]} [#{date_format}] : #{msg}\n"
  end

  mandatory = [:dir, :baseurl]                                        
  missing = mandatory.select{ |param| options[param].nil? }            
  if not missing.empty?                                                 
    puts "Missing options: #{missing.join(', ')}"                   
    puts optparse.help                                              
    exit 2                                                          
  end  

  dir = options[:dir]
  baseurl = options[:baseurl]

  $logger.debug "--BEGIN--"

  
  files = Dir.chdir("#{dir}") do
    Dir["**/*.{mkv,MKV}"]
  end

  $logger.debug files

  rss = RSS::Maker.make("rss2.0") do |maker|
    maker.channel.link = "#{baseurl}"
    maker.channel.description = "mkv files"
    maker.channel.title = "mkv files"

    files.each do |f|
      maker.items.new_item do |item|
        item.link = "#{baseurl}/#{f}"
        item.title = File.basename(f)
        item.updated = File.ctime("#{dir}/#{f}")
        size = filesize(File.size("#{dir}/#{f}"))
        item.description = "Size of file is #{size}"
      end
    end
  end

  puts rss


rescue => err
  $logger.fatal("Caught exception; exiting")
  $logger.fatal(err)
  exit 1

ensure
  $logger.debug "--END--"
end
