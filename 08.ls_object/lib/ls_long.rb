# frozen_string_literal: true

class LsLong
  attr_reader :file

  def initialize(files)
    @files = files
  end

  def run
    files_detail = @files.each.map do |file|
      build_file_data(file)
    end
    max_lengths = find_max_text(files_detail)
    files_detail.each do |file|
      puts formatted_for_display(file, *max_lengths)
    end
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
      linked_file: linked_file(file)
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
    permissions = []
    numbers.each do |number|
      permissions << permission(:"#{number}")
    end
    permissions.join
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

  def timestamp(file)
    timestamps = File.lstat(file).mtime
    "#{timestamps.strftime('%-m').rjust(2)} #{timestamps.strftime('%e %H:%M')}"
  end

  def linked_file(file)
    "-> #{File.readlink(file)}" if filetypes(file) == 'l'
  end

  def find_max_text(files)
    keys = %i[links user group size]
    keys.map do |key|
      files.map do |file|
        file[key].size
      end.max
    end
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
      " #{file[:linked_file]}"
    ].join
  end
end
