#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'

def main
  options = OpenStruct.new
  parser = OptionParser.new do |opt|
    opt.on('-c', '--coins v1,v2,...', 'The list of coin values') { |o| options.coin_string = o }
    opt.on('-s', '--sum sum', 'The sum to make') { |o| options.sum = o }
  end

  parser.parse!

  unless options && options.coin_string && options.sum
    STDERR.puts parser.help
    exit 1
  end

  # get int form of sum
  unless options.sum =~ /^\d+$/
    STDERR.puts parser.help
    STDERR.puts "#{$PROGRAM_NAME}: sum must be integer-valued, invalid sum: #{options.sum}\n"
    exit 1
  end

  sum = options.sum.to_i

  string_coins = options.coin_string.split(/\s*,\s*/)

  bad_coins = string_coins.grep(/\D/)
  if bad_coins.length > 0
    STDERR.puts parser.help
    STDERR.puts "#{$PROGRAM_NAME}: coins must be integer-valued, invalid coins: #{bad_coins.join( ', ' )}\n"
    exit 1
  end

  coins = string_coins.map { |sc| sc.to_i }

  coins.sort!

  counts = compute_counts(sum, coins)
  printf "sum = %d, coins = %s, count = %s\n", sum, coins.join(","), counts[sum] || 'insoluble';
end

def compute_counts(sum, coins)
  counts = { 0 => 0 }
  # compute count for each "interim" sum from 1 - sum
  1.upto(sum).each do |i|
    coins.each do |c|
      # if this coin + coins for interim - this coin is < current count for interim, remember it
      if c <= i && ! counts[i - c].nil? && (counts[i].nil? || counts[i - c] + 1 < counts[i])
        counts[i] = counts[i - c] + 1
      end
    end
  end

  return counts
end

main()
exit 0
