#!/usr/bin/env ruby

require 'thor'
require 'date'
require './lib/stations'

class Rudika < Thor

  def initialize(args = [], options = {}, config = {})
    super
    @nhk_list = get_nhk_stations
    @radiko_list = get_radiko_stations
  end

  desc "rec", "rip and record the stream from Radiko/NHK"
  option :station, :required => true, :aliases => "-s"
  def rec
    nhk = @nhk_list.keys
    radiko = @radiko_list.keys
    station = options[:station]

    case station
    when *nhk
      system ("ripdiru #{station}")
    when *radiko
      system ("ripdiko #{station}")
    else
      puts "invalid station name. try `list` command."
    end
  end

  desc "list", "lists all available stations"
  def list
    all_stations = @nhk_list.merge(@radiko_list)

    all_stations.each.with_index(1) do |a, id|
      puts "#{id}: #{a}"
    end
  end

  desc "schedule", "schedules a recording"
  option :add, :type => :boolean, :aliases => "-a"
  option :delete, :type => :boolean, :aliases => "-d"
  option :show, :type => :boolean, :default => true, :aliases => "-s"
  def schedule
    case
    when options[:add]
      add_schedule
    when options[:delete]
      delete_schedule
    when options[:show]
      system ("whenever -f")
    end
  end

  protected

  def add_whenever_config(str)
    File.open("config/schedule.rb","a") do |file|
        file.write("#{str}\n")
    end
  end

  def add_schedule
    print "Enter the station:"
      station = STDIN.gets.chomp.upcase
    print "Enter the frequency. Daily, Weekly, Monthly[D,W,M]:"
      frequency = STDIN.gets.chomp.upcase
    print "Enter the date[YYYY-MM-DD hh:mm]:"
      inputtime = STDIN.gets.chomp
      t = DateTime.strptime("#{inputtime}:00+0900", '%Y-%m-%d %H:%M:%S%z')
      dayofmonth = t.day
      monthname =Date::MONTHNAMES[t.month]
      dayname = Date::DAYNAMES[t.wday]
      starttime = "#{t.hour}:#{t.minute}"

    case frequency
    when "D"
      str = "every 1.day, :at => '#{starttime}' do command \"rudika rec -s #{station}\" end"
    when "W"
      str = "every :#{dayname}, :at => '#{starttime}' do command \"rudika rec -s #{station}\" end"
    when "M"
      # must pass monthname to :at symbol so that `whenever` can parse it correctly
      # https://github.com/javan/whenever/issues/13#issuecomment-18869
      str = "every 1.month, :at => '#{monthname} #{dayofmonth} #{starttime}' do command \"rudika rec -s #{station}\" end"
    end

    add_whenever_config(str)
    system ("whenever -i")
  end

  def delete_schedule
    print "are you sure to delete schedule?[Yn]:"
      delete_confirmation = STDIN.gets.chomp
      case delete_confirmation.upcase
      when "Y"
        puts "YES"
      else
        puts "NO"
      end
  end
end
