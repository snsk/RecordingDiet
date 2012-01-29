#!/usr/local/bin/ruby -Ku
# -*- coding: utf-8 -*-

require 'cgi_exception'
require 'cgi'
require 'csv'
require 'htmls'
require 'date'

qs = CGI.new
TARGETCAL = 2000

print "Content-type: text/html\n\n"

class Renderer
  def index
    print $htmlIndex
  end
end

class CsvMigrator
  def calcRest
    file = open("log.csv")
    lines = file.readlines
    lines.each_with_index {|line, i| #CSV読み込んで二次元配列に変換
      lines[i] = line.split(",")
    }
    todayLines = Array.new() #今日の列を抽出
    lines.each{|line|
      if line.include?(Date.today.strftime) then
        todayLines.push(line)
      end
    }
    p todayLines
  end
  def setValue(foodname, calorie, weight)
    if weight === "" then
      weight = "NaN"
    end
    outfile = File.open('log.csv', 'a')
    CSV::Writer.generate(outfile) do |writer|
      writer << [Date.today, foodname, calorie, weight]
    end
  end
end

class RequestHandller
  def initialize
    @render = Renderer.new()
    @csv = CsvMigrator.new()
  end
  def handleByHash(query)
    if query["q"] === "" then #view index page
      @csv.calcRest()
      @render.index()
    end
    if query["q"] === "set" then
      @csv.setValue(query["fn"], query["cal"], query["we"]) #ex. rdiet.rb?q=set&fn=rice&cal=500
    end
  end
end

req = RequestHandller.new()
req.handleByHash(qs)

#csv = CsvMigrator.new()
#csv.calcRest()

if FileTest.exist?("log.csv") then
  #
else
  print "Please create log file named 'log.csv'. It's first time only"
end
