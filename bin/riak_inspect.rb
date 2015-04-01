#!/usr/bin/env ruby
# command-line tool to inspect buckets on riak servers
require 'riak'
require 'optparse'
require 'ostruct'

class OptParser

  def self.parse(args)
    options = OpenStruct.new
    # set defaults
    options.verbose = false
    options.host = 'localhost'
    options.port = 8087
    options.bucket = 'test'

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: #{__FILE__} [options]"
      opts.separator ""
      opts.separator "Options:"

      opts.on("-h", "--host host", "Riak host") do |h|
        options.host = h
      end
      opts.on("-b", "--bucket bucket", "Riak bucket") do |bucket|
        options.bucket = bucket
      end
      opts.on("-p", "--port port", Integer, "Riak port") do |port|
        options.port = port
      end
      opts.on("-kMANDATORY", "--key=MANDATORY", "riak bucket key, required") do |bucket_key|
        options.bucket_key = bucket_key
      end
      opts.on("-v", "--value [value]", "riak bucket value, optional") do |bucket_value|
        options.bucket_value = bucket_value
      end

      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(args)
    if options.bucket_key.nil? then
      puts opt_parser.to_s
      exit 1
    end
    options
  end
end

options = OptParser.parse(ARGV)

puts %Q{connecting to host "#{options.host}:#{options.port}/#{options.bucket}"}
client = Riak::Client.new(host: options.host, pb_port: options.port)
bucket = client.bucket(options.bucket)

if options.bucket_value then
  item = bucket.new(options.bucket_key)
  item.data = options.bucket_value
end

value = bucket.get(options.bucket_key)
puts "#{options.bucket}/#{options.bucket_key} => #{value.nil? ? value : value.raw_data}"

exit 0
