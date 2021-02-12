# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'

require './lib/wc'

class WcOopTest < Minitest::Test
  EXAMPLE_FILE = ['ls.rb'].freeze
  EXAMPLE_FILES = ['ls.rb', 'dummy', 'bowling.rb', 'fizzbuzz.rb'].freeze
  EXAMPLE_TEXT = <<~TEXT.chomp
    total 48
    -rw-r--r--  1 alto  staff   723  2  4 12:37 bowling.rb
    drwxr-xr-x  2 alto  staff    64  2  4 12:37 dummy
    -rw-r--r--  1 alto  staff   264  2  4 12:37 fizzbuzz.rb
    drwxr-xr-x  3 alto  staff    96  2  3 22:35 lib
    -rwxrwxrwx  1 alto  staff  3213  2  4 19:19 ls.rb
    -rw-r--r--  1 alto  staff  1567  2  6 22:04 test_wc_oop.rb
    -rw-r--r--  1 alto  staff  2166  2  3 22:16 wc.rb
    -rwxrwxrwx  1 alto  staff   352  2  6 21:48 wc_oop.rb

  TEXT

  def test_single_file_non_option
    wc = Wc.new(filenames: EXAMPLE_FILE)
    expected = '     129     310    3213 ls.rb'
    assert_equal expected, wc.output
  end

  def test_single_file_l_option
    wc = Wc.new(filenames: EXAMPLE_FILE, line_number_only: true)
    expected = '     129 ls.rb'
    assert_equal expected, wc.output
  end

  def test_multiple_file_non_option
    wc = Wc.new(filenames: EXAMPLE_FILES)
    expected = <<~TEXT.chomp
           129     310    3213 ls.rb
      wc: dummy: read: Is a directory
            39     112     723 bowling.rb
            15      34     264 fizzbuzz.rb
           183     456    4200 total
    TEXT
    assert_equal expected, wc.output
  end

  def test_multiple_file_l_option
    wc = Wc.new(filenames: EXAMPLE_FILES, line_number_only: true)
    expected = <<~TEXT.chomp
           129 ls.rb
      wc: dummy: read: Is a directory
            39 bowling.rb
            15 fizzbuzz.rb
           183 total
    TEXT
    assert_equal expected, wc.output
  end

  def test_standard_input_no_option
    wc = Wc.new(text: EXAMPLE_TEXT, line_number_only: false)
    expected = '       9      74     431'
    assert_equal expected, wc.output
  end

  def test_standard_input_l_option
    wc = Wc.new(text: EXAMPLE_TEXT, line_number_only: true)
    expected = '       9'
    assert_equal expected, wc.output
  end

  def test_standard_input_and_single_file_no_option
    wc = Wc.new(filenames: EXAMPLE_FILE, text: EXAMPLE_TEXT)
    expected = '     129     310    3213 ls.rb'
    assert_equal expected, wc.output
  end
end
