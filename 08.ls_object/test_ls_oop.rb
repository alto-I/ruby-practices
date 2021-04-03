# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'ls_oop'

SAMPLE_1 = <<~TEXT.chomp
  Afdsfdg.b           cal_nt.rb           limit.rb            taiyaki.rb
  FizzBuzz.rb         calpre.rb           ls.rb               test
  FizzBuzz_case.rb    dummy               max.rb              test.rb
  Rakefile            env_read.rb         name.rb             twc.rb
  a                   faker.rb            numericinspector.rb unit_minitest.rb
  and_method.rb       filetest.rb         q.txt               unittest.rb
  argv.rb             fizi.rb             range.rb            unittest2.rb
  attr_accessor.rb    flexmock.rb         sample_rspec.rb     wc.rb
  b                   hello-rake.txt      sample_unittest.rb
  bowling.rb          hello.rb            score.rb
  cal.rb              hellolink.rb        srcdist
TEXT

SAMPLE_2 = <<~TEXT.chomp
  Afdsfdg.b           env_read.rb         range.rb
  FizzBuzz.rb         faker.rb            sample_rspec.rb
  FizzBuzz_case.rb    filetest.rb         sample_unittest.rb
  Rakefile            fizi.rb             score.rb
  a                   flexmock.rb         srcdist
  and_method.rb       hello-rake.txt      taiyaki.rb
  argv.rb             hello.rb            test
  attr_accessor.rb    hellolink.rb        test.rb
  b                   limit.rb            twc.rb
  bowling.rb          ls.rb               unit_minitest.rb
  cal.rb              max.rb              unittest.rb
  cal_nt.rb           name.rb             unittest2.rb
  calpre.rb           numericinspector.rb wc.rb
  dummy               q.txt
TEXT

SAMPLE_3 = <<~TEXT.chomp
  Afdsfdg.b           hellolink.rb
  FizzBuzz.rb         limit.rb
  FizzBuzz_case.rb    ls.rb
  Rakefile            max.rb
  a                   name.rb
  and_method.rb       numericinspector.rb
  argv.rb             q.txt
  attr_accessor.rb    range.rb
  b                   sample_rspec.rb
  bowling.rb          sample_unittest.rb
  cal.rb              score.rb
  cal_nt.rb           srcdist
  calpre.rb           taiyaki.rb
  dummy               test
  env_read.rb         test.rb
  faker.rb            twc.rb
  filetest.rb         unit_minitest.rb
  fizi.rb             unittest.rb
  flexmock.rb         unittest2.rb
  hello-rake.txt      wc.rb
  hello.rb
TEXT

SAMPLE_4 = <<~TEXT.chomp
  Afdsfdg.b
  FizzBuzz.rb
  FizzBuzz_case.rb
  Rakefile
  a
  and_method.rb
  argv.rb
  attr_accessor.rb
  b
  bowling.rb
  cal.rb
  cal_nt.rb
  calpre.rb
  dummy
  env_read.rb
  faker.rb
  filetest.rb
  fizi.rb
  flexmock.rb
  hello-rake.txt
  hello.rb
  hellolink.rb
  limit.rb
  ls.rb
  max.rb
  name.rb
  numericinspector.rb
  q.txt
  range.rb
  sample_rspec.rb
  sample_unittest.rb
  score.rb
  srcdist
  taiyaki.rb
  test
  test.rb
  twc.rb
  unit_minitest.rb
  unittest.rb
  unittest2.rb
  wc.rb
TEXT

