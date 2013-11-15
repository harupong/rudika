#!/usr/bin/env ruby

require 'date'
require 'yaml'

module Rudika
  class Scheduler

    attr_reader :schedules

    def initialize(schedules)
      @schedules = schedules || []
    end

    def ask(question)
      print question
      STDIN.gets.chomp
    end

    def exists?(station)
      exist_stations = NHK_LIST.keys + RADIKO_LIST.keys
      exist_stations.include?(station)
    end

    def add_schedule
      schedule = {
        "station" => ask("Enter the station:"),
        "frequency" => ask("Enter the frequency. Daily, Weekly, Monthly[D,W,M]:"),
        "inputtime" => ask("Enter the date[YYYY-MM-DD hh:mm]:")
      }

      if exists?(schedule["station"])
        add(schedule)
        update_whenever
      else
        abort ("invalid station name. try `list` command.")
      end
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
end
