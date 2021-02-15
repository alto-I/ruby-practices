#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'lib/ls'

terminal_width = `tput cols`.to_i
opt = OptionParser.new
params = { long_format: false, reverse: false, include_dot_file: false }
opt.on('-a') { |v| params[:include_dot_file] = v }
opt.on('-l') { |v| params[:long_format] = v }
opt.on('-r') { |v| params[:reverse] = v }
opt.parse!(ARGV)
if ARGV[0].nil?
  ls = Ls.new(terminal_width: terminal_width, **params)
else
  ls = Ls.new(pathname: ARGV[0], terminal_width: terminal_width, **params)
end
puts ls.output