SAMPLE_5 = <<~TEXT.chomp
  total 3552
  -rw-r--r--  1 alto    staff           0  9 26 10:24 Afdsfdg.b
  -rwxrwxrwx  1 alto    staff         264  9 24 21:42 FizzBuzz.rb
  -rwxr--r--  1 alto    staff         231  9 10 19:11 FizzBuzz_case.rb
  -rw-r--r--  1 alto    staff         654  9 20 11:02 Rakefile
  -rw-r--r--  1 daemon  everyone        0  9 27 19:34 a
  -rw-r--r--  1 alto    staff         110  1 20 20:00 and_method.rb
  -rw-r--r--  1 alto    staff          47  9  8 21:29 argv.rb
  -rw-r--r--  1 alto    staff         108 12 14 20:51 attr_accessor.rb
  -rw-r--r--  1 alto    staff           0  9 27 19:35 b
  -rwxr-xr-x  1 alto    staff         723  9 22 21:04 bowling.rb
  -rwxr--r--  1 alto    staff         890  9 15 19:14 cal.rb
  -rw-r--r--  1 alto    staff         567  9 19 14:52 cal_nt.rb
  -rw-r--r--  1 alto    staff         879  9 15 18:18 calpre.rb
  drwxr-xr-x  6 alto    staff         192  2  7 08:41 dummy
  -rw-r--r--  1 alto    staff         258  1  9 08:39 env_read.rb
  -rw-r--r--  1 alto    staff         109 12 13 11:01 faker.rb
  -rw-r--r--  1 alto    staff        1734  9 26 09:47 filetest.rb
  -rw-r--r--  1 alto    staff         150 10  5 20:09 fizi.rb
  -rw-r--r--  1 alto    staff         715  1  9 08:50 flexmock.rb
  -rw-r--r--  1 alto    staff          17  9 20 10:58 hello-rake.txt
  -rwxr--r--  1 alto    staff          60  1 22 21:24 hello.rb
  lrwxr-xr-x  1 alto    staff           8  9 24 21:53 hellolink.rb -> hello.rb
  -rw-r--r--  1 alto    staff          32  9 19 14:47 limit.rb
  -rwxr-xr-x  1 alto    staff        3213  2  4 19:19 ls.rb
  -rw-r--r--  1 alto    staff         461  9 29 07:53 max.rb
  -rw-r--r--  1 alto    staff        1524  9 30 08:02 name.rb
  -rw-r--r--  1 alto    staff         112  1  9 08:16 numericinspector.rb
  -rw-r--r--  1 alto    staff     1680176 11 21 14:44 q.txt
  -rw-r--r--  1 alto    staff         103  9  8 19:15 range.rb
  -rw-r--r--  1 alto    staff         167  1  8 21:02 sample_rspec.rb
  -rw-r--r--  1 alto    staff         398  1  8 21:12 sample_unittest.rb
  -rw-r--r--  1 alto    staff         322  9 21 17:17 score.rb
  drwxr-xr-x  2 alto    staff          64  9 20 09:14 srcdist
  -rwxrwxrwx  1 alto    staff        1774  1 18 19:13 taiyaki.rb
  drwxr-xr-x  4 alto    staff         128  9 24 07:45 test
  -rw-r--r--  1 alto    staff          99 12 17 21:39 test.rb
  -rwxr-xr-x  1 alto    staff          45 10  7 07:02 twc.rb
  -rw-r--r--  1 alto    staff         206  1  8 13:16 unit_minitest.rb
  -rw-r--r--  1 alto    staff         340  1  8 13:11 unittest.rb
  -rw-r--r--  1 alto    staff         635  1  9 08:10 unittest2.rb
  -rwxr-xr-x  1 alto    staff        1429 10  6 21:17 wc.rb
TEXT

SAMPLE_6 = <<~TEXT.chomp
  wc.rb               sample_rspec.rb     flexmock.rb         attr_accessor.rb
  unittest2.rb        range.rb            fizi.rb             argv.rb
  unittest.rb         q.txt               filetest.rb         and_method.rb
  unit_minitest.rb    numericinspector.rb faker.rb            a
  twc.rb              name.rb             env_read.rb         Rakefile
  test.rb             max.rb              dummy               FizzBuzz_case.rb
  test                ls.rb               calpre.rb           FizzBuzz.rb
  taiyaki.rb          limit.rb            cal_nt.rb           Afdsfdg.b
  srcdist             hellolink.rb        cal.rb
  score.rb            hello.rb            bowling.rb
  sample_unittest.rb  hello-rake.txt      b
TEXT

SAMPLE_7 = <<~TEXT.chomp
  .                   b                   hello.rb            srcdist
  ..                  bowling.rb          hellolink.rb        taiyaki.rb
  .DS_Store           cal.rb              limit.rb            test
  .vscode             cal_nt.rb           ls.rb               test.rb
  Afdsfdg.b           calpre.rb           max.rb              twc.rb
  FizzBuzz.rb         dummy               name.rb             unit_minitest.rb
  FizzBuzz_case.rb    env_read.rb         numericinspector.rb unittest.rb
  Rakefile            faker.rb            q.txt               unittest2.rb
  a                   filetest.rb         range.rb            wc.rb
  and_method.rb       fizi.rb             sample_rspec.rb
  argv.rb             flexmock.rb         sample_unittest.rb
  attr_accessor.rb    hello-rake.txt      score.rb
TEXT

