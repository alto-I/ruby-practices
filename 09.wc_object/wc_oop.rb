#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'pathname'

require './lib/wc'

opt = OptionParser.new
params = { line_number_only: false }
opt.on('-l') { |v| params[:line_number_only] = v }
opt.parse!(ARGV)
filenames = ARGV
text = $stdin.read if filenames.empty?
wc = Wc.new(filenames: filenames, text: text, **params)
puts wc.output
