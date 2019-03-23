#!/usr/bin/env ruby

require 'sinatra'
require 'json'
require 'open3'
require_relative 'dir2rss'


hash = JSON.parse(File.read("web.json"))
directory = hash["directory"]
baseurl = hash["baseurl"]

get '/' do
  dir2rss = Dir2rss.new(directory, baseurl)
  content_type 'application/rss+xml'
  dir2rss.mkvrss
end


error do
  e = env['sinatra.error']
  emsg = e.message
  emsg.strip! unless emsg.nil?

  msg = JSON.generate(emsg, quirks_mode: true)
  body "{ \"message\" : #{msg} }"

  not_found do
    "{ \"message\" : \"Error ! the link does not exist\" }"
  end
end