SAMPLE_8 = <<~TEXT.chomp
  total 3568
  -rwxr-xr-x    1 alto    staff        1429 10  6 21:17 wc.rb
  -rw-r--r--    1 alto    staff         635  1  9 08:10 unittest2.rb
  -rw-r--r--    1 alto    staff         340  1  8 13:11 unittest.rb
  -rw-r--r--    1 alto    staff         206  1  8 13:16 unit_minitest.rb
  -rwxr-xr-x    1 alto    staff          45 10  7 07:02 twc.rb
  -rw-r--r--    1 alto    staff          99 12 17 21:39 test.rb
  drwxr-xr-x    4 alto    staff         128  9 24 07:45 test
  -rwxrwxrwx    1 alto    staff        1774  1 18 19:13 taiyaki.rb
  drwxr-xr-x    2 alto    staff          64  9 20 09:14 srcdist
  -rw-r--r--    1 alto    staff         322  9 21 17:17 score.rb
  -rw-r--r--    1 alto    staff         398  1  8 21:12 sample_unittest.rb
  -rw-r--r--    1 alto    staff         167  1  8 21:02 sample_rspec.rb
  -rw-r--r--    1 alto    staff         103  9  8 19:15 range.rb
  -rw-r--r--    1 alto    staff     1680176 11 21 14:44 q.txt
  -rw-r--r--    1 alto    staff         112  1  9 08:16 numericinspector.rb
  -rw-r--r--    1 alto    staff        1524  9 30 08:02 name.rb
  -rw-r--r--    1 alto    staff         461  9 29 07:53 max.rb
  -rwxr-xr-x    1 alto    staff        3213  2  4 19:19 ls.rb
  -rw-r--r--    1 alto    staff          32  9 19 14:47 limit.rb
  lrwxr-xr-x    1 alto    staff           8  9 24 21:53 hellolink.rb -> hello.rb
  -rwxr--r--    1 alto    staff          60  1 22 21:24 hello.rb
  -rw-r--r--    1 alto    staff          17  9 20 10:58 hello-rake.txt
  -rw-r--r--    1 alto    staff         715  1  9 08:50 flexmock.rb
  -rw-r--r--    1 alto    staff         150 10  5 20:09 fizi.rb
  -rw-r--r--    1 alto    staff        1734  9 26 09:47 filetest.rb
  -rw-r--r--    1 alto    staff         109 12 13 11:01 faker.rb
  -rw-r--r--    1 alto    staff         258  1  9 08:39 env_read.rb
  drwxr-xr-x    6 alto    staff         192  2  7 08:41 dummy
  -rw-r--r--    1 alto    staff         879  9 15 18:18 calpre.rb
  -rw-r--r--    1 alto    staff         567  9 19 14:52 cal_nt.rb
  -rwxr--r--    1 alto    staff         890  9 15 19:14 cal.rb
  -rwxr-xr-x    1 alto    staff         723  9 22 21:04 bowling.rb
  -rw-r--r--    1 alto    staff           0  9 27 19:35 b
  -rw-r--r--    1 alto    staff         108 12 14 20:51 attr_accessor.rb
  -rw-r--r--    1 alto    staff          47  9  8 21:29 argv.rb
  -rw-r--r--    1 alto    staff         110  1 20 20:00 and_method.rb
  -rw-r--r--    1 daemon  everyone        0  9 27 19:34 a
  -rw-r--r--    1 alto    staff         654  9 20 11:02 Rakefile
  -rwxr--r--    1 alto    staff         231  9 10 19:11 FizzBuzz_case.rb
  -rwxrwxrwx    1 alto    staff         264  9 24 21:42 FizzBuzz.rb
  -rw-r--r--    1 alto    staff           0  9 26 10:24 Afdsfdg.b
  drwxr-xr-x    3 alto    staff          96  1 19 12:52 .vscode
  -rw-r--r--    1 alto    staff        6148  2 11 14:00 .DS_Store
  drwxr-xr-x  100 alto    staff        3200  4  3 07:47 ..
  drwxr-xr-x   45 alto    staff        1440  2 12 21:22 .
TEXT

class LsCommandOopTest < Minitest::Test
  SAMPLE_PATH = Pathname('/Users/alto/bin/')

  def test_call_width80
    ls = Ls::Command.new(pathname: SAMPLE_PATH, terminal_width: 80)
    expected = SAMPLE_1
    assert_equal expected, ls.output
  end

  def test_call_width72
    ls = Ls::Command.new(pathname: SAMPLE_PATH, terminal_width: 72)
    expected = SAMPLE_2
    assert_equal expected, ls.output
  end

  def test_call_width36
    ls = Ls::Command.new(pathname: SAMPLE_PATH, terminal_width: 40)
    expected = SAMPLE_3
    assert_equal expected, ls.output
  end

  def test_call_width1
    ls = Ls::Command.new(pathname: SAMPLE_PATH, terminal_width: 1)
    expected = SAMPLE_4
    assert_equal expected, ls.output
  end

  def test_call_ls_long_format
    ls = Ls::Command.new(pathname: SAMPLE_PATH, long_format: true)
    expected = SAMPLE_5
    assert_equal expected, ls.output
  end

  def test_call_ls_reverse
    ls = Ls::Command.new(pathname: SAMPLE_PATH, terminal_width: 80, reverse: true)
    expected = SAMPLE_6
    assert_equal expected, ls.output
  end

  def test_call_ls_include_dot_file
    ls = Ls::Command.new(pathname: SAMPLE_PATH, terminal_width: 80, include_dot_file: true)
    expected = SAMPLE_7
    assert_equal expected, ls.output
  end

  def test_call_ls_all_options
    ls = Ls::Command.new(pathname: SAMPLE_PATH, terminal_width: 80, long_format: true, reverse: true, include_dot_file: true)
    expected = SAMPLE_8
    assert_equal expected, ls.output
  end
end
