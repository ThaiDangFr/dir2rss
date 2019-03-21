#!/usr/bin/env ruby
#yum install rubygem-sinatra

require 'sinatra'
require 'json'
require 'open3'

hash = JSON.parse(File.read("sinatra.json"))
directory = hash["directory"]
baseurl = hash["baseurl"]

get '/' do
  stdout, stderr, status = Open3.capture3("./dir2rss.rb --directory #{directory} --baseURL #{baseurl}")

  if status.success?
    content_type 'application/rss+xml'
    stdout
  else
    raise stderr
  end
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
