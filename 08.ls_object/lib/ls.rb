# frozen_string_literal: true

require 'etc'

class Ls
  attr_reader :pathname, :terminal_width , :long_format, :reverse, :include_dot_file

  def initialize(pathname, terminal_width = 120, long_format: false, reverse: false, include_dot_file: false)
    @pathname = pathname
    @terminal_width = terminal_width
    @long_format = long_format
    @reverse = reverse
    @include_dot_file = include_dot_file
  end

  def output
    files = get_files_according_to_options
    long_format ? long_ls_command(files) : short_ls_command(files)
  end

  def long_ls_command(files)
    row_data = files.each.map do |file|
      build_file_data(file)
    end
    max_lengths = find_max_text(row_data)
    row_data.each do |row|
      puts formatted_for_display(row, *max_lengths)
    end
  end

  def find_max_text(rows)
    keys = %i[links user group size]
    keys.map do |key|
      rows.map do |row|
        row[key].size
      end.max
    end
  end

  def formatted_for_display(row, links_max_length, user_max_length, group_max_length, size_max_length)
    [
      row[:type],
      row[:permission],
      "  #{row[:links].rjust(links_max_length)}",
      " #{row[:user].ljust(user_max_length)}",
      "  #{row[:group].ljust(group_max_length)}",
      "  #{row[:size].rjust(size_max_length)}",
      " #{row[:timestamp]}",
      " #{row[:file]}",
      " #{row[:linked_file]}",
    ].join
  end

  def build_file_data(file)
    { 
      type: get_filetypes(file),
      permission: get_permissions(file),
      links: File.lstat(file).nlink.to_s,
      user: Etc.getpwuid(File.lstat(file).uid).name,
      group: Etc.getgrgid(File.lstat(file).gid).name,
      size: File.lstat(file).size.to_s,
      timestamp: get_timestamp(file),
      file: File.basename(file),
      linked_file: get_linked_file(file)
    }
  end

  def get_filetypes(file)
    case File.lstat(file).ftype
                   when 'link'
                     'l'
                   when 'directory'
                     'd'
                   else
                     '-'
                   end
  end

  def get_linked_file(file)
    "-> #{File.readlink(file)}" if get_filetypes(file) == 'l'
  end

  def get_permissions(file)
    filepermissions_number = File.lstat(file).mode.to_s(8)[-3..-1].chars
    filepermissions = []
    filepermissions_number.each do |file|
      filepermissions << permission(:"#{file}")
    end
    filepermissions.join
  end

  def permission(num)
    {
      '7': 'rwx',
      '6': 'rw-',
      '5': 'r-x',
      '4': 'r--',
      '3': '-wx',
      '2': '-w-',
      '1': '--x',
      '0': '---'
    }[num]
  end

  def get_timestamp(file)
    timestamps = File.lstat(file).mtime
    "#{timestamps.strftime('%-m').rjust(2)} #{timestamps.strftime('%e %H:%M')}"
  end


  def short_ls_command(files)
    basenames = files.map { |file| File.basename(file) }
    max_filename_length = basenames.max_by(&:length).size
    column = terminal_width / (max_filename_length + 1)
    row = (basenames.size / column.to_f).ceil
    files_format(basenames, row, max_filename_length)
  end

  def get_files_according_to_options
    file_path = pathname.join('*')
    files = include_dot_file ? Dir.glob(file_path, File::FNM_DOTMATCH).sort : Dir.glob(file_path).sort
    reverse ? files.reverse : files
  end

  def files_format(filelist, row, max_filename_length)
    files_matrix = []
    filelist.each_slice(row) do |file|
      files_matrix << file
    end
    (row - files_matrix.last.size).times do
      files_matrix.last.push ''
    end
    display_files = files_matrix.transpose.flatten
    display_files.each_with_index do |file, i|
      print file.ljust(max_filename_length + 1)
      puts '' if ((i + 1) % files_matrix.size).zero?
    end 
  end
end
