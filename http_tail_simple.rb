#!/usr/bin/ruby

#
# Implements a tail -f similar command over an HTTP connection the easy way.
#
# TODO: implement unit testing
# TODO: get last ten lines of content first
#

require 'net/http'

#
# Catch Ctrl-C user input to halt execution when in idle state
#

Signal.trap("INT") { exit }

#
# Extends the standard Math module with a Max function
#
# TODO: implement a Min function for simmetry
#

module Math
  def self.max(*args)
    max = args.shift
    args.each do |arg|
      if arg > max then
          max = arg
      end
    end
    max
  end
end

#
# Implements shortcuts to the standard HEAD and GET HTTP methods
#
# TODO: extend the standard HTTP module, for instance Net::HTTP::Shortcuts
#

class HttpShortcuts
  
  def self.__default_path(uri)
    if uri.path == nil or uri.path == ''
      uri.path = '/'
    end
    uri
  end
  
  def self.__http_request(request, uri)
    Net::HTTP::start(uri.host, uri.port) do |http|
      http.request(request)
    end
  end
  
  def self.content_length(uri)
    request = Net::HTTP::Head.new(self.__default_path(uri).path)
    self.__http_request(request, uri).content_length
  end
  
  def self.content(uri, offset, limit)
    request = Net::HTTP::Get.new(self.__default_path(uri).path)
    request.set_range offset, limit
    self.__http_request(request, uri).body
  end
  
end


#
# Main program entry point
#
# TODO: parameterize idle interval between requests 

INTERVAL = 1.0

if ARGV.length == 0 then
  exit
end
uri = URI.parse(ARGV[0])

last_length = 0

while true
  length = HttpShortcuts.content_length(uri)
  if length == nil
    break
  end
    
  if last_length == 0
    offset = Math.max(0, length - 512)
  elsif last_length < length 
    then offset = last_length
  else
    sleep INTERVAL
    redo
  end

  STDOUT.write HttpShortcuts.content(uri, offset, length)
  STDOUT.flush
  
  last_length = length
  sleep INTERVAL
end
