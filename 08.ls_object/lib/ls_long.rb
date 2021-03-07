# frozen_string_literal: true

class LsLong
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
