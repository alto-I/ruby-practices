#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'pathname'
require './lib/ls'

terminal_width = `tput cols`.to_i
opt = OptionParser.new
params = { long_format: false, reverse: false, include_dot_file: false }
opt.on('-a') { |v| params[:include_dot_file] = v }
opt.on('-l') { |v| params[:long_format] = v }
opt.on('-r') { |v| params[:reverse] = v }
opt.parse!(ARGV)
path = ARGV[0] || '.'
pathname = Pathname(path)

ls = Ls.new(pathname, terminal_width, **params)
ls.output
