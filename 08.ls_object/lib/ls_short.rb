# frozen_string_literal: true

class LsShort
  attr_reader :file

  def initialize(files, terminal_width)
    @files = files
    @terminal_width = terminal_width
  end

  def run
    files_format(basenames, lines, max_filename_length)
  end

  private

  def basenames
    @files.map { |file| File.basename(file) }
  end

  def max_filename_length
    basenames.max_by(&:length).size
  end

  def lines
    column = @terminal_width / (max_filename_length + 1)
    (basenames.size / column.to_f).ceil
  end

  def files_format(filelist, lines, max_filename_length)
    files_matrix = filelist.each_slice(lines).map { |file| file }
    (lines - files_matrix.last.size).times do
      files_matrix.last.push ''
    end
    display_files = files_matrix.transpose
    display_files.map.with_index do |files, i|
      format_lines(files, i)
    end.join("\n")
  end

  def format_lines(files, index)
    files.map do |file|
      file.ljust(max_filename_length + 1)
    end.join.rstrip
  end
end
