# frozen_string_literal: true

class LsShort
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
    display_files.map { |f| format_lines(f) }.join(("\n"))
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
    files.map { |f| f.ljust(max_filename_length + 1) }.join.rstrip
  end
end
