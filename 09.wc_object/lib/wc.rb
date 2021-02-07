# frozen_string_literal: true

class Wc
  attr_reader :filenames, :text, :line_number_only

  def initialize(filenames: '', text: [], line_number_only: false)
    @filenames = filenames
    @text = text
    @line_number_only = line_number_only
  end

  def output
    counts_values = counts_per_file(@filenames, @text)
    counts_values << total_counts_line(counts_values) if counts_values.size > 1
    lines = counts_values.map do |counts_value|
      line_number_only ? format_only_line(counts_value) : format(counts_value)
    end
    lines.join("\n")
  end

  private

  def counts_per_file(files, text)
    if files.empty?
      [calc_text(nil, text)]
    else
      files.map do |file|
        directory?(file) ? { filename: "wc: #{file}: read: Is a directory" } : calc_text(file, Pathname(file).read)
      end
    end
  end

  def calc_text(file, text)
    {
      filename: " #{file}",
      line: prepare_for_display(line_count(text)),
      word: prepare_for_display(word_count(text)),
      byte: prepare_for_display(bytesize(text))
    }
  end

  def line_count(text)
    text.count("\n")
  end

  def word_count(text)
    lines = text.split("\n")
    lines.map do |line|
      line.split(/[[:space:]]+/).reject(&:empty?)
    end.flatten.size
  end

  def bytesize(text)
    text.bytesize
  end

  def prepare_for_display(value)
    value.to_s.rjust(8)
  end

  def directory?(file)
    File.lstat(file).ftype == 'directory'
  end

  def total_counts_line(counts)
    total_line = { filename: ' total' }
    %i[line word byte].map do |key|
      total_line[key] = prepare_for_display(total_counts(key, counts))
    end
    total_line
  end

  def total_counts(key, counts)
    counts.map do |count|
      count[key].to_i
    end.sum
  end

  def format_only_line(size)
    "#{size[:line]}#{size[:filename].rstrip}"
  end

  def format(size)
    "#{size[:line]}#{size[:word]}#{size[:byte]}#{size[:filename].rstrip}"
  end
end
