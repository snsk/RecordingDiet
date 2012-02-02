#!/usr/local/bin/ruby -Ku
# -*- coding: utf-8 -*-

require 'cgi_exception'
require 'cgi'
require 'csv'
require 'htmls'
require 'date'
TARGETCAL = 2000

class CsvMigrator #CSVをごにょごにょするひと
  def initialize
    file = open("log.csv")    
    @lines = file.readlines 
    @lines.each_with_index {|line, i|
      @lines[i] = line.split(",")
    }
  end
  def getRecentFoods(num) #TODO
  end
  def calcRest(whens) #TARGETCAL から今日取得したカロリー　を引いた値を返す
    todayLines = Array.new()
    @lines.each{|line|
      if whens === "today" then
        if line.include?(Date.today.strftime) then
          todayLines.push(line)
        end
      else if whens === "yesterday" then 
             ydate = Date.today - 1
             if line.include?(ydate.strftime) then
               todayLines.push(line)
             end
           end
      end
    }
    totalCal = 0
    todayLines.each{|line|
      totalCal += line[2].to_i
    }
    if whens === "today" then
      return TARGETCAL - totalCal
    else if whens === "yesterday" then
           return totalCal
         end
    end
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

class RequestHandller #リクエストをさばくひと
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
      @render.returnIndex()
    end
  end
end

class Renderer #HTMLを書きだすひと
  def initialize
    @csv = CsvMigrator.new()
  end
  def index
    print $htmlIndex
    print "<div style='font-size:300%'>" << @csv.calcRest("today").to_s << " kcal</div>"
    print "<div style='font-size:100%'>昨日の合計: " << @csv.calcRest("yesterday").to_s << " kcal</div>"
    print "目標摂取カロリー: " << TARGETCAL.to_s << " kcal"
  end
  def input
    print $htmlInput
  end
  def returnIndex
    print "<meta http-equiv='refresh' content='1;URL=rdiet.rb'>"
  end
end

#main

print "Content-type: text/html\n\n"
req = RequestHandller.new()
qs = CGI.new
req.handleByHash(qs)

if FileTest.exist?("log.csv") then
  #
else
  print "Please create log file named 'log.csv'. It's first time only"
end
