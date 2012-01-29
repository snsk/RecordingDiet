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

class CsvMigrator
  def calcRest #TARGETCAL から今日取得したカロリー　を引いた値を返す
    file = open("log.csv")
    lines = file.readlines
    lines.each_with_index {|line, i|
      lines[i] = line.split(",")
    }
    todayLines = Array.new()
    lines.each{|line|
      if line.include?(Date.today.strftime) then
        todayLines.push(line)
      end
    }
    todayTotalCal = 0
    todayLines.each{|line|
      todayTotalCal += line[2].to_i
    }
    return TARGETCAL - todayTotalCal
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
      @render.index()
      @render.input()
    end
    if query["q"] === "set" then
      @csv.setValue(query["fn"], query["cal"], query["we"]) #ex. rdiet.rb?q=set&fn=rice&cal=500
    end
  end
end

class Renderer
  def initialize
    @csv = CsvMigrator.new()
  end
  def index
    print $htmlIndex
    print "<div style='font-size:300%'>" << @csv.calcRest().to_s << " kcal</div>"
  end
  def input
    print $htmlInput
  end
end


req = RequestHandller.new()
req.handleByHash(qs)

if FileTest.exist?("log.csv") then
  #
else
  print "Please create log file named 'log.csv'. It's first time only"
end
