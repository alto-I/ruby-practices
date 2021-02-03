# frozen_string_literal: true

require_relative './ls_long'
require_relative './ls_short'
require 'etc'

class Ls
  attr_reader :pathname, :terminal_width, :long_format, :reverse, :include_dot_file

  def initialize(pathname, terminal_width = 120, long_format: false, reverse: false, include_dot_file: false)
    @pathname = pathname
    @terminal_width = terminal_width
    @long_format = long_format
    @reverse = reverse
    @include_dot_file = include_dot_file
  end

  def output
    files = files_according_to_options
    display_files = long_format ? LsLong.new(files) : LsShort.new(files, terminal_width)
    display_files.run
  end

  private

  def files_according_to_options
    file_path = pathname.join('*')
    files = include_dot_file ? Dir.glob(file_path, File::FNM_DOTMATCH).sort : Dir.glob(file_path).sort
    reverse ? files.reverse : files
  end
end
