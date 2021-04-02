# frozen_string_literal: true

require 'etc'
require 'pathname'

class Ls
  attr_reader :pathname, :terminal_width, :long_format, :reverse, :include_dot_file

  def initialize(pathname: '.', terminal_width: 120, long_format: false, reverse: false, include_dot_file: false)
    @pathname = Pathname(pathname)
    @terminal_width = terminal_width
    @long_format = long_format
    @reverse = reverse
    @include_dot_file = include_dot_file
  end

  def output
    files = files_according_to_options
    display_files = long_format ? Long.new(files) : Short.new(files, terminal_width)
    display_files.call
  end

  private

  def files_according_to_options
    file_path = pathname.join('*')
    files = include_dot_file ? Dir.glob(file_path, File::FNM_DOTMATCH) : Dir.glob(file_path)
    reverse ? files.sort.reverse : files.sort
  end
end

class Ls::Long
  PERMISSION = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx'].freeze

  def initialize(files)
    @files = files
  end

  def call
    file_details = @files.map { |file| build_file_data(file) }
    max_lengths = max_lengths(file_details)
    total = file_details.sum { |file| file[:block].to_i }
    total_line = "total #{total}"
    body = file_details.map { |file| formatted_for_display(file, *max_lengths) }
    [total_line, *body].join("\n")
  end

  private

  def build_file_data(file)
    {
      type: filetypes(file),
      permission: permissions(file),
      links: File.lstat(file).nlink.to_s,
      user: Etc.getpwuid(File.lstat(file).uid).name,
      group: Etc.getgrgid(File.lstat(file).gid).name,
      size: File.lstat(file).size.to_s,
      timestamp: timestamp(file),
      file: File.basename(file),
      linked_file: linked_file(file),
      block: File.lstat(file).blocks.to_i
    }
  end

  def filetypes(file)
    case File.lstat(file).ftype
    when 'link'
      'l'
    when 'directory'
      'd'
    else
      '-'
    end
  end

  def permissions(file)
    numbers = File.lstat(file).mode.to_s(8)[-3..-1].chars
    numbers.map { |n| PERMISSION[n.to_i] }.join
  end

  def timestamp(file)
    timestamp = File.lstat(file).mtime
    "#{timestamp.strftime('%-m').rjust(2)} #{timestamp.strftime('%e %H:%M')}"
  end

  def linked_file(file)
    FileTest.symlink?(file) ? " -> #{File.readlink(file)}" : ''
  end

  def max_lengths(files)
    keys = %i[links user group size]
    keys.map { |key| files.map { |file| file[key].size }.max }
  end

  def formatted_for_display(file, links_max_length, user_max_length, group_max_length, size_max_length)
    [
      file[:type],
      file[:permission],
      "  #{file[:links].rjust(links_max_length)}",
      " #{file[:user].ljust(user_max_length)}",
      "  #{file[:group].ljust(group_max_length)}",
      "  #{file[:size].rjust(size_max_length)}",
      " #{file[:timestamp]}",
      " #{file[:file]}",
      file[:linked_file]
    ].join
  end
end

class Ls::Short
  def initialize(files, terminal_width)
    @basenames = files.map { |file| File.basename(file) }
    @terminal_width = terminal_width
  end

  def call
    files_matrix = @basenames.each_slice(lines).map { |file| file }
    (lines - files_matrix.last.size).times do
      files_matrix.last.push ''
    end
    display_files = files_matrix.transpose
    display_files.map { |file| format_lines(file) }.join(("\n"))
  end

  private

  def lines
    (@basenames.size / columns).ceil
  end

  def columns
    cols = @terminal_width / (max_filename_length + 1)
    cols.zero? ? 1.0 : cols.to_f
  end

  def max_filename_length
    @max_filename_length ||= @basenames.max_by(&:length).size
  end

  def format_lines(files)
    files.map { |file| file.ljust(max_filename_length + 1) }.join.rstrip
  end
end
