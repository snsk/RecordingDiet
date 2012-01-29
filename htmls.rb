# -*- coding: utf-8 -*-

$htmlHead = <<'EOFHEAD'
<html>
<head>
<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0">
</head>
<body>
EOFHEAD

$htmlIndex = <<EOFINDEX
#{$htmlHead}
<h2>本日の残り取得可能カロリー </h2>
<hr>
EOFINDEX

$htmlInput = <<EOFINPUT
<hr>
<form action="rdiet.rb" method="get">
食べたもの<input type="text" name="fn"/></br>
そのカロリー<input type="text" name="cal"/></br>
今日の体重<input type="text" name="weight"/></br>
<input type="hidden" name="q" value="set"/>
<input type="submit">
</form>
EOFINPUT
