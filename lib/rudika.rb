#!/usr/bin/env ruby

require 'thor'
require 'date'
require 'yaml'
require 'erb'

file = open("config/stations.yaml")
NHK_LIST, RADIKO_LIST = YAML.load_stream(file)
file.close

class Rudika < Thor

  def initialize(args = [], options = {}, config = {})
    super
  end

  desc "rec", "rip and record the stream from Radiko/NHK"
  option :station, :required => true, :aliases => "-s"
  def rec
    nhk = NHK_LIST.keys
    radiko = RADIKO_LIST.keys
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
    all_stations = NHK_LIST.merge(RADIKO_LIST)

    all_stations.each.with_index(1) do |a, id|
      puts "#{id}: #{a}"
    end
  end

  desc "schedule", "schedules a recording"
  option :add, :type => :boolean, :aliases => "-a"
  option :delete, :type => :boolean, :aliases => "-d"
  option :show, :type => :boolean, :default => true, :aliases => "-s"
  def schedule
    schedules = open("config/rudika.yaml") do |file|
      YAML.load(file)
    end

    scheduler = Scheduler.new(schedules)

    case
    when options[:add]
      scheduler.add_schedule
    when options[:delete]
      scheduler.delete_schedule
    when options[:show]
      system ("whenever -f")
    end
  end
end

class Scheduler

  attr_reader :schedules

  def initialize(schedules)
    @schedules = schedules || []
  end

  def ask(question)
    print question
    STDIN.gets.chomp
  end

  def add_schedule
    schedule = {
      "station" => ask("Enter the station:"),
      "frequency" => ask("Enter the frequency. Daily, Weekly, Monthly[D,W,M]:"),
      "inputtime" => ask("Enter the date[YYYY-MM-DD hh:mm]:")
    }

    add(schedule)
    update_whenever
  end

  def delete_schedule
    unless @schedules.empty?
      @schedules.each.with_index do |s, i|
        puts "#{i}: #{s}"
      end
      id = ask("Select the schedule you want to delete:")
      delete(id.to_i)
      update_whenever
    else
      abort "No schedule to delete."
    end
  end

  def update_whenever
    overwrite_yaml
    overwrite_whenever_config
    system("whenever -i")
  end

  def add(schedule)
    @schedules.push(schedule)
  end

  def delete(pos)
    @schedules.delete_at(pos)
  end

  def overwrite_yaml
    open("config/rudika.yaml", "w+") do |file|
      YAML.dump(@schedules, file)
    end
  end

  def overwrite_whenever_config
    template = <<EOS
# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
# uncomment the line below if you wish to use zsh for cron jobs for rudika
# set :job_template, "/usr/bin/zsh -l -c ':job'"

job_type :record, 'cd :path && bundle exec ./rudika rec -s :task'
EOS

    str = "\n"
    @schedules.each do |s|
      formatedtime = DateTime.parse(s["inputtime"])
      starttime = "#{formatedtime.hour}:#{formatedtime.minute}"
      dayname = Date::DAYNAMES[formatedtime.wday]
      monthname = Date::MONTHNAMES[formatedtime.month]
      dayofmonth = formatedtime.day
      station = s["station"]

      case s["frequency"]
      when "D"
        str.concat("every 1.day, :at => '#{starttime}' do record \"#{station}\" end\n")
      when "W"
        str.concat("every :#{dayname}, :at => '#{starttime}' do record \"#{station}\" end\n")
      when "M"
      # must pass monthname to :at symbol so that `whenever` can parse it correctly
      # https://github.com/javan/whenever/issues/13#issuecomment-18869
        str.concat(
          "every 1.month, :at => '#{monthname} #{dayofmonth} #{starttime}' do record \"#{station}\" end\n"
        )
      end
    end

    whenever_schedule = template.concat(str)
    open("config/schedule.rb", "w+") do |file|
      file.write(whenever_schedule)
    end
  end
end
