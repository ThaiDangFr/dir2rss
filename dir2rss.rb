#!/usr/bin/env ruby
require 'logger'
require 'fileutils'
require 'optparse'
require 'pp'
require 'rss'

$logger = Logger.new(STDOUT)
$logger.level = Logger::ERROR

$logger.formatter = proc do |severity, datetime, progname, msg|
  date_format = datetime.strftime("%d-%m-%Y %H:%M:%S.%6N")
  "#{severity[0]} [#{date_format}] : #{msg}\n"
end

class Dir2rss

  def initialize(dir, baseurl)
    @dir = dir
    @baseurl = baseurl
  end

  def filesize(size)
    units = ['B', 'KiB', 'MiB', 'GiB', 'TiB', 'Pib', 'EiB']

    return '0.0 B' if size == 0
    exp = (Math.log(size) / Math.log(1024)).to_i
    exp = 6 if exp > 6 

    '%.1f %s' % [size.to_f / 1024 ** exp, units[exp]]
  end

  def mkvrss
    files = Dir.chdir(@dir) do
      Dir["**/*.{mkv,MKV}"]
    end
    $logger.debug files

    rss = RSS::Maker.make("rss2.0") do |maker|
      maker.channel.link = @baseurl
      maker.channel.description = "mkv files"
      maker.channel.title = "mkv files"

      files.each do |f|
        maker.items.new_item do |item|
          item.link = "#{@baseurl}/#{f}"
          item.title = File.basename(f)
          item.updated = File.ctime("#{@dir}/#{f}")
          size = filesize(File.size("#{@dir}/#{f}"))
          item.description = "Size of file is #{size}"
        end
      end
    end

    rss.to_s
  end
end


