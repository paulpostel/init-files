#!/usr/bin/ruby
#
require 'optparse'
require 'ostruct'
require 'riak'

DEFAULT_HOST = 'riak-pb.vip.qa.lax1.rent.com'
DEFAULT_BUCKET = 'rent'
DEFAULT_PORT = 8087

options = OpenStruct.new
parser = OptionParser.new do |opt|
  opt.on('-k', '--key key', 'The key to look for in --bucket') { |o| options.key = o }
  opt.on('-b', '--bucket bucket', 'The riak bucket to connect to') { |o| options.bucket = o }
  opt.on('-h', '--host hostname', 'The riak host to connect to') { |o| options.hostname = o }
  opt.on('-p', '--port portnum', 'The port on --host to connect to') { |o| options.port = o }
end

parser.parse!

# --key is required, 
# TODO: ought to be able to specify requiredness to the parser...
unless options && options.key
  STDERR.puts parser.help
  exit 1
end

# TODO: defaults for options, ought to be done via the parser...
options.hostname = DEFAULT_HOST unless options.host
options.bucket = DEFAULT_BUCKET unless options.bucket
options.port = DEFAULT_PORT unless options.port
puts "#{options.hostname}:#{options.port}/#{options.bucket}/#{options.key}"

client = Riak::Client.new host: options.hostname, pb_port: options.port
bucket = client.bucket( options.bucket )

begin
  puts bucket.get( options.key ).raw_data
rescue Riak::ProtobuffsFailedRequest
  puts "failed to find value for key \"#{options.key}\""
end
