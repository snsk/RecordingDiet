# -*- coding: utf-8 -*-
## HTML エスケープ
def _esc_html(s)
  s.to_s.gsub(/&/,'&amp;').gsub(/</,'&lt;').gsub(/>/,'&gt;').gsub(/"/,'&quot;')
end

## 例外を HTML で表示する
def _print_exception(ex)
  arr = ex.backtrace
  print "<pre style=\"color:#CC0000\">"
  print "<b>#{_esc_html arr[0]}: #{_esc_html ex.message} (#{ex.class.name})</b>\n"
  block = proc {|s| print "        from #{_esc_html s}\n" }
  max = 20
  if arr.length <= max
    arr[1..-1].each(&block)
  else
    n = 5
    arr[1..(max-n)].each(&block)
    print "           ...\n"
    arr[-n..-1].each(&block)
  end
  print "</pre>"
end

## HTTP ヘッダーを表示する
def _print_http_header()
  print "Status: 500 Internal Error\r\n"
  print "Content-Type: text/html\r\n"
  print "\r\n"
end

## HTTP Header を出力したかどうかを調べるために、
## $stdout.write() をオーバーライドする
class << $stdout
  def write(*args)
    $_header_printed = true
    super(*args)
  end
end

$_header_printed = false

## プロセス終了時、もし例外が発生していればそれを
## ブラウザに表示する
at_exit do
  if $!
    _print_http_header() unless $_header_printed
    _print_exception($!)
  end
end
