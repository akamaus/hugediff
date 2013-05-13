#!/usr/bin/ruby

require 'pathname'

load 'huge_diff.rb'

case
when ARGV.length != 2
  $stderr.puts "Usage:\nruby main.rb <file1> <file2>"
when !Pathname(ARGV[0]).file?
  $stderr.puts "first argument must be a file"
when !Pathname(ARGV[1]).file?
  $stderr.puts "second argument must be a file"
else
  if ENV['PIECE_SIZE']
    piece_size = ENV['PIECE_SIZE'].to_i # Block size for sorting algo (in lines), reverse proportional to memory usage
  else
    piece_size = 200000
  end
  hd = HugeDiff.new(File.new(ARGV[0]).lines.each, File.new(ARGV[1]).lines.each, piece_size)
  hd.diff(Proc.new { |f| puts "#{f.strip} was deleted"}, Proc.new { |f| puts "#{f.strip} was created"})
end
