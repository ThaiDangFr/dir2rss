#!/usr/bin/env ruby
require_relative 'dir2rss'

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

  dir2rss = Dir2rss.new(dir, baseurl)
  puts dir2rss.mkvrss


rescue => err
  $logger.fatal("Caught exception; exiting")
  $logger.fatal(err)
  exit 1

ensure
  $logger.debug "--END--"
end
