# frozen_string_literal: true

class LsShort
  attr_reader :file

  def initialize(files, terminal_width)
    @files = files
    @terminal_width = terminal_width
  end

  def run
    basenames = @files.map { |file| File.basename(file) }
    max_filename_length = basenames.max_by(&:length).size
    column = @terminal_width / (max_filename_length + 1)
    row = (basenames.size / column.to_f).ceil
    files_format(basenames, row, max_filename_length)
  end

  private

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
